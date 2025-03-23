//
//  ConfirmViewController.swift
//  MosaicAppMobile
//
//  Created by ISHIGO Yusuke on 2025/03/23.
//

import UIKit

class ConfirmViewController: UIViewController
{
	@IBOutlet weak var bgView: UIView!

	@IBOutlet weak var startBtn: UIButton!
	@IBOutlet weak var returnBtn: UIButton!
	
	@IBOutlet weak var imageView: UIImageView!
	
	var markerImage:UIImage?
	var markerID = -1
	
    override func viewDidLoad()
	{
        super.viewDidLoad()
		
		self.bgView.layer.cornerRadius = 8
		self.bgView.layer.masksToBounds = true
		
		self.imageView.layer.cornerRadius = 16
		self.imageView.layer.masksToBounds = true
		self.imageView.image = self.markerImage
		
    }
    
	@IBAction func startBtnAction(_ sender: Any)
	{
		self.performSegue(withIdentifier: "toStart", sender: nil)
	}
	
	@IBAction func returnBtnAction(_ sender: Any)
	{
		self.dismiss(animated: true)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if let nextViewController = segue.destination as? CommunicationViewController
		{
			nextViewController.markerImage = self.markerImage
			nextViewController.markerID = self.markerID
		}
	}
}
