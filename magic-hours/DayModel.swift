//
//  SunInfo.swift
//  magic-hours
//
//  Created by Agata on 05/04/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation;
import CoreLocation;



class DayModel
{
	enum DayType
	{
		case regular, polarDay, polarNight
	}
	
	var location:LocationModel;
	var date:Date;
	
	var dateFormatted: String
	{
		return timeFormatter.string(from: date);
	}
	
	var sunriseModel:MagicHourModel?;
	var sunsetModel:MagicHourModel?;
	
	var morningBlueHourModel:MagicHourModel?;
	var morningGoldenHourModel:MagicHourModel?;
	var eveningBlueHourModel:MagicHourModel?;
	var eveningGoldenHourModel:MagicHourModel?;
	
	var type:DayType = .regular;
	
	let calendar = Calendar.current;
	let timeFormatter:DateFormatter;
	
	init(location: LocationModel, date: Date)
	{
		self.location = location;
		self.date = date;
		
		timeFormatter = DateFormatter();
		timeFormatter.dateStyle = .medium;
		timeFormatter.timeStyle = .none;
		
		let timeZoneOffset: Double = Double(location.timeZone!.secondsFromGMT(for: date)) / 3600.0; //hours offset from gmt
		
		//sun equations magic
		
		let Req = -0.833; //sun angle during surise and sunset
		
		let year:Double = Double(calendar.component(.year, from: date));
		let month:Double = Double(calendar.component(.month, from: date));
		let day:Double = Double(calendar.component(.day, from: date));
		
		let J1 = 367 * year - (7 * (year + ((month + 9) / 12)).roundTo(places:0) / 4).roundTo(places:0);
		let J2 = (275 * month / 9).roundTo(places:0) + day - 730531.5;
	
		
		let J = J1 + J2;
		let Cent = J / 36525;
		let L = (4.8949504201433 + 628.331969753199 * Cent).truncatingRemainder(dividingBy: 6.28318530718);
		let G = (6.2400408 + 628.3019501 * Cent).truncatingRemainder(dividingBy: 6.28318530718);
		let O = 0.409093 - 0.0002269 * Cent;
		let F = 0.033423 * sin(G) + 0.00034907 * sin(2 * G);
		let E = 0.0430398 * sin(2 * (L + F)) - 0.00092502 * sin(4 * (L + F)) - F;
		let A = asin(sin(O) * sin(L + F));
		let C = (sin(0.017453293 * Req) - sin(0.017453293 * location.latitude) * sin(A)) / (cos(0.017453293 * location.latitude) * cos(A));
		
		
		let sunrise = (M_PI - (E + 0.017453293 * location.longitude + 1 * acos(C))) * 57.29577951 / 15 + timeZoneOffset;
		//let sunpeek = (M_PI - (E + 0.017453293 * longtitude + 0 * acos(C))) * 57.29577951 / 15 + timeZoneOffset;
		let sunset = (M_PI - (E + 0.017453293 * location.longitude + -1 * acos(C))) * 57.29577951 / 15 + timeZoneOffset;

	
		if (sunrise.isNaN)
		{
			if (C < 0)
			{
				self.type = .polarDay;
			}
			else
			{
				self.type = .polarNight;
			}
		
		}
		else
		{
			
			sunriseModel = MagicHourModel(date: date.addingTimeInterval(sunrise * 3600));
			
			morningBlueHourModel = MagicHourModel(date: date.addingTimeInterval(sunrise * 3600 - 60 * global.blueHourDurationMinutes));
			
			morningGoldenHourModel = MagicHourModel(date: date.addingTimeInterval(sunrise * 3600 + 60 * global.goldenHourDurationMinutes));
			
			
			sunsetModel = MagicHourModel(date: date.addingTimeInterval(sunset * 3600));
			
			eveningBlueHourModel = MagicHourModel(date: date.addingTimeInterval(sunset * 3600 + 60 * global.blueHourDurationMinutes));
			
			eveningGoldenHourModel = MagicHourModel(date: date.addingTimeInterval(sunset * 3600 - 60 * global.goldenHourDurationMinutes));
			
		}
		
	}
	
}
