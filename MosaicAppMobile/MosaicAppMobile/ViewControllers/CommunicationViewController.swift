//
//  CommunicationViewController.swift
//  MosaicAppMobile
//
//  Created by ISHIGO Yusuke on 2025/03/23.
//

import UIKit
import OSCKit

class CommunicationViewController: UIViewController
{
	@IBOutlet weak var imageView: UIImageView!
	
	var markerImage:UIImage?
	var markerID = -1
	
	let speechRecognizer = SpeechRecognizer()
	
    override func viewDidLoad()
	{
        super.viewDidLoad()

		self.imageView.image = self.markerImage
		self.speechRecognizer.delegate = self
    }
	
	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)
		
		self.speechRecognizer.startRecognition()
	}
	
	override func viewDidDisappear(_ animated: Bool)
	{
		super.viewDidDisappear(animated)
		
		self.speechRecognizer.stopRecognition()
	}
	
	@IBAction func closeBtnAction(_ sender: Any)
	{
		if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
		   let rootViewController = windowScene.windows.first?.rootViewController
		{
			rootViewController.dismiss(animated: true)
		}
	}

}

extension CommunicationViewController: SpeechRecognizerDelegate
{
	func didSpeechDetection(speechRecognizer: SpeechRecognizer)
	{
		let client = OSCUdpClient(host: "10.83.26.164", port: 55555)
		if let message = try? OSCMessage(with: "/talk", arguments: [self.markerID])
		{
			if let _ = try? client.send(message)
			{
				print("送信しました")
			}
		}
	}
}

