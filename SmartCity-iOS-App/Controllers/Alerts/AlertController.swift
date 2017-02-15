//
//  AlertController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 5/18/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit
import UNAlertView

class AlertController: UITableViewController, FeedListener {

	@IBOutlet weak var hamburger: UIBarButtonItem!

	var feedItems: [FeedItem] = [FeedItem]()
    var linkController : AlertInformationController!

	override func viewDidLoad() {
		super.viewDidLoad()
		print("AlertController viewDidLoad")
		title = "City Alerts"
		tableView.delegate = self
		tableView.dataSource = self
        tableView.allowsSelection = true
//		let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
//		tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        tableView.rowHeight = 120
		RSSUtil.getAlertsFeed(self)

	}

    func popMessage(message: String, title: String, color: UIColor) {
		let pop = UNAlertView(title: title, message: message)
		pop.addButton("OK", backgroundColor: color) {
			pop.hidden = true
		}
		pop.show()
	}
	func onFeedReceived(items: [FeedItem]) {
		Util.logMessage("------------ items received \(items.count)")
		feedItems = items
		tableView.reloadData()
        if items.isEmpty {
            popMessage("There are no current alerts", title: "Alerts", color: UIColor.blueColor())
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
		return feedItems.count
	}

   
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! AlertFeedItemCell
				// Configure the cell...
		let a = feedItems[(indexPath as NSIndexPath).row]
		cell.setFeedItem(a)
		cell.contentView.setNeedsLayout()
		cell.contentView.layoutIfNeeded()
		cell.clipsToBounds = true
		return cell
	}
	//let SEGUE_link = "alertDetailSegue"
    let SEGUE_alertDetail = "AlertInforSegue"
	var currentIndex = 0;

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentIndex = (indexPath as NSIndexPath).row
        linkController.urlString = feedItems[currentIndex].description
        linkController.heading = feedItems[currentIndex].title
        linkController.iconImgUrl = feedItems[currentIndex].thumbnailUrl
        linkController.pubDate = feedItems[currentIndex].pubDate
        
    }
	

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue( segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == SEGUE_alertDetail {
			linkController = segue.destinationViewController as! AlertInformationController
		}
	}
}
