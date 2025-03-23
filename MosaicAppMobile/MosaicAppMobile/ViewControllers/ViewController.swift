//
//  ViewController.swift
//  MosaicAppMobile
//
//  Created by ISHIGO Yusuke on 2025/03/22.
//

import UIKit
import OSCKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
	@IBOutlet weak var collectionView: UICollectionView!
		
	let items = ["marker_1", "marker_2", "marker_3", "marker_4", "marker_5"]
	var selectedCellIndex:IndexPath?
		
	func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		self.items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Basic-Cell", for: indexPath)
		
		cell.layer.cornerRadius = 16
		cell.layer.masksToBounds = true
		
		cell.layer.shadowColor = UIColor.init(hexString: "282828").cgColor
		cell.layer.shadowOpacity = 0.2
//		cell.layer.shadowOffset = CGSize(width: 6, height: 6)
		cell.layer.shadowRadius = 12
		
		if let imgView = cell.contentView.viewWithTag(1) as? UIImageView
		{
			imgView.image = UIImage(named: self.items[indexPath.row])
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		self.selectedCellIndex = indexPath
		self.performSegue(withIdentifier: "toConfrim", sender: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		let nextViewController = segue.destination as? ConfirmViewController
		
		if let row = self.selectedCellIndex?.row
		{
			nextViewController?.markerImage = UIImage(named: self.items[row])
			nextViewController?.markerID = row
		}
	}

}
