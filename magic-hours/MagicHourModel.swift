//
//  MagicHourModel.swift
//  magic-hours
//
//  Created by Agata on 10/04/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation
class MagicHourModel
{
	var magicHourTime:DateComponents;
	var magicHourDate:Date;
	
	let timeFormatter:DateFormatter;

	var formatted:String
	{
		return timeFormatter.string(from: magicHourDate);
	}
	
	
	init(date: Date)
	{
		timeFormatter = DateFormatter();
		timeFormatter.dateStyle = .none;
		timeFormatter.timeStyle = .short;

		let calendar = Calendar.current;
		
		magicHourDate = date;
		magicHourTime = calendar.dateComponents([.hour, .minute], from: magicHourDate);
	}
}
