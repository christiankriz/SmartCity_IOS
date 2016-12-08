//
//  FeedItem.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 8/30/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import Foundation
import Gloss
import ObjectMapper

class FeedItem: Decodable, Mappable {
	var title: String? = nil
	var link: String? = nil
	var description: String? = nil
	var thumbnailUrl: String? = nil
	var category: String? = nil
    var expiryDate: String? = nil
	var pubDate: String? = nil
    var latitude: String? = nil
    var longitude: String? = nil

	init() { }
	required  init?(json: JSON) {
		self.title = "title" <~~ json
		self.link = "link" <~~ json
		self.description = "description" <~~ json
		self.thumbnailUrl = "thumbnailUrl" <~~ json
		self.pubDate = "pubDate" <~~ json
		self.category = "category" <~~ json
        self.expiryDate = "expiryDate" <~~ json
        self.latitude = "latitude" <~~ json
        self.longitude = "longitude" <~~ json
    }
	required  init?(_ map: Map) {
	}

	func mapping(map: Map) {

		self.title <- map["title"]
		self.link <- map["link"]
		self.description <- map["description"]
		self.thumbnailUrl <- map["thumbnailUrl"]
		self.pubDate <- map["pubDate"]
        self.expiryDate <- map["expiryDate"]
		self.category <- map["category"]
        self.latitude <- map["latitude"]
        self.longitude <- map["longitude"]
	}
}
class FeedItems: Decodable, Mappable {
	var feedItems: [FeedItem] = [FeedItem]()
	required  init?(json: JSON) {
		self.feedItems = ("feedItems" <~~ json)!
	}
	required  init?(_ map: Map) {
	}

	func mapping(map: Map) {

		self.feedItems <- map["feedItems"]
	}
	init() { }

}
