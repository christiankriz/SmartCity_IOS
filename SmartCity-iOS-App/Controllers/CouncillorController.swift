//
//  CouncillorController.swift
//  SmartCity-iOS-App
//
//  Created by Christian Nhlabano on 2017/02/17.
//  Copyright © 2017 Aubrey Malabie. All rights reserved.
//

import UIKit
import UNAlertView

class CouncillorController: UITableViewController, CouncillorListener {
    
    @IBOutlet weak var hamburger: UIBarButtonItem!
    
    var councillorItems: [CouncillorsItem] = [CouncillorsItem]()
    var linkController : CouncillorController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CouncillorController viewDidLoad")
        //title = "Councillor List"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.rowHeight = 120
        tableView.tableFooterView = nil
        RSSUtil.getCouncillors(self)
        
    }
    
    func popMessage(message: String, title: String, color: UIColor) {
        let pop = UNAlertView(title: title, message: message)
        pop.addButton("OK", backgroundColor: color) {
            pop.hidden = true
        }
        pop.show()
    }
    func onCouncillorReceived(items: [CouncillorsItem]) {
        Util.logMessage("------------ items received \(items.count)")
        councillorItems = items
        tableView.reloadData()
        if items.isEmpty {
            popMessage("There are no current councillors", title: "Councillors", color: UIColor.blueColor())
        }
    }
    
    func onError(message: String) {
        popMessage(message, title: "Server Message", color: UIColor.redColor())
    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = councillorItems.count
        return count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! CouncillorCell
        // Configure the cell...
        let c = councillorItems[(indexPath as NSIndexPath).row]
        cell.setCouncillorItem(c)
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        cell.clipsToBounds = true
        return cell
    }
    
    let SEGUE_councillorDetail = "councillorSEGUE"
    var currentIndex = 0;
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentIndex = (indexPath as NSIndexPath).row
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue( segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
