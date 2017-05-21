//
//  SidebarMenuViewController.swift
//  magic-hours
//
//  Created by Agata on 06/05/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation;
import UIKit;
class SidebarMenuController: UIViewController
{
	override func viewDidLoad()
	{
		
		
		super.viewDidLoad();
		
		
	}
	
	@IBAction func findLocation(_ sender: UITapGestureRecognizer)
	{
		self.revealViewController().revealToggle(self);
		global.mainModel.NavigateToFindLocation();
	}
}
