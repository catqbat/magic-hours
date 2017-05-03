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
	
	var dataSource: LocationDataSource? = nil;
	var locations: [LocationModel] = [];
	
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
		super.init();
		
	}
	
	func getLocations(delegate: @escaping SetLocationDelegate)
	{
		if let savedLocations = loadLocations()
		{
			locations = savedLocations;
		}
		else
		{
			// Load the sample data.
			locations = loadSampleLocations();
		}
		
		self.dataSource = LocationDataSource(locations: locations, delegate: delegate);

	}
	
	private func loadLocations() -> [LocationModel]?
	{
		return NSKeyedUnarchiver.unarchiveObject(withFile: LocationModel.ArchiveURL.path) as? [LocationModel];
	}
	
	func loadSampleLocations() -> [LocationModel]
	{
		
		let locations = [
			LocationModel(latitude: 61.217381, longitude: -149.863129, description: "Anchorage", zip: nil),
			LocationModel(latitude: 34.052235, longitude: -118.243683, description: "Los Angeles", zip: nil),
			LocationModel(latitude: 40.730610, longitude: -73.935242, description: L10n.newYork, zip: nil),
			LocationModel(latitude: 77.4894444, longitude: 69.3322222, description: "Qaanaaq", zip: nil),
			LocationModel(latitude: 46.138927, longitude: -60.193233, description: "Sydney", zip: nil),
			LocationModel(latitude: 35.652832, longitude: 139.839478, description: L10n.tokyo, zip: nil),
			LocationModel(latitude: -54.80191, longitude: -68.302951, description: "Ushuaia", zip: nil),
			LocationModel(latitude: 52.237049, longitude: 21.017532, description: L10n.warsaw, zip: nil),
		];
		
		return locations;

	}
	
	func saveLocations()
	{
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(locations, toFile: LocationModel.ArchiveURL.path);
		
		print("saved locations: \(isSuccessfulSave)");
	}
}
