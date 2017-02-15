//
//  StatementListDisplayController.swift
//  SmartCity-iOS-App
//
//  Created by Christian Nhlabano on 2017/01/25.
//  Copyright © 2017 Aubrey Malabie. All rights reserved.
//

import UIKit

class StatementListDisplayController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var sortedKeys = [String]()
    var account: AccountDTO?
    var statementList = [String]()
    var statementDict = [Int:String]()
    let SEGUE_toDatePicker = "toDatePickerSegue"
    let SEGUE_toStatementView = "displayStatementSegue"
    var linkControllerForStatementDownload : StatementDownloadController!
    var linkControllerForStatementView : StatementPDFViewerController!
    let monthInYear = [1 : "January", 2 : "February", 3 : "March", 4 : "April", 5 : "May", 6 : "June",
                       7 : "July", 8  : "August", 9 : "September", 10 : "October", 11 : "November", 12 : "December"]

    @IBOutlet weak var statementListView: UITableView!
    @IBOutlet weak var accountName: UILabel!
        
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var statementAvailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadButton.layer.cornerRadius = 5
        downloadButton.layer.borderWidth = 1
        downloadButton.layer.borderColor = UIColor.blueColor().CGColor
        downloadButton.frame = CGRectMake(200, 200, 100, 100)
        //downloadButton.addTarget(self, action: #selector(fetchStatement(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        statementListView.dataSource = self
        statementListView.delegate = self
        accountName.text = accountName.text! +  (account!.accountNumber)!
        statementList = Util.listOfStatementFiles()
        statementDict = PdfDownloaderUtil.getAccountStatementList(statementList, accountNumber: (account?.accountNumber)!)
        //sortedKeys = Array(arrayLiteral: String(statementDict.keys)).sort()
        
        //if statementDict.count > 0 {
        statementAvailLabel.hidden = true
        getStatementMonth()
        //}
    }
    
    @IBAction func getMeStatement(sender: AnyObject) {
        //performSegueWithIdentifier(SEGUE_toDatePicker, sender: self)
    }
    
    
    func getStatementMonth(){
        statementList.removeAll()
        for (key,value) in statementDict{
            let month = getMonth(key)
            let year = "\(value)"
            statementList.append(String(month) + ",  " + String(year))
        }
    }
    
    func getMonth(monthNumber : Int) -> String{
        var monthName : String?
        for (key,value) in monthInYear{
            if monthNumber == key{
                monthName = "\(value)"
            }
        }
        return monthName!
    }
    
    func getMonthNumber(monthName : String) -> Int{
        var monthNum : Int?
        for (key,value) in monthInYear{
            if monthName == value{
                monthNum = key
            }
        }
        return monthNum!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statementList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! StatementDisplayCell
        if statementDict.count > 0 {
            let name = statementList[(indexPath as NSIndexPath).row]
            cell.statementName.text = name
        }else{
            cell.statementName.text = "No Statements"
            cell.statementName.textColor = UIColor.brownColor()
        }
       return cell
    }
    
    var currentIndex = 0;
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! StatementDisplayCell
        // Configure the cell...
        let dateSelected = cell.statementName.text
        linkControllerForStatementView.fileName = getSelectedDate(dateSelected!)
    }
    
    func getSelectedDate(selectedDate : String) ->String{
        //get year from file name
        let yearRange = selectedDate.rangeOfString(",", options: .BackwardsSearch)?.startIndex
        let yearIndex = selectedDate.endIndex.advancedBy(-4)
        let year = selectedDate.substringFromIndex(yearIndex)
        
        //get month from filename
        let month = selectedDate.substringToIndex(yearRange!)
        var fileName : String
        let monthStr = getMonthNumber(String(month))
        if Int(month) < 10{
            fileName = (account?.accountNumber)! + "-0" + String(monthStr)
            fileName += "-" + String(year) + ".pdf"
        }else{
            fileName = (account?.accountNumber)! + "-" + String(monthStr)
            fileName += "-" + String(year) + ".pdf"
        }
        return fileName
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_toDatePicker {
           linkControllerForStatementDownload = segue.destinationViewController as! StatementDownloadController
           linkControllerForStatementDownload.account = account
        }else if segue.identifier == SEGUE_toStatementView{
            linkControllerForStatementView = segue.destinationViewController as! StatementPDFViewerController
        }
    }
}
