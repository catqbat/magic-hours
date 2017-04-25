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
	
	static let supportedWeatherLangs =
	[
		"ar",
		"az",
		"be",
		"bg",
		"bs",
		"ca",
		"cs",
		"de",
		"el",
		"en",
		"es",
		"et",
		"fr",
		"hr",
		"hu",
		"id",
		"it",
		"is",
		"kw",
		"nb",
		"nl",
		"pl",
		"pt",
		"ru",
		"sk",
		"sl",
		"sr",
		"sv",
		"tet",
		"tr",
		"uk",
		"x-pig-latin",
		"zh",
		"zh-tw"
	];
	
	static func getWeatherLang() -> String
	{
		if (Locale.current.languageCode == nil)
		{
			return weatherLang;
		}
		
		if (supportedWeatherLangs.contains(Locale.current.languageCode!))
		{
			return Locale.current.languageCode!;
		}
		
		return weatherLang;

	}
	
	static func getWeatherUnits() -> String
	{
		if (Locale.current.usesMetricSystem)
		{
			return "si";
		}
		
		
		
		return	"us";
	}
	
	static func getWeatherUrl(lat: Double, lon: Double) -> String
	{
		return "\(weatherMapUrl)/\(privateData.weatherMapApiKey)/\(lat),\(lon)?exclude=currently,minutely,hourly,alerts,flags&lang=\(getWeatherLang())&units=\(getWeatherUnits())";
	}
	
	static func getTemperatureUnits() -> String
	{
		if (getWeatherUnits() == "si")
		{
			return "°C";
		}
		
		return "°F";
	}
}
	
