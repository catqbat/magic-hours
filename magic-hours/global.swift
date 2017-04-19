//
//  global.swift
//  magic-hours
//
//  Created by Agata on 10/04/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation

struct global
{
	static let goldenHourDurationMinutes:Double = 30;
	static let blueHourDurationMinutes:Double = 30;
	
	static let weatherMapUrl = "https://api.darksky.net/forecast";
	static let weatherLang = "en";
	static let weatherUnits = "si";
	
	static func getWeatherUrl(lat: Double, lon: Double) -> String
	{
		return "\(weatherMapUrl)/\(privateData.weatherMapApiKey)/\(lat),\(lon)?exclude=currently,minutely,hourly,alerts,flags&lang=\(weatherLang)&units=\(weatherUnits)";
	}
}
	
