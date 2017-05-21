//
//  LocationViewController.swift
//  magic-hours
//
//  Created by Agata on 28/04/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation;
import UIKit;
import MapKit;

class MapViewController: UIViewController, MKMapViewDelegate
	
{
	//MARK: outlets
	@IBOutlet weak var mapView: MKMapView!
	
	
	//MARK: properties
	var ininitalLocation: LocationModel? = nil;
	
	var resultSearchController: UISearchController? = nil;
	var selectedPin: MKPlacemark? = nil;
	
	var searchBar:UISearchBar? = nil;
	
	var saveLocationButtonItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(menuButtonTapped(_:)));
	
	func menuButtonTapped(_ button:UIBarButtonItem)
	{
		if (selectedPin == nil)
		{
			return;
		}
		
		let toAdd = LocationModel(latitude: selectedPin!.coordinate.latitude, longitude: selectedPin!.coordinate.longitude, description: selectedPin!.name, zip: selectedPin!.postalCode);
		
		global.mainModel.addLocation(toAdd, save: true);
		navigationController?.popViewController(animated: true);
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad();
		
		 saveLocationButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(menuButtonTapped(_:)));
		
		let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
		
		resultSearchController = UISearchController(searchResultsController: locationSearchTable);
		resultSearchController?.searchResultsUpdater = locationSearchTable;
		
		searchBar = resultSearchController!.searchBar;
		searchBar!.sizeToFit();
		searchBar!.placeholder = L10n.search;
		navigationItem.titleView = resultSearchController?.searchBar;
		
		self.navigationItem.rightBarButtonItem = saveLocationButtonItem;

		resultSearchController?.hidesNavigationBarDuringPresentation = false;
		resultSearchController?.dimsBackgroundDuringPresentation = true;
		definesPresentationContext = true;
		
		locationSearchTable.mapView = mapView;
		locationSearchTable.handleMapSearchDelegate = self;
	}
	
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated);
		
		saveLocationButtonItem.isEnabled = false;
		
		if (ininitalLocation != nil)
		{
			let coordinate = CLLocationCoordinate2D(latitude: ininitalLocation!.latitude, longitude: ininitalLocation!.longitude);
			
			let span = MKCoordinateSpanMake(1, 1);
			let region = MKCoordinateRegion(center: coordinate, span: span);
			
			let annotation = MKPointAnnotation();
			annotation.coordinate = coordinate;
			annotation.title = ininitalLocation?.name;
			mapView.addAnnotation(annotation);
			
			mapView.setRegion(region, animated: true);
			
		}
	}
//	
//	func addRadiusCircle(center: CLLocationCoordinate2D)
//	{
//		self.mapView.delegate = self
//		let circle = MKCircle(center: center, radius: 5000 as CLLocationDistance)
//		self.mapView.add(circle);
//	}
//	
//	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
//	{
//		if overlay is MKCircle
//		{
//			let circle = MKCircleRenderer(overlay: overlay);
//			circle.strokeColor = UIColor.red;
//			circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1);
//			circle.lineWidth = 1;
//			return circle;
//		}
//		else
//		{
//			return MKPolylineRenderer();
//		}
//	}
	
	
}

extension MapViewController: HandleMapSearch
{
	func dropPinZoomIn(placemark:MKPlacemark)
	{
		searchBar?.text = placemark.name;
		
		// cache the pin
		selectedPin = placemark;
		// clear existing pins
		mapView.removeAnnotations(mapView.annotations);
		
		let annotation = MKPointAnnotation();
		
		annotation.coordinate = placemark.coordinate;
		annotation.title = placemark.name;
		
		if let city = placemark.locality,
			let state = placemark.administrativeArea
		{
			annotation.subtitle = "\(city) \(state)";
		}
		
		mapView.addAnnotation(annotation);
		let span = MKCoordinateSpanMake(0.05, 0.05);
		let region = MKCoordinateRegionMake(placemark.coordinate, span);
		mapView.setRegion(region, animated: true);
		
		saveLocationButtonItem.isEnabled = !global.mainModel.containsLocation(placeMark: placemark);
	}
}

protocol HandleMapSearch
{
	func dropPinZoomIn(placemark: MKPlacemark);
}
