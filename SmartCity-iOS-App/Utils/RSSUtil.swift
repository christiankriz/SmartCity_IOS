//
//  RSSUtil.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 8/29/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import Foundation
import Gloss
import ObjectMapper
import Alamofire

class RSSUtil {

	static let alertsUrl = "http://icsmnewsdev.oneconnectgroup.com/et/alerts/json/Alerts.json"
	static let newsUrl = "http://icsmnewsdev.oneconnectgroup.com/et/news/json/News.json"

	static func getNewsFeed(listener: FeedListener) {
		getFeed(newsUrl, type: 1, listener: listener)

	}
	static func getAlertsFeed(listener: FeedListener) {

		getFeed(alertsUrl, type: 2, listener: listener)
	}
	static func getFeed(url: String, type: Int, listener: FeedListener) {

		Util.logMessage("feed url: \(url)")
		Alamofire.request(.GET, url, parameters: nil).responseJSON { response in

			switch response.result {
			case .Success(let x):

				let feedItems = FeedItems(json: x as! JSON)
				if feedItems == nil || (feedItems?.feedItems.isEmpty)! {
					listener.onFeedReceived([FeedItem]())
					break
				}
				switch (type) {
				case 1:
					Util.setNewsFeedData((feedItems?.feedItems)!)
					break
				case 2:
					Util.setAlertFeedData((feedItems?.feedItems)!)
					break
				default:

					break
				}
				listener.onFeedReceived(feedItems!.feedItems)
			case .Failure(let error):

				Util.logMessage("******** Alamofire ERROR status: \(error.localizedDescription)")
				// TODO - parse the error type and set appr messsage
				listener.onError("Server unable to process request: \(error.localizedDescription)")
			}

		}

	}

}

protocol FeedListener {
	func onFeedReceived(items: [FeedItem])
	func onError(message: String)
}
