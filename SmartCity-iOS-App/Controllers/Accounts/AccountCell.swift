//
//  AccountCell.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/2/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import Foundation
import UIKit

class AccountCell: UITableViewCell {

	@IBOutlet weak var icon: UIView!

    @IBOutlet weak var number: UILabel!
	@IBOutlet weak var accountNumber: UILabel!
	@IBOutlet weak var accountName: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()

	}
	override func setSelected(selected: Bool, animated: Bool) {

	}

}
