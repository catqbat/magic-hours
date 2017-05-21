//
//  MainViewModel.swift
//  magic-hours
//
//  Created by Agata on 17/04/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation;
import CoreLocation;
import MapKit;

typealias GetCurrentLocationCompletion = (_ result: Bool) -> ()
typealias NavigateToFindLocationDelegate = () -> ()
typealias UpdateViewForLocationDelegate = (_ index: Int?) -> ()

class MainModel : NSObject, CLLocationManagerDelegate
{
	var navigateToFindLocationDelegate: NavigateToFindLocationDelegate? = nil;
	var updateViewForLocationDelegate: UpdateViewForLocationDelegate? = nil;
	
	func NavigateToFindLocation()
	{
		if navigateToFindLocationDelegate != nil
		{
			navigateToFindLocationDelegate!();
		}
	}
	
	var currentLocation: LocationModel? = nil;
	var locationCompletion: GetCurrentLocationCompletion? = nil;
	
	let locationManager = CLLocationManager();
	
	var dataSource: LocationDataSource? = nil;
		
	func containsLocation(placeMark:MKPlacemark) -> Bool
	{
		return containsLocation(zip: placeMark.postalCode, lat: placeMark.coordinate.latitude, lon: placeMark.coordinate.longitude);
	}
	
	func addLocation(_ location: LocationModel, save: Bool) -> Bool
	{
		self.currentLocation = location;
		
		if (containsLocation(zip: location.zip, lat: location.latitude, lon: location.longitude))
		{
			return false;
		}
		
		let index = dataSource!.addLocation(location);
		
		if (updateViewForLocationDelegate != nil)
		{
			updateViewForLocationDelegate!(index);
		}
		
		if (save)
		{
			saveLocations();
		}
		
		return true;
	}
	
	func containsLocation(zip: String?, lat: Double, lon: Double) -> Bool
	{
		return dataSource!.locations.first(where: { ($0.zip != nil && $0.zip == zip) || ($0.latitude == lat && $0.longitude == lon)}) != nil
	}
	
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
			
			var city: String?;
			var zip: String?;
			
			var addNew: Bool = true;
			
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
					
					if (self.containsLocation(zip: zip, lat: userLocation.coordinate.latitude, lon:userLocation.coordinate.longitude))
					{
						addNew = false;
					}
				}
				
			}
			
			print("\(zip) \(city)");
			
			let location = LocationModel(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, description: city, zip: zip);
			
			self.addLocation(location, save: false);
			
			
			self.locationCompletion!(true);
		}
		
	}
	
	override init()
	{
		super.init();
		
	}
	
	func getLocations(delegate: @escaping SetLocationDelegate)
	{
		var locations: [LocationModel] = [];
		
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
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(dataSource!.locations, toFile: LocationModel.ArchiveURL.path);
		
		print("saved locations: \(isSuccessfulSave)");
	}
}
