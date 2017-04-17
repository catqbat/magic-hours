//
//  LocationModel.swift
//  magic-hours
//
//  Created by Agata on 13/04/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation;
import CoreLocation;

class LocationModel
{
	var latitude: Double;
	var longitude: Double;
	var description: String;
	var zip: String?;
	var timeZone: TimeZone? = nil;
	var currentLocalTime: String? = nil;
	
	var currentDay: DayModel? = nil;
	var days = [Date: DayModel]();
	
	let calendar = Calendar.current;
	let timeFormatter:DateFormatter;
	
	var offsetFromLocalTime: TimeInterval? = nil;
	
	init(latitude: Double, longitude: Double, description: String?, zip: String?)
	{
		timeFormatter = DateFormatter();
		timeFormatter.dateStyle = .none;
		timeFormatter.timeStyle = .short;
		
		self.latitude = latitude;
		self.longitude = longitude;
		
		if (description != nil)
		{
			self.description = description!;
		}
		else
		{
			self.description = "unknown location";
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
		
		if let newDay = days[newDate]
		{
			currentDay = newDay;
		}
		else
		{
			addDay(date: newDate);
			currentDay = days[newDate];
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
		
		days[dateOnly] = day;

	}

}
