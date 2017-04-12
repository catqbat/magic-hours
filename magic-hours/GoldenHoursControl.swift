//
//  GoldenHoursControl.swift
//  magic-hours
//
//  Created by Agata on 12/04/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import UIKit

enum GoldenHourTime
{
	case morning, evening;
}

@IBDesignable class GoldenHoursControl: UIStackView
{
	//MARK: initializers

	override init(frame: CGRect)
	{
		super.init(frame: frame);
		setView();
	}
	
	required init(coder: NSCoder)
	{
		super.init(coder: coder);
		setView();
	}
	
	func setLabel(_ label: UILabel)
	{
		label.textColor = UIColor.white;
		addArrangedSubview(label);
	}
	
	func setView()
	{
		icon.translatesAutoresizingMaskIntoConstraints = false;
		icon.heightAnchor.constraint(equalToConstant: iconHeight).isActive = true;
		icon.widthAnchor.constraint(equalToConstant: iconHeight).isActive = true;
		icon.contentMode = UIViewContentMode.scaleAspectFit;
		
		addArrangedSubview(icon);
		setLabel(beforeHourLabel);
		setLabel(sunHourLabel);
		setLabel(afterHourLabel);
		
		
		setImage();
		setHoursInLabels();
	}
	
	func setImage()
	{
		let bundle = Bundle(for: type(of: self));
		let morningIcon = UIImage(named: "morning", in: bundle, compatibleWith: self.traitCollection);
		let eveningIcon = UIImage(named:"evening", in: bundle, compatibleWith: self.traitCollection);
		
		if (time == optionMorning)
		{
			self.icon.image = morningIcon;
		}
		else if (time == optionEvening)
		{
			icon.image = eveningIcon;
		}
	}
	
	private func setHoursInLabels()
	{
		beforeHourLabel.text = beforeHour;
		sunHourLabel.text = (time == optionMorning ? "↑" : "↓") + sunHour;
		afterHourLabel.text = afterHour;
	}
	
	func setHours(before: String, sun: String, after:String)
	{
		self.beforeHour = before;
		self.sunHour = sun;
		self.afterHour = after;
		
		setHoursInLabels();
	}
	
	//MARK: properties
	let iconHeight:CGFloat = 60;
	let optionMorning = "morning";
	let optionEvening = "evening";
	
	@IBInspectable var time:String = "morning"
	{
		didSet
		{
			setImage();
		}
	}
	
	@IBInspectable var beforeHour:String = ""
	{
		didSet
		{
			setHoursInLabels();
		}
	}
	
	@IBInspectable var sunHour:String = ""
		{
		didSet
		{
			setHoursInLabels();
		}
	}
	
	@IBInspectable var afterHour:String = ""
		{
		didSet
		{
			setHoursInLabels();
		}
	}
	
	var icon:UIImageView = UIImageView();
	var beforeHourLabel:UILabel = UILabel();
	var sunHourLabel:UILabel = UILabel();
	var afterHourLabel:UILabel = UILabel();

}
