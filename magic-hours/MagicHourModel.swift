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
	
	let calendar = Calendar.current;
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

		
		magicHourDate = date;
		magicHourTime = calendar.dateComponents([.hour, .minute], from: magicHourDate);
	}
}
