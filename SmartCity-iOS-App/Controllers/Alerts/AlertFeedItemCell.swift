//
//  AlertFeedItemCell.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 8/31/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit
import Foundation

class AlertFeedItemCell: UITableViewCell {

	@IBOutlet weak var headLine: UILabel!

	@IBOutlet weak var alertDate: UILabel!
	@IBOutlet weak var alertImage: UIImageView!

	var feedItem: FeedItem?

	override func awakeFromNib() {
		super.awakeFromNib()
	}
	override func setSelected(selected: Bool, animated: Bool) {

	}

	internal func setFeedItem(feedItem: FeedItem) {
		Util.logMessage("AlertFeedItemCell: \(feedItem.title!) \n \(feedItem.thumbnailUrl!)")
		if feedItem.thumbnailUrl != nil {
			Util.loadImageFromUrl(feedItem.thumbnailUrl!, view: alertImage)
		}
		headLine.text = feedItem.title
		let formatter = NSDateFormatter()
		formatter.dateStyle = .FullStyle
		formatter.timeStyle = .LongStyle

		if feedItem.pubDate != nil {
			// let dateString = formatter.stringFromDate(feedItem.pubDate!)
            var pubDateFormatted = feedItem.pubDate
            let endPoint = pubDateFormatted!.endIndex.advancedBy(-5)
            pubDateFormatted = pubDateFormatted!.substringToIndex(endPoint)
			alertDate.text = pubDateFormatted
		}
		self.feedItem = feedItem

	}
}
