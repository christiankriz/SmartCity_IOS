//
//  FAQWebViewController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/3/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit

class FAQWebViewController: UIViewController {

	@IBOutlet weak var webView: UIWebView!

	var index: Int = 0
	let FAQ_URL = "http://icsmnewsdev.oneconnectgroup.com/et/faq/"

	override func viewDidLoad() {
		super.viewDidLoad()
        
        navigationController?.toolbarHidden = true

		switch index {
		case 0:
			loadWebView("\(FAQ_URL)AccountsPayments.html")
            break
		case 1:
			loadWebView("\(FAQ_URL)WaterSanitation.html")
            break
		case 2:
			loadWebView("\(FAQ_URL)CleansingSolidWaste.html")
            break
		case 3:
			loadWebView("\(FAQ_URL)RatesTaxes.html")
            break
		case 4:
			loadWebView("\(FAQ_URL)BuildingPlans.html")
            break
		case 5:
			loadWebView("\(FAQ_URL)Electricity.html")
            break
		case 6:
			loadWebView("\(FAQ_URL)SocialServices.html")
            break
		case 7:
			loadWebView("\(FAQ_URL)Health.html")
            break
		case 8:
			loadWebView("\(FAQ_URL)MetroPolice.html")
            break

		default:
			loadWebView("\(FAQ_URL)MetroPolice.html")
		}
	}

	func loadWebView(url: String) {
        Util.logMessage("loading faq page \(url)")
		UIWebView.loadRequest(webView)(NSURLRequest(URL: NSURL(string: url)!))

	}
}
