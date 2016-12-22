//
//  NewsController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 8/30/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import Foundation
import UNAlertView

class NewsController: UITableViewController, FeedListener {

	@IBOutlet weak var hamburger: UIBarButtonItem!

	var feedItems: [FeedItem] = [FeedItem]()
    var linkController : FeedLinkController!
	override func viewDidLoad() {
		super.viewDidLoad()

		title = "City News"
		tableView.delegate = self
		// let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
		// tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
		tableView.dataSource = self
		RSSUtil.getNewsFeed(self)

	}
	override func viewDidAppear(animated: Bool) {

		tableView.reloadData()

	}

	func popMessage(message: String, title: String, color: UIColor) {
		let pop = UNAlertView(title: title, message: message)
		pop.addButton("OK", backgroundColor: color) {
			pop.hidden = true
		}
		pop.show()
	}
	func onFeedReceived(items: [FeedItem]) {

		feedItems = items
		tableView.reloadData()
        if items.isEmpty {
            popMessage("There are no current news articles", title: "News", color: UIColor.greenColor())
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
		let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! NewsFeedItemCell

		// Configure the cell...
		let a = feedItems[(indexPath as NSIndexPath).row]
		cell.setFeedItem(a)

		cell.contentView.setNeedsLayout()
		cell.contentView.layoutIfNeeded()
		cell.clipsToBounds = true
		return cell
	}

	// MARK: - Navigation

	let SEGUE_link = "newsDetailSegue"
	var currentIndex = 0;

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		currentIndex = (indexPath as NSIndexPath).row
		linkController.urlString = feedItems[currentIndex].link
	}

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == SEGUE_link {
			linkController = segue.destinationViewController as! FeedLinkController
		}
	}
	// override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
	// // Dequeue with the reuse identifier
	// let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableSectionHeader")
	// let header = cell as! TableSectionHeader
	// header.mTitle.text = "CITY NEWS"
	// header.mImage.image = RandomImage.getImage()
	//
	// return cell
	// }

}
