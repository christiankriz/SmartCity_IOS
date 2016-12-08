//
//  NewsFeedItemCell.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 8/31/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import Foundation
import UIKit

class NewsFeedItemCell: UITableViewCell {

	var feedItem: FeedItem?

	@IBOutlet weak var headLine: UILabel!
	@IBOutlet weak var newsDate: UILabel!

	@IBOutlet weak var newsImage: UIImageView!

	let img = UIImage(named: "news_default")

	override func awakeFromNib() {
		super.awakeFromNib()
		headLine.lineBreakMode = .ByWordWrapping
		headLine.numberOfLines = 0
	}
	override func setSelected(selected: Bool, animated: Bool) {

	}
	internal func setFeedItem(feedItem: FeedItem) {

		//newsImage.image = img
		if feedItem.thumbnailUrl != nil {
			Util.loadImageFromUrl(feedItem.thumbnailUrl!, view: newsImage)
		}
		headLine.text = feedItem.title
        //headLine.backgroundColor = UIColor.clearColor()
        //newsDate.backgroundColor = UIColor.blackColor()
        //newsDate.hidden = true
		let formatter = NSDateFormatter()
		formatter.dateStyle = .FullStyle
		formatter.timeStyle = .LongStyle

		if feedItem.pubDate != nil {
			//let dateString = formatter.stringFromDate(feedItem.pubDate!)
			//newsDate.text = feedItem.pubDate
		}
		self.feedItem = feedItem

	}
}

