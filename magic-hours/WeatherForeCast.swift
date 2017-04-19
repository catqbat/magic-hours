//
//  WeatherModel.swift
//  magic-hours
//
//  Created by Agata on 18/04/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation;

class WeatherForeCast
{
	
	static func fetch(lat: Double, lon: Double, completion: @escaping ([String: WeatherModel]) -> Void)
	{
		let urlString = global.getWeatherUrl(lat: lat, lon: lon);
		let url = URL(string: urlString);
		var days = [String: WeatherModel]();
		
		URLSession.shared.dataTask(with:url!)
		{
			(data, _, error) in
			
			if error != nil
			{
				print(error!);
			}
			else
			{
	
				do
				{
		
					let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any];
					
					let dailyConditions = parsedData["daily"] as! [String:AnyObject];
					let daysData = dailyConditions["data"] as! [AnyObject];
			
					for case let dayData in daysData
					{
						let time = dayData["time"] as! Double;
						let date = Date(timeIntervalSince1970: time);
						//let dayDate = Calendar.current.dateComponents([.day, .month, .year], from: date);
						
						let icon = dayData["icon"] as! String;
						let summary = dayData["summary"] as! String;
						let tempMin = dayData["temperatureMin"] as! Double;
						let tempMax = dayData["temperatureMax"] as! Double;

						days[date.dateOnlyString()] = WeatherModel(date:date, icon:icon, summary: summary, tempMin: tempMin, tempMax:tempMax);
			
					}
					
				}
				catch let error as NSError
				{
					print(error);
				}
			}
			
			completion(days);
			
		}.resume()
	}
}
