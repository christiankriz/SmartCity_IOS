//
//  StatementPDFViewerController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/13/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit
import UNAlertView
import Alamofire
import ObjectMapper

class StatementPDFViewerController: UIViewController, UIWebViewDelegate {

    var account: AccountDTO?
    var url: NSURL?
    var year: Int?
    var month: Int?
    var monthCount: Int?
    var docURL: NSURL?
    var fileName : String!
    
    
    @IBOutlet weak var busy: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Util.logMessage(".........pdf viewer starting")
        busy.hidden = true
        webView.scalesPageToFit = true
        webView.delegate = self
        self.docURL = (NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)).last as? NSURL!
        
        self.docURL = self.docURL?.URLByAppendingPathComponent( fileName)
        let statementPrint = NSURLRequest(URL: self.docURL!)
        self.webView.loadRequest(statementPrint)
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