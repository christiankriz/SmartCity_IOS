//
//  MenuController.swift
//  SmartCity-iOS-App
//
//  Created by Christian Nhlabano on 2016/12/06.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit

public class MenuController: UIViewController {
    
    func menuButtonPressed(sender: UIBarButtonItem) {
        
        let smartMenuController = UIAlertController(title: "Smart City Menu", message: "Select Option", preferredStyle: .Alert)
        let smartCityGuideButton = UIAlertAction(title: "Smartcity Guide", style: .Default, handler: { (action) -> Void in
            //println("Button One Pressed")
        })
        let generalInforButton = UIAlertAction(title: "General Infor", style: .Default, handler: { (action) -> Void in
            self.presentViewController(GeneralInforConroller(), animated: true, completion: nil)
            //self.navigationController?.pushViewController(GeneralInforConroller(), animated: true)
        })
        let logOff = UIAlertAction(title: "Log Off", style: .Default, handler: { (action) -> Void in
            //println("Button Four Pressed")
        })
        let buttonCancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            //println("Cancel Button Pressed")
        }
        smartMenuController.addAction(smartCityGuideButton)
        //smartMenuController.addAction(emergencyContactButton)
        smartMenuController.addAction(generalInforButton)
        smartMenuController.addAction(logOff)
        smartMenuController.addAction(buttonCancel)
        
        presentViewController(smartMenuController, animated: true, completion: nil)
        
    }

      
}