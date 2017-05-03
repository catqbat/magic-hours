//
//  LocationDataSource.swift
//  magic-hours
//
//  Created by Agata on 02/05/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation;
import UIKit;

typealias SetLocationDelegate = (_ location : LocationModel)  -> Void

class LocationDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
	let locations: [LocationModel];
	let setSelectedLocation: SetLocationDelegate;
	
	init(locations: [LocationModel], delegate: @escaping SetLocationDelegate)
	{
		self.locations = locations;
		self.setSelectedLocation = delegate;
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return locations.count;
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCell", for: indexPath) as! LocationCell;
		
		let location = locations[indexPath.row];
		cell.locationName = location.name;
		
		return cell;
	}
	
	func collectionView(_ collectionView: UICollectionView,
	                             layout collectionViewLayout: UICollectionViewLayout,
	                             sizeForItemAt indexPath: IndexPath) -> CGSize
	{
		let width = locations[indexPath.row].name.width(withConstrainedHeight: 50, font: LocationCell.locationNameFont);
		
		return CGSize(width: width + 10, height: 50);
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		let location = locations[indexPath.row];
		setSelectedLocation(location);
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
	{
		
	}
	
}
