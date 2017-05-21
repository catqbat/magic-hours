//
//  LocationCell.swift
//  magic-hours
//
//  Created by Agata on 02/05/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation;
import UIKit;

class LocationCell : UICollectionViewCell
{
	
	@IBOutlet weak var locationNameLabel: UILabel!;
	
	static let locationNameFont:UIFont = UIFont.systemFont(ofSize: 17, weight: UIFontWeightThin);

	var locationName: String
	{
		didSet
		{
			locationNameLabel.text = locationName;
		}
	}
	
	override var isSelected: Bool
	{
		didSet
		{
			locationNameLabel.textColor = isSelected ? UIColor.yellow : UIColor.white;
		}
	}


	required init?(coder aDecoder: NSCoder)
	{
		self.locationName = "";
		super.init(coder: aDecoder);
	}
}
