//
//  Extensions.swift
//  magic-hours
//
//  Created by Agata on 10/04/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation
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
}
