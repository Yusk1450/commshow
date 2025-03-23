//
//  SpeechRecognizer.swift
//  MosaicAppMobile
//
//  Created by ISHIGO Yusuke on 2025/03/22.
//

import UIKit
import AVFoundation
import SoundAnalysis

protocol SpeechRecognizerDelegate: AnyObject
{
	func didSpeechDetection(speechRecognizer:SpeechRecognizer)
}

class SpeechRecognizer: NSObject
{
	weak var delegate:SpeechRecognizerDelegate?
	
	private let audioEngine = AVAudioEngine()
	private var streamAnalyzer: SNAudioStreamAnalyzer?
	private let analysisQueue = DispatchQueue(label: "analysisQueue")
	
	var avgPower:Float = 0.0
	var isRecording = false
	
	func startRecognition()
	{
		if (self.isRecording)
		{
			return
		}
		
		self.isRecording = true
		
		// マイク入力の設定
		let inputNode = self.audioEngine.inputNode
		let inputFormat = inputNode.outputFormat(forBus: 0)
		
		self.streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)
		
		guard let request = try? SNClassifySoundRequest(classifierIdentifier: .version1) else
		{
			return
		}
		
		try? self.streamAnalyzer?.add(request, withObserver: self)
		
		inputNode.installTap(onBus: 0, bufferSize: 8192, format: inputFormat) { buffer, time in
			
			self.analysisQueue.async {
				
				// 音量（RMS）
				var channelData = buffer.floatChannelData?[0]
				let frameLength = Int(buffer.frameLength)
				
				var rms: Float = 0.0
				if let channelData = channelData
				{
					let channelDataArray = Array(UnsafeBufferPointer(start: channelData, count: frameLength))
					let sumOfSquares = channelDataArray.map { $0 * $0 }.reduce(0, +)
					rms = sqrt(sumOfSquares / Float(frameLength))
				}
				
				// dBへの変換
				self.avgPower = 20 * log10(rms)
				
				self.streamAnalyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
			}
		}
		
		self.audioEngine.prepare()
		try? self.audioEngine.start()
	}
	
	func stopRecognition()
	{
		self.audioEngine.stop()
		self.audioEngine.inputNode.removeTap(onBus: 0)
		
		self.isRecording = false
	}
	
	
}

extension SpeechRecognizer: SNResultsObserving
{
	func request(_ request: any SNRequest, didProduce result: any SNResult)
	{
		guard let result = result as? SNClassificationResult else
		{
			return
		}
		
		let confidence = result.classification(forIdentifier: "speech")?.confidence ?? 0.0
		
		DispatchQueue.main.async {
			
//			print(confidence)
//			print(self.avgPower)
			
			if (confidence > 0.6 && self.avgPower > -25.0)
			{
				print("会話中です")
				self.delegate?.didSpeechDetection(speechRecognizer: self)
			}
			else
			{
				print("無音")
			}

		}
	}
	
	
}
