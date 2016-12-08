//
//  ContactsTableViewCell.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/3/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var department: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var number: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(lected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
