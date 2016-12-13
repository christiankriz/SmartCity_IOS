//
//  GeneralInfor.swift
//  SmartCity-iOS-App
//
//  Created by Christian Nhlabano on 2016/12/13.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit

class GeneralInforConroller: UIViewController {
    @IBOutlet weak var inforLabel: UILabel!
    
       override func viewDidLoad() {
          super.viewDidLoad()
          inforLabel.layer.borderWidth = 2.0
          inforLabel.layer.borderColor = UIColor.grayColor().CGColor
       }
    

}
