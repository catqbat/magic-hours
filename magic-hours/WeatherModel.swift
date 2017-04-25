//
//  WeatherModel.swift
//  magic-hours
//
//  Created by Agata on 19/04/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation
class WeatherModel
{
	
	let date: Date;
//	A machine-readable text summary of this data point, suitable for selecting an icon for display. If defined, this property will have one of the following values: clear-day, clear-night, rain, snow, sleet, wind, fog, cloudy, partly-cloudy-day, or partly-cloudy-night. (Developers should ensure that a sensible default is defined, as additional values, such as hail, thunderstorm, or tornado, may be defined in the future.)
	
	let icon: String;
	let summary: String;
	let tempMin: Int;
	let tempMax: Int;
	let temperatureInfo: String;
	
	init(date: Date, icon: String, summary: String, tempMin: Double, tempMax: Double)
	{
		self.date = date;
		self.icon = icon;
		self.summary = summary;
		self.tempMin = Int(round(tempMin));
		self.tempMax = Int(round(tempMax));
		
		self.temperatureInfo = "\(L10n.from) \(self.tempMin) \(L10n.to) \(self.tempMax) \(global.getTemperatureUnits())";
	
		print("\(date.dateOnlyString()), \(icon), \(summary), \(tempMin)-\(tempMax)");
	}
}
