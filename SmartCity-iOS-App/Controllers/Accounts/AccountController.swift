//
//  AccountController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 5/18/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit
import Toast_Swift
import UNAlertView

class AccountController: UITableViewController, DataProtocol {

	@IBOutlet weak var cashAfterAccount: UILabel!
	@IBOutlet weak var acctNumber: UILabel!

	@IBOutlet weak var accountName: UILabel!

	@IBOutlet weak var address: UILabel!

	@IBOutlet weak var currentBalance: UILabel!

	@IBOutlet weak var billDay: UILabel!
	@IBOutlet weak var nextBillDate: UILabel!

	@IBOutlet weak var prevBillDate: UILabel!
	@IBOutlet weak var currentArrears: UILabel!

	@IBOutlet weak var lastBillAmount: UILabel!

	var account: AccountDTO?
	var profile: ProfileInfoDTO?
	var muni: MunicipalityDTO?
    let SEGUE_toStatementListSegue = "toStatementListSegue"

	override func viewDidLoad() {
		super.viewDidLoad()

		Util.logMessage("AccountController: are we there yet?")
		title = "Account Details"
		do {
			profile = try Util.getProfile()
			muni = try Util.getMunicipality()
		} catch {

		}

		setFields()

	}

	func setFields() {

		let formatter = NSNumberFormatter()
		formatter.numberStyle = .CurrencyStyle
		// formatter.locale = NSLocale.currentLocale() // This is the default

		accountName.text = account!.customerAccountName!
		acctNumber.text = account!.accountNumber!
		billDay.text = "\(account!.billDay!)"
		currentArrears.text = formatter.stringFromNumber( NSNumber(double: account!.currentArrears!))
		currentBalance.text = formatter.stringFromNumber(NSNumber(double: account!.currentBalance!))
		lastBillAmount.text = formatter.stringFromNumber( NSNumber(double: account!.lastBillAmount!))
		cashAfterAccount.text = formatter.stringFromNumber(NSNumber(double: account!.cashAfterAccount!))

		address.text = account!.propertyAddress!
		if account?.nextBillDate == nil {
			nextBillDate.text = "Not Available"
		} else {

		}

		if account?.previousBillDate == nil {
			prevBillDate.text = "Not Available"
		} else {

		}

	}

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_toStatementListSegue {
            let linkController = segue.destinationViewController as! StatementListController
            linkController.account = account
        }
    }
	var isStatement: Bool = false
	@IBAction func downloadStatement(sender: AnyObject) {

//		performSegueWithIdentifier(SEGUE_toStatementListSegue, sender: self)
        let storyboard = UIStoryboard(name: "LandingStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("StatementListNavigationController") as! StatementListNavigationController
        vc.account = account
        self.presentViewController(vc, animated: true, completion: nil)
	}
	@IBAction func payBill(sender: AnyObject) {
		Util.logMessage("paybill pressed - show message")
		doToast("Payment via Mobile will be available soon")

	}
	func doToast(message: String) {
		// create a new style
		var style = ToastStyle()

		// this is just one of many style options
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
	@IBAction func complaintAboutBill(sender: AnyObject) {
		Util.logMessage("high bill complaint")
		let dialog = UNAlertView(title: "High Bill Complaint", message: "Do you want to lodge a complaint about your bill?");
		dialog.addButton("No", action: {
			dialog.hidden = true
		})
		dialog.addButton("Yes", action: {
			// self.sendComplaint()
			self.doToast("High Bill complaint will be available soon")
		})
		dialog.show()
	}
	func sendComplaint() {
		Util.logMessage("sending high bill complaint")
		let c = ComplaintDTO()
		let p = ProfileInfoDTO()
		p.email = profile?.email
		p.password = profile?.password
		p.CustomerID = profile?.CustomerID
		c.profileInfo = p

		c.category = "High Bill"
		c.subCategory = "High Bill"

		let req = RequestDTO(requestType: RequestDTO.ADD_COMPLAINT)
		req.complaint = c
		req.municipalityID = muni?.municipalityID

		DataUtil.sendRequest(req, listener: self)

	}
	func onResponseDataReceived(response: ResponseDTO) {

		if isStatement {
			let dict = response.pdfHashMap
			for (key, _) in dict! {
				print(key)
				//Util.writeStatementToFile("\(key as! String).pdf", data: value as! NSArray)
			}
		}

		self.navigationController?.view.makeToast("Complaint has been sent. Thanks!")
	}
	func onError(message: String) {
		Util.logMessage(message)
		let d = UNAlertView(title: "Services Message",
			message: message)
		d.addButton("OK", action: {
			d.hidden = true
		})
		d.show()
	}

}
