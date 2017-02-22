//
//  Util.swift
//  Tester2
//
//  Created by Aubrey Malabie on 2015/11/06.
//  Copyright © 2015 Aubrey Malabie. All rights reserved.
//

import Foundation
import ObjectMapper
import Gloss

class Util {

	struct signInData {
		static let profileInfo = "profileInfo"
		static let user = "user"
	}
	static func loadImageFromUrl(link: String, view: UIImageView) {

		// Create Url from string
		// Util.logMessage("loading image url: \(link)")
		let url = NSURL(string: link)

		// Download task:
		// - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
		let task2 = NSURLSession.sharedSession().dataTaskWithURL(url!) { (responseData, responseUrl, error) in
			if let data = responseData {

				if error != nil {
					print(error)
					return
				}
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					view.image = UIImage(data: data)
					view.slideInFromLeft()
					view.alpha = 0.1

					UIView.animateWithDuration(1.0, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () in
						view.alpha = 1.0;
						}, completion: { (Bool) in

					})
				})

			}
		}

		// Run task
		task2.resume()
	}

	static func printTextOnImage(drawText: NSString, inImage: UIImage,
		atPoint: CGPoint, textSize: CGFloat, fontName: String, color: UIColor) -> UIImage {

			// Setup the font specific variables
			let textFont: UIFont = UIFont(name: fontName, size: textSize)!

			// Setup the image context using the passed image.
			UIGraphicsBeginImageContext(inImage.size)

			// Setups up the font attributes that will be later used to dictate how the text should be drawn
			let textFontAttributes = [
				NSFontAttributeName: textFont,
				NSForegroundColorAttributeName: color,
			]

			// Put the image into a rectangle as large as the original image.
			inImage.drawInRect(CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))

			// Creating a point within the space that is as big as the image.
			let rect: CGRect = CGRect(x: atPoint.x, y: atPoint.y, width: inImage.size.width, height: inImage.size.height)

			// Now Draw the text into an image.
			drawText.drawInRect(rect, withAttributes: textFontAttributes)

			// Create a new image out of the images we have created
			let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!

			// End the context now that we have the image we need
			UIGraphicsEndImageContext()
			return newImage

	}
	static func setFormRowFont(cell: UITableViewCell) {
		cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
		cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 16)
	}
	static func setFormRowBoldFont(cell: UITableViewCell) {
		cell.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 13)
		cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
	}
	// MARK: User Checks
	static func checkProfileSignedIn() -> Bool {
		Util.logMessage("checking ... passport control ... PROFILE")
		let defaults = NSUserDefaults.standardUserDefaults()
		let profile = defaults.stringForKey(signInData.profileInfo)
		if (profile == nil) {
			return false
		} else {
			return true
		}
	}
	static func checkGuestSignedIn() -> Bool {
		Util.logMessage("checking ... passport control ... GUEST")
		let defaults = NSUserDefaults.standardUserDefaults()
		let user = defaults.stringForKey(signInData.user)
		if (user == nil) {
			return false
		} else {
			return true
		}
	}

	static func logMessage(message: String, filename: String = #file, line: Int = #line, function: String = #function) {
		print("-------- : \((filename as NSString).lastPathComponent):\(line) \(function):\r\(message)")
	}

	static func setUser(user: UserDTO) {
		let defaults = NSUserDefaults.standardUserDefaults()
		let JSONString = Mapper().toJSONString(user, prettyPrint: false)
		defaults.setValue(JSONString, forKey: Constants.USER)
		logMessage("user: \(JSONString)")
	}
	static func getUser() throws -> UserDTO {
		logMessage("am here")
		let defaults = NSUserDefaults.standardUserDefaults()
		var user: UserDTO?
		var string: String?
		string = defaults.valueForKey(Constants.USER) as? String
		if (string == nil) {
			throw Error.noUserFound
		}
		let json = string!.parseJSONString
		user = UserDTO(json: json as! JSON)
		logMessage("cached user data retrieved")
		return user!

	}

	static func setProfile(profile: ProfileInfoDTO) {
		let defaults = NSUserDefaults.standardUserDefaults()
		let JSONString = Mapper().toJSONString(profile, prettyPrint: false)
		defaults.setValue(JSONString, forKey: Constants.PROFILE)
		logMessage("user: \(JSONString)")

	}
	static func removeProfile() {
		let defaults = NSUserDefaults.standardUserDefaults()
		defaults.removeObjectForKey(Constants.PROFILE)
		logMessage("Profile has been removed. User has to login again")
		do {
			let prof = try getProfile()
			Util.logMessage("Profile still around: \(prof.email)")
		} catch {
			Util.logMessage("Profile checked - removed")
		}

	}
	static func getProfile() throws -> ProfileInfoDTO {
		logMessage("am here")
		let defaults = NSUserDefaults.standardUserDefaults()
		var prof: ProfileInfoDTO?
		var string: String?
		string = defaults.valueForKey(Constants.PROFILE) as? String
		if (string == nil) {
			throw Error.noProfileFound
		}
		let json = string!.parseJSONString
		prof = ProfileInfoDTO(json: json as! JSON)
		logMessage("cached profile data retrieved")
		return prof!

	}

	static func setMunicipality(municipality: MunicipalityDTO) {
		let defaults = NSUserDefaults.standardUserDefaults()
		let JSONString = Mapper().toJSONString(municipality, prettyPrint: false)
		defaults.setValue(JSONString, forKey: Constants.MUNICIPALITY)

		logMessage("municipality cached on disk:\n \(JSONString!)")
	}
	static func getMunicipality() throws -> MunicipalityDTO {
		let defaults = NSUserDefaults.standardUserDefaults()
		var m: MunicipalityDTO?
		var string: String?
		string = defaults.valueForKey(Constants.MUNICIPALITY) as? String
		if (string == nil) {
			throw Error.noMunicipalityFound
		}
		let json = string!.parseJSONString
		m = MunicipalityDTO(json: json as! JSON)
		logMessage("cached muni data retrieved:\n \(json!)")
		return m!

	}
	static func setResponseData(resp: ResponseDTO) {
		let defaults = NSUserDefaults.standardUserDefaults()
		let JSONString = Mapper().toJSONString(resp, prettyPrint: false)
		defaults.setValue(JSONString, forKey: Constants.RESPONSE_DATA)

		logMessage("resp: \(JSONString)")
	}
	static func getResponseData() throws -> ResponseDTO {
		let defaults = NSUserDefaults.standardUserDefaults()
		var resp: ResponseDTO?
		var string: String?
		string = defaults.valueForKey(Constants.RESPONSE_DATA) as? String
		if (string == nil) {
			throw Error.noResponseDataFound
		}
		let json = string!.parseJSONString
		resp = ResponseDTO(json: json as! JSON)
		logMessage("cached response data retrieved")
		return resp!

	}
	static func setAlertFeedData(list: [FeedItem]) {
		let defaults = NSUserDefaults.standardUserDefaults()
		let fi = FeedItems()
		fi.feedItems = list
		let JSONString = Mapper().toJSONString(fi, prettyPrint: false)
		defaults.setValue(JSONString, forKey: Constants.ALERT_FEED_DATA)

		logMessage("alert feed: \(JSONString)")
	}
	static func getAlertFeedData() throws -> [FeedItem] {
		let defaults = NSUserDefaults.standardUserDefaults()
		var string: String?
		string = defaults.valueForKey(Constants.ALERT_FEED_DATA) as? String
		if (string == nil) {
			throw Error.noResponseDataFound
		}
		let json = string!.parseJSONString
		let resp = FeedItems(json: json as! JSON)
		logMessage("cached alert feed data retrieved: \((resp?.feedItems)!)")
		return (resp?.feedItems)!

	}
	static func setNewsFeedData(list: [FeedItem]) {
		let defaults = NSUserDefaults.standardUserDefaults()
		let fi = FeedItems()
		fi.feedItems = list
		let JSONString = Mapper().toJSONString(fi, prettyPrint: false)
		defaults.setValue(JSONString, forKey: Constants.NEWS_FEED_DATA)

		logMessage("news feed: \(JSONString)")
	}
	static func getNewsFeedData() throws -> [FeedItem] {
		let defaults = NSUserDefaults.standardUserDefaults()
		var string: String?
		string = defaults.valueForKey(Constants.NEWS_FEED_DATA) as? String
		if (string == nil) {
			throw Error.noResponseDataFound
		}
		let json = string!.parseJSONString
		let resp = FeedItems(json: json as! JSON)
		logMessage("cached news feed data retrieved: \(resp!.feedItems)")
		return resp!.feedItems

	}
    static func setCouncillorData(list: [CouncillorsItem]) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let ci = CouncillorItems()
        ci.councillorsItem = list
        let JSONString = Mapper().toJSONString(ci, prettyPrint: false)
        defaults.setValue(JSONString, forKey: Constants.NEWS_FEED_DATA)
        
        logMessage("councillor data: \(JSONString)")
    }
    static func getCouncillorData() throws -> [CouncillorsItem] {
        let defaults = NSUserDefaults.standardUserDefaults()
        var string: String?
        string = defaults.valueForKey(Constants.COUNCILLOR_FEED_DATA) as? String
        if (string == nil) {
            throw Error.noResponseDataFound
        }
        let json = string!.parseJSONString
        let resp = CouncillorItems(json: json as! JSON)
        logMessage("cached news feed data retrieved: \(resp!.councillorsItem)")
        return resp!.councillorsItem
        
    }

	static func getData() -> ResponseDTO {
		let file = "response.json"
		var response: ResponseDTO = ResponseDTO()

		if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
			let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
			// reading
			do {
				let string: String = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding) as String
				Util.logMessage(string)
				let json: AnyObject? = string.parseJSONString
				response = ResponseDTO(json: json as! JSON)!
			}
			catch { /* error handling here */ }
		}

		// let fileManager = NSFileManager.defaultManager()
		// let dirURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		//
		// let documentDirectoryURL = try! FileManager.default.url(for: .DocumentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
		// let fileDestinationUrl = dirURL.app("response.json")
		// do {
		// let string = try String(contentsOfURL: fileDestinationUrl, encoding: String.Encoding.utf8)
		// let json: AnyObject? = string.parseJSONString
		// response = ResponseDTO(json: json as! JSON)!
		//
		// } catch let error as NSError {
		// response.statusCode = 9
		// response.message = "Unable to retrieve cached data"
		// Util.logMessage("error writing to url \(fileDestinationUrl) error: \(error.localizedDescription)")
		// } catch {
		// Util.logMessage("error writing to url \(fileDestinationUrl)")
		// response.statusCode = 9
		// response.message = "Unable to retrieve cached data"
		// }
		return response
	}

	static func writeToFile(data: String) {
		let file = "response.json"
		if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
			let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)

			// writing
			do {
				try data.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
			}
			catch { /* error handling here */ }

			// reading
			do {
				let text2 = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
				Util.logMessage(text2 as String)
			}
			catch { /* error handling here */ }
		}

		//
		//
		//
		//
		// let fileManager = NSFileManager.defaultManager()
		// let dirURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		//
		// let documentDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		// let fileDestinationUrl = documentDirectoryURL.appendingPathComponent("response.json")
		//
		// do {
		// try data.write(to: fileDestinationUrl, atomically: true, encoding: String.Encoding.utf8)
		//
		// } catch let error as NSError {
		// Util.logMessage("error writing to url \(fileDestinationUrl) error: \(error.localizedDescription)")
		// } catch {
		//
		// }
	}
	// static func writeStatementToFile(fileName: String, data: NSArray) {
	// let fileManager = NSFileManager.defaultManager()
	// let dirURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
	//
	// do {
	// let documentDirectoryURL = try! NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
	//
	// let fileDestinationUrl = documentDirectoryURL.app
	// Util.logMessage("Statement File: \(fileDestinationUrl)")
	// data.write(to: fileDestinationUrl, atomically: true)
	// // listStatementUrls()
	// listStatementFiles()
	// } catch {
	//
	// }
	// }

	static func listStatementFiles() -> [String] {
		// let fileManager = NSFileManager.defaultManager()
		// let dirURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)

		// let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

		var pdfFileNames = [String]()
		do {
			// Get the directory contents urls (including subfolders urls)
			let fileManager = NSFileManager.defaultManager()
			let dirURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            print("pdf directory:", dirURL)
			// let directoryContents = try FileManager.default.contentsOfDirectory(at: dirURL, includingPropertiesForKeys: nil, options: [])
			// // if you want to filter the directory contents you can do like this:
			let pdfFiles = dirURL.filter { $0.pathExtension == "pdf" }
			pdfFileNames = pdfFiles.flatMap({ $0.URLByDeletingPathExtension!.lastPathComponent })
			print("pdfFileName list:", pdfFileNames)

		} catch let error as NSError {
			print(error.localizedDescription)
		}
		return pdfFileNames
	}
    
    static func listOfStatementFiles() -> [String] {
        var pdfFileNames = [String]()
        // Get the document directory url
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL( documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let pdfDirectoryFiles = directoryContents.filter{ $0.pathExtension == "pdf" }
            print("pdf urls:",pdfDirectoryFiles)
            pdfFileNames = pdfDirectoryFiles.flatMap({$0.URLByDeletingPathExtension?.lastPathComponent})
            print("pdf list:", pdfFileNames)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return pdfFileNames
    }

	// static func listStatementUrls() -> [URL] {
	// let fileManager = NSFileManager.defaultManager()
	// let dirURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
	//
	//// let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
	//
	// var pdfFiles: [URL] = [URL]()
	// do {
	// // Get the directory contents urls (including subfolders urls)
	// let directoryContents = try FileManager.default.contentsOfDirectory(at: dirURL, includingPropertiesForKeys: nil, options: [])
	// pdfFiles = directoryContents.filter { $0.pathExtension == "pdf" }
	// print("PDF Statement urls:", pdfFiles)
	// return pdfFiles
	// } catch let error as NSError {
	// print(error.localizedDescription)
	// }
	// return pdfFiles
	// }

}
extension String {

	var parseJSONString: AnyObject? {

		let data = self.dataUsingEncoding(String.defaultCStringEncoding(), allowLossyConversion: false)
		var ret: AnyObject?
		if let jsonData = data {
			// Will return an object or nil if JSON decoding fails
			do {
                ret = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
				Util.logMessage("\(ret!)")
			} catch {
				Util.logMessage(".... we have a small problem")
			}

		} else {
			// Lossless conversion of the string was not possible
			return nil
		}
		return ret
	}
}

enum Error: ErrorType {
	case noProfileFound
	case noUserFound
	case noMunicipalityFound
	case noResponseDataFound
}

import UIKit

extension UIView {
	// Name this function in a way that makes sense to you...
	// slideFromLeft, slideRight, slideLeftToRight, etc. are great alternative names
	func slideInFromLeft(duration: NSTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
		// Create a CATransition animation
		let slideInFromLeftTransition = CATransition()

		// Set its callback delegate to the completionDelegate that was provided (if any)
		if let delegate: AnyObject = completionDelegate {
			slideInFromLeftTransition.delegate = delegate
		}

		// Customize the animation's properties
		slideInFromLeftTransition.type = kCATransitionPush
		slideInFromLeftTransition.subtype = kCATransitionFromLeft
		slideInFromLeftTransition.duration = duration
		slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		slideInFromLeftTransition.fillMode = kCAFillModeRemoved

		// Add the animation to the View's layer
		self.layer.addAnimation(slideInFromLeftTransition, forKey: "slideInFromLeft")
	}
	func fadeIn(image: UIImageView) {
		image.alpha = 0.1

		UIView.animateWithDuration(2.0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () in
			image.alpha = 1.0;
			}, completion: { (Bool) in

		})
	}
}

