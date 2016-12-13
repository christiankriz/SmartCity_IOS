//
//  CitizenTabController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 8/29/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit
import UNAlertView

class CitizenTabController: UITabBarController {

	var page: Int = 0
    var landingPage : LandingPageController?
    
    let SEGUE_login = "loginSegue"
    
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tabBarController?.selectedIndex = page
		Util.logMessage("tabBarController?.selectedIndex \(page)")
		title = "eThekwini Services"
        Util.logMessage("tabBarController?.selectedIndex \(page)")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action: "menuButtonPressed:")
	}

	func setPageToStart(page: Int) {
		self.page = page

	}
	override func viewWillAppear(animated: Bool) {
		self.selectedViewController = self.viewControllers![page]
	}
    
    func menuButtonPressed(sender: UIBarButtonItem) {
        
        let smartMenuController = UIAlertController(title: "Smart City Menu", message: "Select Option", preferredStyle: .Alert)
        let smartCityGuideButton = UIAlertAction(title: "Smartcity Guide", style: .Default, handler: { (action) -> Void in
            let url : NSURL = NSURL(string: "http://www.etmobileguide.oneconnectgroup.com/")!
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            }
            
        })
        let generalInforButton = UIAlertAction(title: "General Infor", style: .Default, handler: { (action) -> Void in
            //self.navigationController?.pushViewController(GeneralInforConroller(), animated: true)
            self.performSegueWithIdentifier("toGeneralInforFromCityzenTab", sender: self)
        })
        //let logOff = UIAlertAction(title: "Log Off", style: .Default, handler: { (action) -> Void in
            //self.logout(sender)
        //    Util.removeProfile()
        //    LandingPageController().startSegue()
        //})
        let buttonCancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            //println("Cancel Button Pressed")
        }
        smartMenuController.addAction(smartCityGuideButton)
        //smartMenuController.addAction(emergencyContactButton)
        smartMenuController.addAction(generalInforButton)
        //smartMenuController.addAction(logOff)
        smartMenuController.addAction(buttonCancel)
        
        presentViewController(smartMenuController, animated: true, completion: nil)
        
    }
    
    func logout(sender: UIBarButtonItem) {
        Util.logMessage("...........logging out")
        
        let d = UNAlertView(title: "Services LogOut", message: "Do you want to log out?");
        d.addButton("Yes", action: {
            Util.removeProfile()
            self.performSegueWithIdentifier(self.SEGUE_login, sender: self)
            
        })
        d.addButton("No", action: {
            d.hidden = true
        })
        d.show()
    }

    
}
