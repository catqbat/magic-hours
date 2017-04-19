//
//  MainViewModel.swift
//  magic-hours
//
//  Created by Agata on 17/04/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation;
import CoreLocation;

typealias GetCurrentLocationCompletion = (_ result: Bool) -> ()


class MainModel : NSObject, CLLocationManagerDelegate
{
	var currentLocation: LocationModel? = nil;
	var locationCompletion: GetCurrentLocationCompletion? = nil;
	
	let locationManager = CLLocationManager();
	
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
	{
		print("location error");
		locationCompletion!(false);
	}
	
	func getLocation(completion: @escaping GetCurrentLocationCompletion)
	{
		self.locationCompletion = completion;
		
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		locationManager.requestWhenInUseAuthorization();
		locationManager.requestLocation();
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
	{
		print("Got user location");
		locationManager.stopUpdatingLocation();
		
		let userLocation:CLLocation = locations[0];
		
		CLGeocoder().reverseGeocodeLocation(userLocation)
		{ (placemarks, error) in
			
			var city:String?;
			var zip:String?;
			
			// Check for errors
			if (error != nil)
			{
				print(error ?? "Unknown Error");
			}
			else
			{
				
				// Get the first placemark from the placemarks array.
				// This is your address object
				if let placemark = placemarks?[0]
				{
					city = placemark.locality;
					zip = placemark.postalCode;
				}
				
			}
			
			print("\(zip) \(city)");
			
			let location = LocationModel(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, description: city, zip: zip);
			
			self.currentLocation = location;
			self.locationCompletion!(true);
		}
		
	}
	
	override init()
	{
		
	}
}
