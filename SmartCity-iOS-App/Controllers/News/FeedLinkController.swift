//
//  FeedLinkController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/1/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit
import UNAlertView

class FeedLinkController: UIViewController, UIWebViewDelegate {

	@IBOutlet weak var webView: UIWebView!

	var urlString: String?

	@IBOutlet weak var busy: UIActivityIndicatorView!
	@IBOutlet weak var btnRefresh: UIBarButtonItem!
	override func viewDidLoad() {
		super.viewDidLoad()
		busy.startAnimating()
		getContent()

	}

	@IBAction func refreshClicked(sender: AnyObject) {
		getContent()
	}

	func getContent() {
		let url = NSURL (string: urlString!);
        if (url == nil) {
            let d = UNAlertView(title: "Feed Error", message: "Unable to reach \(urlString)")
            d.addButton("OK", action: {
                d.hidden = true
            })
            d.show()
        }
		let requestObj = NSURLRequest(URL: url!)

		webView.delegate = self
		webView.loadRequest(requestObj);

	}
	func webViewDidStartLoad(webView: UIWebView)
	{
		busy.hidden = false
		busy.startAnimating()
	}
	func webViewDidFinishLoad(webView: UIWebView)
	{
		busy.stopAnimating()
		busy.hidden = true
	}

}
