//
//  AlertInformationController.swift
//  SmartCity-iOS-App
//
//  Created by Christian Nhlabano on 2016/11/30.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit
import UNAlertView

class AlertInformationController: UIViewController, UIWebViewDelegate{
    @IBOutlet weak var webView: UIWebView!
    var urlString: String?
    @IBOutlet weak var publishDate: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    var heading: String?
    var iconImgUrl: String?
    var pubDate: String?
    
    @IBOutlet weak var desc: UILabel!
    //@IBOutlet weak var busy: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title = "Alerts Information"
        //busy.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MenuController.menuButtonPressed(_:)))
        getIcon()
        getAlertImage()
        desc.text = heading
        let endPoint = pubDate!.endIndex.advancedBy(-5)
        pubDate = pubDate!.substringToIndex(endPoint)
        publishDate.text = pubDate
    }
    
    @IBAction func refreshClicked(sender: AnyObject) {
        getAlertImage()
    }
    
    func getAlertImage() {
        //Get alert image
        if urlString != nil{
            let startPoint = urlString!.startIndex.advancedBy(13)
            let endPoint = urlString!.endIndex.advancedBy(-53)
            urlString = urlString!.substringFromIndex(startPoint)
            urlString = urlString!.substringToIndex(endPoint)
            let url = NSURL (string: urlString!);
            if (url == nil) {
                let d = UNAlertView(title: "Feed Error", message: "Unable to reach alert Image url\(urlString)")
                d.addButton("OK", action: {
                    d.hidden = true
                })
                d.show()
            }
            let requestObj = NSURLRequest(URL: url!)
            
            webView.delegate = self
            webView.loadRequest(requestObj);
            webView.scalesPageToFit = true
            webView.contentMode = UIViewContentMode.ScaleAspectFit
        }
    }
    
    
    
    func getIcon() {
        //Get alert image
        if iconImgUrl != nil {
            Util.loadImageFromUrl(iconImgUrl!, view: iconImage)
        }
    }

    func webViewDidStartLoad(webView: UIWebView)
    {
        //busy.hidden = false
        //busy.startAnimating()
    }
    func webViewDidFinishLoad(webView: UIWebView)
    {
        //busy.stopAnimating()
        //busy.hidden = true
    }
    
    
   }

