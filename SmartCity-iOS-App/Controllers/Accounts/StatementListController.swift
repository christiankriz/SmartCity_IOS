//
//  StatementListController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/13/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit

class StatementListController: UITableViewController, HeaderListener {

	var pdfUrls = [NSURL]()
	var pdfFileNames = [String]()
	var account: AccountDTO?
	let SEGUE_toPDFView = "toPDFViewerSegue"

	override func viewDidLoad() {
		super.viewDidLoad()

		title = account?.accountNumber
		tableView.delegate = self
		let nib = UINib(nibName: "StatementListHeader", bundle: nil)
		tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "StatementListHeader")
		tableView.dataSource = self
		self.tableView.sectionHeaderHeight = 380
		tableView.separatorColor = UIColor.whiteColor()

		// getLocalFiles()
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem()
	}

	@IBAction func doneClicked(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	var year: Int?
	var month: Int?

	func onDownloadRequested(accountNumber: String, year: Int, month: Int, count: Int) {
		Util.logMessage("accountNumber: \(accountNumber)")
		self.year = year
		self.month = month

		performSegueWithIdentifier(SEGUE_toPDFView, sender: self)

	}
	// MARK: - Navigation

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == SEGUE_toPDFView {
			let linkController = segue.destinationViewController as! StatementPDFViewerController
			linkController.account = account
			linkController.year = year
			linkController.month = month

		}
	}
	// MARK: - Table view data source

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return pdfUrls.count
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		url = pdfUrls[(indexPath as NSIndexPath).row]
		performSegueWithIdentifier(SEGUE_toPDFView, sender: self)
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		print("...... configuring cell \((indexPath as NSIndexPath).row)")
		let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! StatementCell

		cell.fileName.text = pdfFileNames[(indexPath as NSIndexPath).row]
		cell.contentView.setNeedsLayout()
		cell.contentView.layoutIfNeeded()
		cell.clipsToBounds = true

		return cell
	}
	var url: NSURL?

	override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		// Dequeue with the reuse identifier
		let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("StatementListHeader")
		as! StatementListHeader
		cell.account = account
		cell.listener = self

		return cell
	}

}
