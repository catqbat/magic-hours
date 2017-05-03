//
//  Extensions.swift
//  magic-hours
//
//  Created by Agata on 10/04/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation;
import UIKit;
extension Double
{
	/// Rounds the double to decimal places value
	func roundTo(places:Int) -> Double
	{
		let divisor = pow(10.0, Double(places));
		return (self * divisor).rounded() / divisor;
	}
}

extension Date
{
	func dateOnlyString() -> String
	{
		let timeFormatter = DateFormatter();
		timeFormatter.dateStyle = .medium;
		timeFormatter.timeStyle = .none;
		
		return timeFormatter.string(from: self);
	}
}

extension String
{
	func trim(_ charactersCount: Int) -> String
	{
		if (self.characters.count <= charactersCount)
		{
			return self;
		}
		
		let start = self.startIndex;
		let end = self.index(self.endIndex, offsetBy: 0 - charactersCount + 1);
		return self[start..<end];
	}
	
	func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat
	{
		let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude);
		
		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil);
		
		return boundingBox.height;
	}
	
	func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat
	{
		let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height);
		
		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
		
		return boundingBox.width;
	}

}


