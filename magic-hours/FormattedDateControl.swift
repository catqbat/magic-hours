//
//  FormattedDateControl.swift
//  magic-hours
//
//  Created by Agata on 29/04/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import UIKit

@IBDesignable class FormattedDateControl: UIStackView
{

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
	
	func setView()
	{
		dayOfWeekLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2);
		dayOfWeekLabel.textColor = UIColor.gray;
		dayOfWeekLabel.alpha = 0.3;
		dayOfWeekLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightBold);
		
		monthLabel.textColor = UIColor.white;
		
		dayLabel.textColor = UIColor.black;
		dayLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightThin);
		
		addArrangedSubview(dayOfWeekLabel);
		
		let verticalStack = UIStackView();
		verticalStack.axis = UILayoutConstraintAxis.vertical;
		
		verticalStack.addArrangedSubview(monthLabel);
		verticalStack.addArrangedSubview(dayLabel);
		
		addArrangedSubview(verticalStack);
	}
	
	func formatDate()
	{
		let dateFormatter = DateFormatter();
		
		dateFormatter.dateFormat = "MMM";
		month = dateFormatter.string(from: date).uppercased();
		
		dateFormatter.dateFormat = "dd";
		day = dateFormatter.string(from: date);
		
		dateFormatter.dateFormat = "EEE";
		dayOfWeek = dateFormatter.string(from: date).replacingOccurrences(of: ".", with: "").trim(2).uppercased();

	}
	
	//MARK: properties
	
	var dayLabel:UILabel = UILabel();
	var monthLabel:UILabel = UILabel();
	var dayOfWeekLabel:UILabel = UILabel();
	
	@IBInspectable var dayOfWeek:String = "MON"
	{
		didSet
		{
			dayOfWeekLabel.text = dayOfWeek;
		}
	}
	
	@IBInspectable var day:String = "07"
	{
		didSet
		{
			dayLabel.text = day;
		}
	}
	
	@IBInspectable var month:String = "OCT"
	{
		didSet
		{
			monthLabel.text = month;
		}
	}

	@IBInspectable var date:Date = Date()
	{
		didSet
		{
			formatDate();
		}
	}
}
