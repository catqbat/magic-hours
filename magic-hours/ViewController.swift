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
	
	@IBOutlet weak var weatherIcon: UIImageView!
	@IBOutlet weak var weatherSummary: UILabel!
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
	
		weatherSummary.numberOfLines = 3;
		weatherSummary.lineBreakMode = NSLineBreakMode.byWordWrapping;
		
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
	
	func setFetchingWeather()
	{
		weatherSummary.text = L10n.checkingForecast;
		weatherIcon.image = getWeatherIcon("na");
	}
	
	func setWeatherUnavailable()
	{
		weatherSummary.text = L10n.forecastUnavailable;
		weatherIcon.image = getWeatherIcon("na");
	}
	
	func getWeatherIcon(_ icon: String) -> UIImage?
	{
		let bundle = Bundle(for: type(of: self));
		var weatherIcon = UIImage(named: icon, in: bundle, compatibleWith: self.traitCollection);
		
		if (weatherIcon == nil)
		{
			weatherIcon = UIImage(named: "default", in: bundle, compatibleWith: self.traitCollection);
		}
		
		return weatherIcon;
	}
	
	func setWeather(_ weather: WeatherModel)
	{
		weatherSummary.text = weather.temperatureInfo + "\n" + weather.summary;
		weatherIcon.image = getWeatherIcon(weather.icon);
	}
	
	func setWeather()
	{
		let location = mainModel.currentLocation;
		
		if (location == nil)
		{
			return;
		}
		
		if (!location!.weatherForeCastIsKnown)
		{
			//fetch weather
			setFetchingWeather();
			location!.fetchWeatherForecast
			{
				DispatchQueue.main.async(execute: 
				{
						self.setWeather();
				});
			}
		}
		else if (location!.containsWeather(for: location!.currentDay!.date))
		{
			setWeather(location!.getWeather(for: location!.currentDay!.date)!);
		}
		else
		{
			setWeatherUnavailable();
		}

	}
	
	func setLocationDay(_ info: DayModel)
	{
		self.morningControl.setHours(before: info.morningBlueHourModel!.formatted, sun: info.sunriseModel!.formatted, after: info.morningGoldenHourModel!.formatted);
		
		self.eveningControl.setHours(before: info.eveningGoldenHourModel!.formatted, sun: info.sunsetModel!.formatted, after: info.eveningBlueHourModel!.formatted);
		
		self.locationCurrentDayDate.text = info.dateFormatted;
		
		//setting weather info
		setWeather();
	}
	

}

