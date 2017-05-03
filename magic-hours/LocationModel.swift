//
//  LocationModel.swift
//  magic-hours
//
//  Created by Agata on 13/04/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation;
import CoreLocation;

class LocationModel: NSObject, NSCoding
{
	static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!;
	static let ArchiveURL = DocumentsDirectory.appendingPathComponent("locations");
	
	struct PropertyKey
	{
		static let name = "name";
		static let zip = "zip";
		static let latitude = "latitude";
		static let longitude = "longitude";
	}
	
	func encode(with aCoder: NSCoder)
	{
		aCoder.encode(description, forKey: PropertyKey.name);
		aCoder.encode(zip, forKey: PropertyKey.zip);
		aCoder.encode(latitude, forKey: PropertyKey.latitude);
		aCoder.encode(longitude, forKey: PropertyKey.longitude);
	}
	
	required convenience init?(coder aDecoder: NSCoder)
	{
		
		guard let lat = aDecoder.decodeObject(forKey: PropertyKey.name) as? Double
		else
		{
			return nil;
		}
		
		guard let lon = aDecoder.decodeObject(forKey: PropertyKey.longitude) as? Double
			else
		{
			return nil;
		}
		
		let name = aDecoder.decodeObject(forKey: PropertyKey.name) as! String;
		let zip = aDecoder.decodeObject(forKey: PropertyKey.zip) as! String;
		
		// Must call designated initializer.
		self.init(latitude: lat, longitude: lon, description: name, zip: zip);
		
	}

	
	var latitude: Double = 0;
	var longitude: Double = 0;
	var name: String = "";
	var zip: String?;
	var timeZone: TimeZone? = nil;
	var currentLocalTime: String? = nil;
	
	var currentDay: DayModel? = nil;
	var days = [String: DayModel]();
	
	var weatherDays = [String: WeatherModel]();
	var weatherForeCastIsKnown = false;
	var weatherForeCastIsInProgress = false;
	
	let calendar = Calendar.current;
	var timeFormatter:DateFormatter = DateFormatter();
	
	var offsetFromLocalTime: TimeInterval? = nil;
	
	init(latitude: Double, longitude: Double, description: String?, zip: String?)
	{
		super.init();
		
		timeFormatter = DateFormatter();
		timeFormatter.dateStyle = .none;
		timeFormatter.timeStyle = .short;
		
		self.latitude = latitude;
		self.longitude = longitude;
		
		if (description != nil)
		{
			self.name = description!;
		}
		else
		{
			self.name = "unknown location";
		}
		
		self.zip = zip;
		
		let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
		self.timeZone = TimezoneMapper.latLngToTimezone(location);
	
		if (self.timeZone == nil)
		{
			return;
		}
		
		let currentTime = Date();
		
		let locationOffset = timeZone!.secondsFromGMT(for: currentTime);
		let currentTimeOffset = TimeZone.current.secondsFromGMT(for: currentTime);
		offsetFromLocalTime = TimeInterval(0 - currentTimeOffset + locationOffset);
	
		updateLocalTime();
		addDay(date: nil);
	}
	

	
	func fetchWeatherForecast(completion: @escaping () -> Void)
	{
		if (weatherForeCastIsInProgress)
		{
			return;
		}
		
		weatherForeCastIsInProgress = true;
		
		WeatherForeCast.fetch(lat:latitude, lon:longitude)
		{
			days in
			
			self.weatherDays = days;
			self.weatherForeCastIsInProgress = false;
			self.weatherForeCastIsKnown = true;
			
			completion();
		}
	}
	
	func containsWeather(for date: Date) -> Bool
	{
		print("contains weather for " + date.dateOnlyString());
		return weatherDays[date.dateOnlyString()] != nil;
	}
	
	func getWeather(for date: Date) -> WeatherModel?
	{
		return weatherDays[date.dateOnlyString()]
	}
	
	func updateLocalTime()
	{
		let localTimeDate = Date().addingTimeInterval(offsetFromLocalTime!);
		//currentLocalTime = calendar.dateComponents([.hour, .minute], from: localTimeDate);
		currentLocalTime = timeFormatter.string(from: localTimeDate);

	}
	
	func nextDay()
	{
		newDay(secondsFromCurrentDay: 24*60*60);
	}
	
	func prevDay()
	{
		newDay(secondsFromCurrentDay: 0 - 24*60*60);
	}
	
	func newDay(secondsFromCurrentDay: TimeInterval)
	{
		if (currentDay == nil)
		{
			addDay(date: nil);
		}
		
		let newDate = currentDay!.date.addingTimeInterval(secondsFromCurrentDay);
		
		print(newDate);
		
		if let newDay = days[newDate.dateOnlyString()]
		{
			currentDay = newDay;
		}
		else
		{
			addDay(date: newDate);
			currentDay = days[newDate.dateOnlyString()];
		}
	}
	
	func addDay(date:Date?)
	{
		let currentDT = date == nil ? Date() : date!;
		
		let hours = calendar.component(.hour, from: currentDT);
		let minutes = calendar.component(.minute, from: currentDT);
		let seconds = calendar.component(.second, from: currentDT);
		
		let secondsFromDatePart = Double(hours * 3600 + minutes * 60 + seconds);
		
		let dateOnly = currentDT.addingTimeInterval(0 - secondsFromDatePart);
		
		let day = DayModel(location: self, date: dateOnly);
		
		if (date == nil)
		{
			currentDay = day;
		}
		
		days[dateOnly.dateOnlyString()] = day;

	}

}
