//
//  FAQController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/3/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import Foundation
import UNAlertView

class FAQIndependentController: UITableViewController {

	let faqList: [String] = ["Account Payments", "Water Sanitation", "Cleaning & Solid Waste",
		"Rates & Taxes", "Building Plans", "Electricity", "Social Services",
		"Health", "Metro Police"]

	var index = 0

	override func viewDidLoad() {
		super.viewDidLoad()
		Util.logMessage(".......... starting faq")
        title = "Frequently Asked"
		tableView.delegate = self
		tableView.dataSource = self
		// let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
		// tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
		//
		tableView.reloadData()

	}
	override func viewDidAppear(animated: Bool) {

		// tableView.reloadData()

	}

	func popMessage(message: String, title: String) {
		let pop = UNAlertView(title: title, message: message)
		pop.addButton("OK", backgroundColor: UIColor.redColor()) {
			pop.hidden = true
		}
		pop.show()
	}

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return faqList.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		Util.logMessage("starting cellForRowAtIndexPath \((indexPath as NSIndexPath).row)")
		let cell1 = tableView.dequeueReusableCellWithIdentifier("cellFAQ2") as! FAQTableViewCell2

		let mTitle = faqList[(indexPath as NSIndexPath).row]
		cell1.faqTitle.text = mTitle
		cell1.number.text = "\((indexPath as NSIndexPath).row + 1)"

		cell1.contentView.setNeedsLayout()
		cell1.contentView.layoutIfNeeded()
		cell1.clipsToBounds = true
		Util.logMessage("ending cellForRowAtIndexPath \((indexPath as NSIndexPath).row)")
		return cell1
	}

	// MARK: - Navigation

	let SEGUE_link = "mShowWebSegue"
	var currentIndex = 0;

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		currentIndex = (indexPath as NSIndexPath).row
		performSegueWithIdentifier(SEGUE_link, sender: self)
	}

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		Util.logMessage("starting prepareForSegue \(segue.identifier)")
		let linkController = segue.destinationViewController as! FAQWebViewController
		linkController.index = currentIndex
	}
	// override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
	// // Dequeue with the reuse identifier
	// Util.logMessage("starting viewForHeaderInSection")
	// let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableSectionHeader")
	// let header = cell as! TableSectionHeader
	// header.mTitle.text = "Frequently Asked Questions"
	// header.mImage.image = RandomImage.getImage()
	//
	// Util.logMessage("ending viewForHeaderInSection")
	//
	// return cell
	// }

}

