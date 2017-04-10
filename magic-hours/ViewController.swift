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
	
	@IBOutlet weak var labelSunrise: UILabel!
	//MARK: Actions
	@IBOutlet weak var labelSunset: UILabel!

	@IBAction func getLocation(_ sender: UIButton)
	{
		
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
		
		let date = Date();
		
		let info = DayModel(latitude: userLocation.coordinate.latitude, longtitude: userLocation.coordinate.longitude, date: date);
		
		labelSunrise.text = "☀️ \(info.sunriseModel!.formatted)";
		labelSunset.text = "🌕 \(info.sunsetModel!.formatted)";
		
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError)
	{
		print("location error");
	}
	



}

