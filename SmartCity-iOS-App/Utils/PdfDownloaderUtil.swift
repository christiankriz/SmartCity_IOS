//
//  PdfDownloaderUtil.swift
//  SmartCity-iOS-App
//
//  Created by Christian Nhlabano on 2017/01/24.
//  Copyright © 2017 Aubrey Malabie. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import Toast_Swift


class PdfDownloaderUtil: NSObject {
    //let urlPrefix = "http://mobileremoteendpoint/esbapi/V3/accounts/"
    //let urlPrefix = "http://10.10.7.101:3021/esbapi/V3/accounts/"
    
    //let pdfUrl = "http://localhost:8080/SmartCityPDFDownloader/pdf/"
    //static let pdfUrl = "http://localhost:8080/sc/pdf"
    //static let pdfUrl = "http://smartcity.ocgroup.co.za/sc/pdf"
    //static let pdfUrl = "http://10.0.0.110:8080/sc/pdf"  //sasa machine
    //static let pdfUrl = "http://10.0.0.194:8080/sc/pdf"  //chris machine
    static let pdfUrl = "https://smartcity.ocgroup.co.za/sc/pdf"
    
    static var docURL: NSURL?
    
    static func checkFileExist(fileList : [String], fileName : String) -> Bool{
        var exist = false
        if fileList.contains(fileName) {
            exist = true
        }
        return exist
    }
    
    static func getAccountStatementList(fileList : [String], accountNumber : String) -> [Int:String]{
        var accountListDict = [Int:String]()
        var accountName : String
        for i in 0..<fileList.count{
            accountName = fileList[i]
            if accountName.containsString(accountNumber){
                //get year from file name
                let yearRange = accountName.rangeOfString("-", options: .BackwardsSearch)?.startIndex
                let yearIndex = accountName.endIndex.advancedBy(-4)
                let year = accountName.substringFromIndex(yearIndex)
                
                //get month from filename
                let subStr1 = accountName.substringToIndex(yearRange!)
                //let monthRange = subStr1.rangeOfString("-", options: .BackwardsSearch)?.startIndex
                //let month = subStr1.substringFromIndex(monthRange!)
                let monthIndex = subStr1.endIndex.advancedBy(-2)
                let month = subStr1.substringFromIndex(monthIndex)
                accountListDict.updateValue(year, forKey: Int(month)!)

            }
        }
       return accountListDict
    }
    
    static func getPdf(req :RequestDTO, listener: DownloadProtocol, fileName : String){
        let JSONString = Mapper().toJSONString(req, prettyPrint: true)
        Util.logMessage("\n\nGenerated JSON: \(JSONString!)")
        
        Alamofire.request(.GET, pdfUrl, parameters: ["JSON": JSONString!]).response
            { request, response, data, error in
                print(request)
                print(response)
                print(error)
                var fileFound = false
                let contentLength = data?.length
                if error == nil && response != nil && contentLength > 1000{
                    //Get the local docs directory and append your local filename.
                    self.docURL = (NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)).last as? NSURL!
                    
                    self.docURL = self.docURL?.URLByAppendingPathComponent(fileName)
                    
                    //Lastly, write your file to the disk.
                    data?.writeToURL(self.docURL!, atomically: true)
                    let x = NSURLRequest(URL: self.docURL!)
                    print(x)
                    fileFound = true
                }else{
                    //if(contentLength < 1000){
                        //listener.onError("one of the statements not available ")
                    //}else{
                        listener.onError("Server unable to process request")
                    return
                    //}
                }
                listener.onResponseDownloadReceived(fileFound)
        }
    }
}

protocol DownloadProtocol {
    func onResponseDownloadReceived(fileFound: Bool)
    func onError(message: String)
}
