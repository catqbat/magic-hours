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
