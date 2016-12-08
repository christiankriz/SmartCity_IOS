//
//  CitizenTabController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 8/29/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit

class CitizenTabController: UITabBarController {

	var page: Int = 0
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tabBarController?.selectedIndex = page
		Util.logMessage("tabBarController?.selectedIndex \(page)")
		title = "eThekwini Services"
	}

	func setPageToStart(page: Int) {
		self.page = page

	}
	override func viewWillAppear(animated: Bool) {
		self.selectedViewController = self.viewControllers![page]
	}
    
}
