//
//  ViewController.swift
//  magic-hours
//
//  Created by Agata on 29/03/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import UIKit;
import CoreLocation;


class ViewController: UIViewController
{
	
	//MARK: Properties
	let mainModel = MainModel();

	//MARK: Outlets
	@IBOutlet weak var morningControl: GoldenHoursControl!
	
	@IBOutlet weak var eveningControl: GoldenHoursControl!
	@IBOutlet weak var locationDescription: UILabel!
	
	@IBOutlet weak var locationLocalTime: UILabel!
	@IBOutlet weak var locationCurrentDayDate: UILabel!
	
	//MARK: Actions
	@IBAction func showSettings(_ sender: UITapGestureRecognizer)
	{
	}
	
	@IBAction func showPrevDay(_ sender: UISwipeGestureRecognizer)
	{
		mainModel.currentLocation?.prevDay();
		setLocationDay(mainModel.currentLocation!.currentDay!);
	}
	
	@IBAction func showNextDay(_ sender: UISwipeGestureRecognizer)
	{
		mainModel.currentLocation?.nextDay();
		setLocationDay(mainModel.currentLocation!.currentDay!);
	}
	
	
	
	override func viewDidLoad()
	{
		super.viewDidLoad();
		
		mainModel.getLocation
		{
				result in
			
				if (result == true)
				{
					self.setLocation(self.mainModel.currentLocation!);
				}
				else
				{
					// there was an error that should be handled
				}
		}
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	func setLocation(_ location: LocationModel)
	{
		self.locationDescription.text = location.description;
		self.locationLocalTime.text = location.currentLocalTime!;
		
		setLocationDay(location.currentDay!);
	
	}
	
	func setLocationDay(_ info: DayModel)
	{
		self.morningControl.setHours(before: info.morningBlueHourModel!.formatted, sun: info.sunriseModel!.formatted, after: info.morningGoldenHourModel!.formatted);
		
		self.eveningControl.setHours(before: info.eveningGoldenHourModel!.formatted, sun: info.sunsetModel!.formatted, after: info.eveningBlueHourModel!.formatted);
		
		self.locationCurrentDayDate.text = info.dateFormatted;
	}
	

}

