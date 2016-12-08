//
//  FAQTableViewCell.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/3/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit

class FAQTableViewCell: UITableViewCell {

	@IBOutlet weak var faqTitle: UILabel!
	@IBOutlet weak var number: UILabel!

	var mTitle: String?
	var index = 0

	override func awakeFromNib() {
		super.awakeFromNib()
		Util.logMessage("starting wakeFromNib")

	}

	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		Util.logMessage("animated \(animated)")

	}

}
