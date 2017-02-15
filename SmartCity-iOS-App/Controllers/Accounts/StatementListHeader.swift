//
//  StatementListHeader.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/13/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit
import UNAlertView

class StatementListHeader: UITableViewHeaderFooterView, DataProtocol {

	@IBOutlet weak var segmentedControl: UISegmentedControl!

	@IBOutlet weak var labelTitle: UILabel!

	@IBOutlet weak var datePicker: MonthYearPickerView!
	var account: AccountDTO?
	var listener: HeaderListener?
    var docURL: NSURL?

	@IBAction func downloadStatements(sender: AnyObject) {

		let index = segmentedControl.selectedSegmentIndex
		let month = datePicker.month
		let year = datePicker.year
        
        //let month = 4
        //let year = 2016

		let req = RequestDTO(requestType: RequestDTO.GET_PDF_STATEMENT)
		req.accountNumber = account?.accountNumber
		req.year = year
		req.month = month
		req.count = index + 1;

		DataUtil.sendRequest(req, listener: self)

		listener?.onDownloadRequested((account?.accountNumber)!, year: year, month: month, count: index + 1)

	}

	func onResponseDataReceived(response: ResponseDTO) {

		let dict = response.pdfHashMap
		for (key, _) in dict! {
			print(key)
			//Util.writeStatementToFile("\(key as! String).pdf", data: dict?.valueForKey(key) as! NSArray)
            self.docURL = (NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)).last as? NSURL!
            
            var fileName = key as! String
            fileName += ".pdf"
            self.docURL = self.docURL?.URLByAppendingPathComponent( fileName)
            
            //Lastly, write your file to the disk.
            let data = dict?.valueForKey(key as! String)
            data!.writeToURL(self.docURL!, atomically: true)
            let x = NSURLRequest(URL: self.docURL!)
            print(x)
		}

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
protocol HeaderListener {
	func onDownloadRequested(accountNumber: String, year: Int, month: Int, count: Int)
}
