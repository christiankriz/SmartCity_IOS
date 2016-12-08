//
//  TouristViewController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 8/29/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit

class TouristBarController: UITabBarController {

    var page = 0
	override func viewDidLoad() {
		super.viewDidLoad()
        title = "eThekwini Services"
        tabBarController?.selectedIndex = page
        Util.logMessage("tabBarController?.selectedIndex \(page)")
	}

    func setPageToStart(page: Int) {
        self.page = page
        
    }
    override func viewWillAppear(animated: Bool) {
        self.selectedViewController = self.viewControllers![page]
    }


}
