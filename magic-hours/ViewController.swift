//
//  ViewController.swift
//  magic-hours
//
//  Created by Agata on 29/03/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import UIKit;
import CoreLocation;


class ViewController: UIViewController, CLLocationManagerDelegate {
	
	//MARK: Properties
	let locationManager = CLLocationManager();

	//MARK: Outlets
	@IBOutlet weak var morningControl: GoldenHoursControl!
	
	@IBOutlet weak var eveningControl: GoldenHoursControl!
	@IBOutlet weak var locationDescription: UILabel!
	
	//MARK: Actions
	@IBAction func showSettings(_ sender: UITapGestureRecognizer) {
	}
	
	
	
	func getLocation()
	{
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		locationManager.requestWhenInUseAuthorization();
		locationManager.startUpdatingLocation();
		locationManager.requestLocation();
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		getLocation();
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
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
			
			self.locationDescription.text = location.description;
			let info = location.currentDay!;
			
			self.morningControl.setHours(before: info.morningBlueHourModel!.formatted, sun: info.sunriseModel!.formatted, after: info.morningGoldenHourModel!.formatted);
			
			self.eveningControl.setHours(before: info.eveningGoldenHourModel!.formatted, sun: info.sunsetModel!.formatted, after: info.eveningBlueHourModel!.formatted);
			
		}
	
		
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
	{
		print("location error");
	}
	



}

