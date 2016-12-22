//
//  GeneralInfor.swift
//  SmartCity-iOS-App
//
//  Created by Christian Nhlabano on 2016/12/13.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit

class GeneralInforConroller: UIViewController {
    @IBOutlet weak var inforView: UITextView!
        
       override func viewDidLoad() {
          super.viewDidLoad()
          inforView.layer.borderWidth = 2.0
          inforView.layer.borderColor = UIColor.grayColor().CGColor
          inforView.editable = false
       }
    

}
