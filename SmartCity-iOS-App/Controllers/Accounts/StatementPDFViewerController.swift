//
//  StatementPDFViewerController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/13/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit
import UNAlertView

class StatementPDFViewerController: UIViewController, UIWebViewDelegate {

	var account: AccountDTO?
	var url: NSURL?
	var year: Int?
	var month: Int?

	let urlPrefix = "http://mobileremoteendpoint/esbapi/V3/accounts/"

	@IBOutlet weak var busy: UIActivityIndicatorView!
	@IBOutlet weak var webView: UIWebView!

	override func viewDidLoad() {
		super.viewDidLoad()
		Util.logMessage(".........pdf viewer starting")
		busy.hidden = true
		webView.scalesPageToFit = true
		webView.delegate = self

		let mURL = "\(urlPrefix)\(account!.accountNumber!)/pdfStatement/\(year!)/\(month!)"
		let x = NSURL(string: mURL)

		let req = NSURLRequest(URL: x!)
		webView.loadRequest(req)
		print(mURL)
		// UIApplication.sharedApplication().openURL(x!)
	}

	func webView(webView: UIWebView, didFailLoadWithError error: Error) {
		let d = UNAlertView(title: "Statement Error", message: "Unable to download statement at this time. Please try later")
		d.addButton("OK", action: {
			d.hidden = true
		})
		d.show()
	}
	func webViewDidStartLoad(webView: UIWebView) {
		Util.logMessage("pdf statement loading ....")
		busy.hidden = false;
		busy.startAnimating()
		setTimer()
	}
	func webViewDidFinishLoad(webView: UIWebView) {
		Util.logMessage("pdf statement done loading")
		busy.hidden = true
		busy.stopAnimating()
		timer?.invalidate()
		timer = nil
	}

	var timer: NSTimer?
	func setTimer() {

		timer = NSTimer.scheduledTimerWithTimeInterval(getTimeInterval(), target: self, selector:
				#selector(StatementPDFViewerController.stopTrying), userInfo: nil, repeats: false)
	}
	func getTimeInterval() -> NSTimeInterval {
		let reachability = Reachability.reachabilityForInternetConnection()

		if reachability.isReachableViaWiFi() {
			return 60.0
		}
		if reachability.isReachableViaWWAN() {
			return 120.0
		}
		else {
			return 180.0
		}
	}
	func stopTrying() {
		timer?.invalidate()
		timer = nil
		let d = UNAlertView(title: "Statement Error", message: "Unable to download statement at this time. Please try later")
		d.addButton("OK", action: {
			d.hidden = true
			self.navigationController?.popViewControllerAnimated(true)
		})
		d.show()

	}

}
