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
	let mainModel:MainModel = MainModel();
	
	var timeline:TimelineView? = nil;
		
	var ghIcon:UIImage? = nil;
	var bhIcon:UIImage? = nil;
	var sunriseIcon:UIImage? = nil;
	var sunsetIcon:UIImage? = nil;
	
	var polarDayIcon:UIImage? = nil;
	var polarNightIcon:UIImage? = nil;
	
	
	//MARK: Outlets
	@IBOutlet weak var locationsList: UICollectionView!;
	@IBOutlet weak var polarDayNightLabel: UILabel!
	@IBOutlet weak var polarDayNightImage: UIImageView!
	@IBOutlet weak var polarDayNightStackView: UIStackView!

	@IBOutlet weak var morningControl: GoldenHoursControl!
	
	@IBOutlet weak var eveningControl: GoldenHoursControl!
	@IBOutlet weak var currentDateControl: FormattedDateControl!
	@IBOutlet weak var locationDescription: UILabel!
	
	@IBOutlet weak var locationLocalTime: UILabel!
		
	@IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var timeLineScrollView: UIScrollView!
	@IBOutlet weak var weatherSummary: UILabel!
	
	@IBOutlet weak var busyIndicator: UIActivityIndicatorView!
	
	@IBOutlet weak var mainStack: UIStackView!
	
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
		
		polarDayNightStackView.isHidden = true;
		
		weatherSummary.numberOfLines = 0;
		weatherSummary.lineBreakMode = NSLineBreakMode.byWordWrapping;
		
		let bundle = Bundle(for: type(of: self));
		
		ghIcon = UIImage(named: "golden_hour", in: bundle, compatibleWith: self.traitCollection);
		bhIcon = UIImage(named: "blue_hour", in: bundle, compatibleWith: self.traitCollection);
		sunriseIcon = UIImage(named: "sunrise", in: bundle, compatibleWith: self.traitCollection);
		sunsetIcon = UIImage(named: "sunset", in: bundle, compatibleWith: self.traitCollection);
		
		polarDayIcon = UIImage(named: "polar_day", in: bundle, compatibleWith: self.traitCollection)!;
		polarNightIcon = UIImage(named: "polar_night", in: bundle, compatibleWith: self.traitCollection);

		mainModel.getLocations(delegate: setLocation);
	
		locationsList.allowsSelection = true;
		locationsList.dataSource = mainModel.dataSource!;
		locationsList.delegate = mainModel.dataSource!;
		locationsList.reloadData();
		
		setupTimelineControl();
		getCurrentLocation();
	}
	
	func setupTimelineControl()
	{
		timeline = TimelineView(bulletType: .circle, timeFrames: [])
		
		timeline!.lineColor = UIColor.white;
		timeline!.titleLabelColor = UIColor.white;
		timeline!.detailLabelColor = UIColor.black;
		
		timeLineScrollView.addSubview(timeline!);
		
		timeLineScrollView.addConstraints([
			NSLayoutConstraint(item: timeline!, attribute: .left, relatedBy: .equal, toItem: timeLineScrollView, attribute: .left, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: timeline!, attribute: .top, relatedBy: .equal, toItem: timeLineScrollView, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: timeline!, attribute: .width, relatedBy: .equal, toItem: timeLineScrollView, attribute: .width, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: timeline!, attribute: .centerX, relatedBy: .equal, toItem: timeLineScrollView, attribute: .centerX, multiplier: 1.0, constant: 0)
			]);
		
	
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated);
		// Hide the navigation bar for current view controller
		self.navigationController?.isNavigationBarHidden = true;
	}
	
	override func viewWillDisappear(_ animated: Bool)
	{
		super.viewWillDisappear(animated);
		// Show the navigation bar on other view controllers
		self.navigationController?.isNavigationBarHidden = false;
	}
	
	func getCurrentLocation()
	{
		setBusyView();
		
		mainModel.getLocation
			{
				result in
				
				if (result == true)
				{
					self.setLocationView();
					self.setLocation(self.mainModel.currentLocation!);
				}
				else
				{
					// there was an error that should be handled
				}
		}

	}
	
	func setLocationView()
	{
		mainStack.isHidden = false;
		busyIndicator.stopAnimating();
	}
	
	func setBusyView()
	{
		mainStack.isHidden = true;
		busyIndicator.startAnimating();
	}
	

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	func setLocation(_ location: LocationModel)
	{
		self.mainModel.currentLocation = location;
		self.locationDescription.text = location.name;
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
		
		self.currentDateControl.date = info.date;
		
		if (info.type == .regular)
		{
			polarDayNightStackView.isHidden = true;
			timeline!.isHidden = false;
			
			timeline!.timeFrames = [
				//TimeFrame(text: " ", date: "", image: startIcon),
				TimeFrame(text: L10n.blueHour + "\n", date: info.morningBlueHourModel!.formatted, image: bhIcon),
				TimeFrame(text: L10n.sunrise + "\n", date: info.sunriseModel!.formatted, image: sunriseIcon),
				TimeFrame(text: L10n.goldenHour + "\n\n\n", date: info.morningGoldenHourModel!.formatted,  image: ghIcon),
				
				TimeFrame(text: L10n.goldenHour + "\n", date: info.eveningGoldenHourModel!.formatted, image: ghIcon),
				TimeFrame(text: L10n.sunset + "\n", date: info.sunsetModel!.formatted, image: sunsetIcon),
				TimeFrame(text: L10n.blueHour + "\n", date: info.eveningBlueHourModel!.formatted, image: bhIcon),
				//TimeFrame(text: "", date: "", image: endIcon),
			];
		}
		else
		{
			polarDayNightStackView.isHidden = false;
			timeline!.isHidden = true;
			
			if (info.type == .polarDay)
			{
				polarDayNightImage.image = polarDayIcon;
				polarDayNightLabel.text = L10n.polarDay;
			}
			else
			{
				polarDayNightImage.image = polarNightIcon;
				polarDayNightLabel.text = L10n.polarNight;
			}
		}
		
		setWeather();
	}
	

}

