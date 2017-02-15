//
//  StatementDownloadController.swift
//  SmartCity-iOS-App
//
//  Created by Christian Nhlabano on 2017/01/12.
//  Copyright © 2017 Aubrey Malabie. All rights reserved.
//

import UIKit
import UNAlertView
import DLRadioButton


class StatementDownloadController: UIViewController , UITextViewDelegate, UIPickerViewDelegate, DownloadProtocol {
    var account: AccountDTO?
    var year: Int!
    var month: Int!
    var monthCount: Int!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    let SEGUE_toPDFView = "toDisplayStatementSegue"
    @IBOutlet weak var threeMonth: DLRadioButton!
    @IBOutlet weak var twoMonth: DLRadioButton!
    @IBOutlet weak var oneMonth: DLRadioButton!
    var docURL: NSURL?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var fileDownloaded = false;
    var responseCount = 0
    var numOfFileDownloaded = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = true
        assignListeners()
    }
    
    func assignListeners(){
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.addTarget(self, action: #selector(StatementDownloadController.handler(_:)), forControlEvents: UIControlEvents.ValueChanged)
        datePicker.sendActionsForControlEvents(.TouchUpInside)
        oneMonth.addTarget(self, action: #selector(StatementDownloadController.logSelectedButton), forControlEvents: UIControlEvents.TouchUpInside);
        twoMonth.addTarget(self, action: #selector(StatementDownloadController.logSelectedButton), forControlEvents: UIControlEvents.TouchUpInside);
        threeMonth.addTarget(self, action: #selector(StatementDownloadController.logSelectedButton), forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    let dateFormatter = NSDateFormatter()
    
    
    func handler(sender: UIDatePicker) {
        // grab the selected data from the date picker
        dateFormatter.dateFormat = "MM"
        month = Int(dateFormatter.stringFromDate(datePicker.date))
        dateFormatter.dateFormat = "YYYY"
        year = Int(dateFormatter.stringFromDate(datePicker.date))
        print("year:\(year) , weekMonth:\(month)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let linkController = segue.destinationViewController as! StatementListDisplayController
        linkController.account = account
    }
    
    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
        let selectMonth = radioButton.selectedButton()!.titleLabel!.text!
        if (selectMonth == "3 month") {
            oneMonth.selected = false
            twoMonth.selected = false
            monthCount = 3;
            print(String(format: "%@ is selected.\n", radioButton.selectedButton()!.titleLabel!.text!));
        } else if (selectMonth == "2 month") {
            oneMonth.selected = false
            threeMonth.selected = false
            monthCount = 2;
            print(String(format: "%@ is selected.\n", radioButton.selectedButton()!.titleLabel!.text!));
        }else if (selectMonth == "1 month"){
            threeMonth.selected = false
            twoMonth.selected = false
            monthCount = 1;
            print(String(format: "%@ is selected.\n", radioButton.selectedButton()!.titleLabel!.text!));
        }
        
        
    }
    
    var muni: MunicipalityDTO?
    @IBAction func statementDownload(sender: UIButton) {
        var i = 0
        var fileName : String
        var fileExist : Bool
        fileDownloaded = false
        sender.enabled = false
        let req = RequestDTO(requestType: RequestDTO.GET_IOS_PDF_STATEMENT)
        if month == nil{
            let d = UNAlertView(title: "Services Message",
                                message: "Select Date First")
            d.addButton("OK", action: {
                d.hidden = true
            })
            d.show()
         }else{
            if monthCount == nil{
                monthCount = 1
            }
            while i < monthCount {
                if month < 10{
                    fileName = (account?.accountNumber)! + "-0" + String(month)
                    fileName += "-" + String(year) + ".pdf"
                }else{
                    fileName = (account?.accountNumber)! + "-" + String(month)
                    fileName += "-" + String(year) + ".pdf"
                }
                i += 1
                month = month - 1
                if month == 0{
                    month = 12
                    year = year - 1
                }
                let fileList = Util.listOfStatementFiles()
                fileExist = PdfDownloaderUtil.checkFileExist(fileList, fileName: fileName)
                if(!fileExist){
                    req.accountNumber = account?.accountNumber
                    req.year = year
                    req.month = month
                    req.zipResponse = false;
                    do {
                        muni = try Util.getMunicipality()
                        req.municipalityID = muni?.municipalityID
                    } catch {
                        
                    }
                    activityIndicator.hidden = false
                    activityIndicator.startAnimating()
                    PdfDownloaderUtil.getPdf(req, listener: self, fileName: fileName)
                }
            }
        }
        sender.enabled = true
                //performSegueWithIdentifier("toDisplayStatementSegue", sender: self)
    }
    
    func onResponseDownloadReceived(fileFound : Bool) {
        responseCount += 1
        if fileFound{
            numOfFileDownloaded += 1
            fileDownloaded = true
        }
        if responseCount == monthCount{
            if fileDownloaded {
                ondownloadComplete(String(numOfFileDownloaded) +  " Downloaded")
            }else{
                onError("statement not available")
            }
        }
     }
    
    func onError(message: String) {
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
        Util.logMessage(message)
        let d = UNAlertView(title: "Services Message",
                            message: message)
        d.addButton("OK", action: {
            d.hidden = true
        })
        d.show()
    }
    
    func ondownloadComplete(message: String) {
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
        Util.logMessage(message)
        let d = UNAlertView(title: "Download Status",
                            message: message)
        d.addButton("OK", action: {
            d.hidden = true
            self.activityIndicator.hidden = true
            self.activityIndicator.stopAnimating()
            self.performSegueWithIdentifier("toStatementListFromDate", sender: self)
        })
        d.show()
    }
  
    
}

