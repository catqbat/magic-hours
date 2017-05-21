//
//  LocationSearchTable.swift
//  magic-hours
//
//  Created by Agata on 09/05/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation
import MapKit;

class LocationSearchTable : UITableViewController
{
	var matchingItems:[MKMapItem] = [];
	var mapView: MKMapView? = nil;
	var handleMapSearchDelegate:HandleMapSearch? = nil;
}

extension LocationSearchTable : UISearchResultsUpdating
{
	
	func updateSearchResults(for searchController: UISearchController)
	{
		guard let mapView = mapView,
			let searchBarText = searchController.searchBar.text
			else
			{
				return;
		}
		
		let request = MKLocalSearchRequest();
		
		request.naturalLanguageQuery = searchBarText;
		request.region = mapView.region;
		//request.po
		
		let search = MKLocalSearch(request: request);
		
		search.start
		{	response, _ in
			
			guard let response = response
			else
			{
				return;
			}
			
			self.matchingItems = response.mapItems;
			self.tableView.reloadData();
		}
		
	}

}

extension LocationSearchTable {
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return matchingItems.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
		let selectedItem = matchingItems[indexPath.row].placemark
		cell.textLabel?.text = selectedItem.name
		cell.detailTextLabel?.text = ""
		return cell
	}
	
}

extension LocationSearchTable {
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedItem = matchingItems[indexPath.row].placemark
		handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
		dismiss(animated: true, completion: nil)
	}
	
}
