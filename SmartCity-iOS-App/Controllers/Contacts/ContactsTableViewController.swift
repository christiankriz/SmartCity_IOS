//
//  ContactsTableViewController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/3/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit
import Toast_Swift

class ContactsTableViewController: UITableViewController {

	var contacts = [EmergencyContact]()
	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Emergency Contacts"
		contacts = EmergencyContact.createList()
		tableView.delegate = self
		tableView.dataSource = self
	}

	// MARK: - Table view data source

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contacts.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ContactsTableViewCell

		let ec = contacts[(indexPath as NSIndexPath).row]
		cell.department.text = ec.department
		cell.name.text = ec.name
		cell.number.text = ec.number

		return cell
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let ec = contacts[(indexPath as NSIndexPath).row]
		// start call
		let newString = ec.number!.stringByReplacingOccurrencesOfString(" ", withString: "")
		let url = NSURL(string: "tel://\(newString)")
		UIApplication.sharedApplication().openURL(url!)

		let msg = ".... will be calling \(newString): at \(ec.name!) - from \(ec.department!) ... soon, very soon :)"
		// doToast(msg)
		Util.logMessage(msg)
	}

	func doToast(message: String) {
		// create a new style
		var style = ToastStyle()

		style.messageColor = UIColor.yellowColor()

		// or perhaps you want to use this style for all toasts going forward?
		// just set the shared style and there's no need to provide the style again
		ToastManager.shared.style = style

		// toggle "tap to dismiss" functionality
		ToastManager.shared.tapToDismissEnabled = true

		// toggle queueing behavior
		ToastManager.shared.queueEnabled = true
		// display toast with an activity spinner
		// self.view.makeToastActivity(.Center)

		// present the toast with the new style
		self.navigationController?.view.makeToast(message)
	}
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
	}

}
