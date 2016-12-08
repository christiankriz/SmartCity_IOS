//
//  LoginCitizenController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 5/17/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit
import UNAlertView

class LoginCitizenController: UIViewController, DataProtocol, UITextFieldDelegate {

	@IBOutlet weak var btnSignIn: UIButton!

	@IBOutlet weak var emailAddress: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var muniName: UILabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!

	var muni: MunicipalityDTO?

	let SEGUE_citizenTabs = "startCitizenTabsFromSignIn"

	override func viewDidLoad() {
		super.viewDidLoad()
        
        btnSignIn.layer.cornerRadius = 5
        btnSignIn.layer.borderWidth = 1
        btnSignIn.layer.borderColor = UIColor.blackColor().CGColor
        btnSignIn.frame = CGRectMake(200, 200, 100, 100)

		activityIndicator.hidden = true
		emailAddress.text = "grosvenor@iafrica.com"
		password.text = "gift123"

		// check muni exists in cache
		do {
			muni = try Util.getMunicipality()
		} catch {
			let d = UNAlertView(title: "App Error", message: "Municipality services not available. Please try later")
			d.addButton("OK", action: {
				exit(0)
			})
			d.show()
		}

	}

	override func viewWillAppear(animated: Bool) {
		// check if signed in already
		do {
			_ = try Util.getProfile()
			
            self.navigationController?.popViewControllerAnimated(true)
		} catch {
			Util.logMessage("no profile found")
		}
	}

	@IBAction func cancelClicked(sender: AnyObject) {

		self.dismissViewControllerAnimated(true, completion: nil)
	}
	@IBAction func signInClicked(sender: AnyObject) {

		if (emailAddress.text!.isEmpty) {
			showError("Please enter email address")
			return
		}
		if (password.text!.isEmpty) {
			showError("Please enter password")
			return
		}

		submitCitizenLogin()
	}

	func showError(message: String) {
		let d = UNAlertView(title: "Data Error", message: message)
		d.addButton("OK", action: {
			// exit(0)
		})
		d.show()

	}

	func submitCitizenLogin() {
		let req: RequestDTO = RequestDTO(requestType: RequestDTO.SIGN_IN_CITIZEN)
		req.userName = emailAddress.text
		req.password = password.text
		req.municipalityID = muni?.municipalityID
		req.latitude = 0.0
		req.longitude = 0.0

		activityIndicator.hidden = false
		activityIndicator.startAnimating()

		// TODO remove when done
		req.isDebugging = true
		DataUtil.sendRequest(req, listener: self)

	}

	// MARK: DataProtocol functions
	func onResponseDataReceived(response: ResponseDTO) {
		activityIndicator.hidden = true
		activityIndicator.stopAnimating()
		performSegueWithIdentifier(SEGUE_citizenTabs, sender: self)

	}
	func onError(message: String) {
		activityIndicator.hidden = true
		activityIndicator.stopAnimating()

		let m = UNAlertView(title: "Server Response", message: message)
		m.addButton("Close") {
			m.hidden = true
		}
		m.show()

		//
	}

}
