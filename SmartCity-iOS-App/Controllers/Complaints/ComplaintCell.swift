//
//  ComplaintCell.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/21/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit

class ComplaintCell: UITableViewCell {

    
    @IBOutlet weak var ref: UILabel!
    @IBOutlet weak var date: UILabel!    
    
    @IBOutlet weak var subCategory: UILabel!
    
    var complaint: ComplaintDTO?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
