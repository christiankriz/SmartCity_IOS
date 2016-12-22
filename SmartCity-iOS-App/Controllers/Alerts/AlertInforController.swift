//
//  AlertInformationController.swift
//  SmartCity-iOS-App
//
//  Created by Christian Nhlabano on 2016/11/30.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit
import UNAlertView

class AlertInformationController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    var urlString: String?
    @IBOutlet weak var publishDate: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    var heading: String?
    var iconImgUrl: String?
    var pubDate: String?
    var menuController : MenuController?
    
    @IBOutlet weak var desc: UILabel!
    //@IBOutlet weak var busy: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title = "Alerts Information"
        //busy.startAnimating()
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
            webView.clipsToBounds = true
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
    
    
    func menuButtonPressed(sender: UIBarButtonItem) {
        
        let smartMenuController = UIAlertController(title: "Smart City Menu", message: "Select Option", preferredStyle: .Alert)
        let smartCityGuideButton = UIAlertAction(title: "Smartcity Guide", style: .Default, handler: { (action) -> Void in
            //println("Button One Pressed")
        })
        let generalInforButton = UIAlertAction(title: "General Infor", style: .Default, handler: { (action) -> Void in
            //println("Button Three Pressed")
        })
        let logOff = UIAlertAction(title: "Log Off", style: .Default, handler: { (action) -> Void in
            //println("Button Four Pressed")
        })
        let buttonCancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            //println("Cancel Button Pressed")
        }
        smartMenuController.addAction(smartCityGuideButton)
        //smartMenuController.addAction(emergencyContactButton)
        smartMenuController.addAction(generalInforButton)
        smartMenuController.addAction(logOff)
        smartMenuController.addAction(buttonCancel)
        
        presentViewController(smartMenuController, animated: true, completion: nil)
        
    }

    
   }

