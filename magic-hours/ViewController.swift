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
	
	//MARK: Actions

	@IBAction func getLocation(_ sender: UIButton)
	{
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		locationManager.requestWhenInUseAuthorization();
		locationManager.startUpdatingLocation();
		locationManager.requestLocation();
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	

	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print("Got user location");
		
		let userLocation:CLLocation = locations[0];
		let long = userLocation.coordinate.longitude;
		let lat = userLocation.coordinate.latitude;

		print("locations = \(lat), \(long)")
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError)
	{
		print("location error");
	}
	



}

