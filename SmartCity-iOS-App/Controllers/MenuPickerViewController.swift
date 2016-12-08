//
//  MenuPickerViewController.swift
//  SmartCity-iOS-App
//
//  Created by Christian Nhlabano on 2016/12/06.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit

class MenuPickerViewController: UITableViewController {
    
    override func loadView() {
        //view = LMViewBuilder.viewWithName("ColorPickerView", owner: self, root: nil)
        // Use your cell's reuse identifier and cast the result
        // to your custom table cell class.
        //let article = tableView.dequeueReusableCellWithIdentifier("MyCustomCell", forIndexPath: 0) as! MyCustomTableViewCell
        
        // You should have access to your labels; assign the values.
        //article.categoryLabel?.text = "something"
        //article.dateLabel?.text = "something"
        //article.sourceLabel?.text = "something"
        //article.titleLabel?.text = "something"
        
        //return article
    }
    override func viewWillAppear(animated: Bool) {
        tableView.layoutIfNeeded()
        preferredContentSize = tableView.contentSize
    }
}
