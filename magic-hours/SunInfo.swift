//
//  SunInfo.swift
//  magic-hours
//
//  Created by Agata on 05/04/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation;
import CoreLocation;

extension Double {
	/// Rounds the double to decimal places value
	func roundTo(places:Int) -> Double {
		let divisor = pow(10.0, Double(places))
		return (self * divisor).rounded() / divisor
	}
}

class SunInfo
{
	var sunriseTime:DateComponents?;
	var sunsetTime:DateComponents?;
	var timeZone:TimeZone?;
	
	var isPolarDay:Bool;
	var isPolarNight:Bool;

	
	init(latitude: Double, longtitude: Double, date: Date)
	{
		isPolarDay = false;
		isPolarNight = false;
		
		let calendar = Calendar.current;
		
		let location = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude);
		self.timeZone = TimezoneMapper.latLngToTimezone(location);
		
		if (self.timeZone == nil)
		{
			return;
		}
		
		print(self.timeZone?.description);
		var timeZoneOffset: Double = Double(timeZone!.secondsFromGMT(for: date)) / 3600.0; //hours offset from gmt
		
		//if (timeZone!.isDaylightSavingTime(for: date))
		//{
		//	timeZoneOffset -= 1;
		//}
		
		
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
		let C = (sin(0.017453293 * Req) - sin(0.017453293 * latitude) * sin(A)) / (cos(0.017453293 * latitude) * cos(A));
		
		
		let sunrise = (M_PI - (E + 0.017453293 * longtitude + 1 * acos(C))) * 57.29577951 / 15 + timeZoneOffset;
		let sunpeek = (M_PI - (E + 0.017453293 * longtitude + 0 * acos(C))) * 57.29577951 / 15 + timeZoneOffset;
		let sunset = (M_PI - (E + 0.017453293 * longtitude + -1 * acos(C))) * 57.29577951 / 15 + timeZoneOffset;

	
		if (sunrise.isNaN)
		{
			if (C < 0)
			{
				isPolarDay = true;
			}
			else
			{
				isPolarNight = true;
			}
		
		}
		else
		{
			let hours = calendar.component(.hour, from: date);
			let minutes = calendar.component(.minute, from: date);
			let seconds = calendar.component(.second, from: date);
			
			let secondsFromDatePart = Double(hours * 3600 + minutes * 60 + seconds);
			
			let sunriseDate = date.addingTimeInterval(sunrise * 3600 - secondsFromDatePart);
			let sunsetDate = date.addingTimeInterval(sunset * 3600 - secondsFromDatePart);
			
			sunriseTime = calendar.dateComponents([.hour, .minute], from: sunriseDate);
			sunsetTime = calendar.dateComponents([.hour, .minute], from: sunsetDate);
			
			print("Sunrise \(sunriseTime!.hour):\(sunriseTime!.minute)");
			print("Sunset \(sunsetTime!.hour):\(sunsetTime!.minute)");

			
		}
		
	}
	
}
