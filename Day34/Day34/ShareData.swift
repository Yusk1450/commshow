//
//  ShareData.swift
//  Day34
//
//  Created by ichinose-PC on 2025/03/22.
//

import Foundation

class SharedData {
    static let shared = SharedData()
    //シングルトンパターンで共有インスタンスを作成

    var opacity: [Double] = Array(repeating: 1.0, count: 5)
//    var currentAnchorID: UUID?
    
}



