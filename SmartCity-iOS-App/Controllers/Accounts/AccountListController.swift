//
//  AccountListController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/2/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import Foundation
import UIKit

class AccountListController: UITableViewController {

	var list: [AccountDTO] = [AccountDTO]()
	let SEGUE_detail = "accountDetailSegue"
    var nav : AccountController!

	var currentIndex = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		Util.logMessage("AccountListController......are we there yet?")
		title = "Account Details"
		tableView.delegate = self
		do {
			list = try Util.getProfile().accountList!
			Util.logMessage("----------------> down yet? acct list: \(list.count)")
			// if list.count == 1 {
			// performSegueWithIdentifier(SEGUE_detail, sender: self)
			// return
			// }
			tableView.dataSource = self
			tableView.reloadData()

		} catch { }
		// let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
		// tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")

	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! AccountCell

		let a = list[(indexPath as NSIndexPath).row]
		cell.accountName?.text = a.customerAccountName
		// cell.icon?.image = UIImage(named: "account")
		cell.number.text = "\((indexPath as NSIndexPath).row + 1)"
		cell.accountNumber?.text = a.accountNumber

		cell.contentView.setNeedsLayout()
		cell.contentView.layoutIfNeeded()
		cell.clipsToBounds = true

		return cell
	}
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		currentIndex = (indexPath as NSIndexPath).row
        nav.account = list[currentIndex]
		//performSegueWithIdentifier(SEGUE_detail, sender: self)
	}
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == SEGUE_detail {
			nav = segue.destinationViewController as! AccountController
		}
	}
	// override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
	// // Dequeue with the reuse identifier
	// let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableSectionHeader")
	// let header = cell as! TableSectionHeader
	// header.mTitle.text = "ACCOUNTS"
	// header.mImage.image = RandomImage.getImage()
	//
	// return cell
	// }

}
