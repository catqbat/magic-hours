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
	var timeZone:TimeZone? = nil;
	var currentLocalTime: DateComponents? = nil;
	
	var currentDay:DayModel? = nil;
	var days = [Date: DayModel]();
	
	let calendar = Calendar.current;
	
	init(latitude: Double, longitude: Double, description: String?, zip: String?)
	{
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
		
		addDay(date: nil);
		
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
