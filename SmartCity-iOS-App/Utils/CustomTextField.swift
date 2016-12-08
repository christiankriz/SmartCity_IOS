//
//  File.swift
//  SmartCity003a
//
//  Created by Aubrey Malabie on 5/2/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import Foundation

import UIKit

class CustomTextField: UITextField {
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 5.0;
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.borderWidth = 1.5
        self.backgroundColor = UIColor.blueColor()
        self.textColor = UIColor.whiteColor()
        self.tintColor = UIColor.purpleColor()
        
    }
}
