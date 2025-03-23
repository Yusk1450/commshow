//
//  RoundButton.swift
//  MosaicAppMobile
//
//  Created by ISHIGO Yusuke on 2025/03/23.
//

import UIKit

class RoundButton: UIButton
{
	override func awakeFromNib()
	{
		self.layer.cornerRadius = 8
		self.layer.masksToBounds = true
	}

}
