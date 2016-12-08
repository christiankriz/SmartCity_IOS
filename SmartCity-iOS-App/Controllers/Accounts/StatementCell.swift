//
//  StatementCell.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/13/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit

class StatementCell: UITableViewCell {

    
    @IBOutlet weak var fileName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(ed: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
