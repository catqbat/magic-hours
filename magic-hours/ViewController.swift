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
	
	var timeline:TimelineView? = nil;
		
	var ghIcon:UIImage? = nil;
	var bhIcon:UIImage? = nil;
	var sunriseIcon:UIImage? = nil;
	var sunsetIcon:UIImage? = nil;
	
	var polarDayIcon:UIImage? = nil;
	var polarNightIcon:UIImage? = nil;
	
	
	//MARK: Outlets
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var locationsList: UICollectionView!;
	@IBOutlet weak var menuButton: UIButton!
	@IBOutlet weak var polarDayNightLabel: UILabel!
	@IBOutlet weak var polarDayNightImage: UIImageView!
	@IBOutlet weak var polarDayNightStackView: UIStackView!

	@IBOutlet weak var currentDateControl: FormattedDateControl!
	@IBOutlet weak var locationDescription: UILabel!
	
	@IBOutlet weak var locationLocalTime: UILabel!
		
	@IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var timeLineScrollView: UIScrollView!
	@IBOutlet weak var weatherSummary: UILabel!
	
	@IBOutlet weak var busyIndicator: UIActivityIndicatorView!
	
	@IBOutlet weak var mainStack: UIStackView!
	
	@IBAction func showDateControl(_ sender: UITapGestureRecognizer)
	{
		datePicker.isHidden = false;
	}

	@IBAction func dateChanged(_ sender: UIDatePicker) {
	}
	@IBAction func showSettingsSidebar(_ sender: UIButton)
	{
		self.revealViewController().revealToggle(menuButton);
	}
	
	@IBAction func showPrevDay(_ sender: UISwipeGestureRecognizer)
	{
		global.mainModel.currentLocation?.prevDay();
		setLocationDay(global.mainModel.currentLocation!.currentDay!);
	}
	
	@IBAction func showNextDay(_ sender: UISwipeGestureRecognizer)
	{
		global.mainModel.currentLocation?.nextDay();
		setLocationDay(global.mainModel.currentLocation!.currentDay!);
	}
	
	
	override func viewDidLoad()
	{
		super.viewDidLoad();
		
		if self.revealViewController() != nil
		{
			self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
		}
		
		datePicker.isHidden = true;
		global.mainModel.navigateToFindLocationDelegate = self.navigateToFindLocation;
		global.mainModel.updateViewForLocationDelegate = self.updateViewForLocation;
		
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

		global.mainModel.getLocations(delegate: setLocation);
	
		locationsList.allowsSelection = true;
		locationsList.dataSource = global.mainModel.dataSource!;
		locationsList.delegate = global.mainModel.dataSource!;
		locationsList.reloadData();
		
		setupTimelineControl();
		getCurrentLocation();
	}
	
	func navigateToFindLocation()
	{
		performSegue(withIdentifier: "showMapSegue", sender: nil);
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		
		if segue.identifier == "showMapSegue"
		{
			
			if let mapViewController = segue.destination as? MapViewController
			{
				if (global.mainModel.currentLocation != nil)
				{
					mapViewController.ininitalLocation = global.mainModel.currentLocation!;
				}
			}
		}
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
	
	func updateViewForLocation(index: Int?)
	{
		DispatchQueue.main.async(execute:
		{
			self.setLocationView();
			
			if (global.mainModel.currentLocation != nil)
			{
				self.setLocation(global.mainModel.currentLocation!);
			}
			
			if (index != nil)
			{

			
				self.locationsList.reloadData();
				self.locationsList.selectItem(at: IndexPath(row: index!, section: 0), animated: true, scrollPosition: .left);
			}
			
		});
		

	}
	
	func getCurrentLocation()
	{
		setBusyView();
		
		global.mainModel.getLocation
		{	result in
			
				if (result == true)
				{
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
		global.mainModel.currentLocation = location;
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
		let location = global.mainModel.currentLocation;
		
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

