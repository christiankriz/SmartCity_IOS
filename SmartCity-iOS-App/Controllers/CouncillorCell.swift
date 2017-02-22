//
//  CouncillorCell.swift
//  SmartCity-iOS-App
//
//  Created by Christian Nhlabano on 2017/02/17.
//  Copyright © 2017 Aubrey Malabie. All rights reserved.
//

import UIKit
import Foundation

class CouncillorCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ward: UILabel!
    @IBOutlet weak var party: UILabel!
    @IBOutlet weak var partyImage: UIImageView!
    
    var councillorItem: CouncillorsItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    internal func setCouncillorItem(councillorItem: CouncillorsItem) {
        Util.logMessage("CouncillorItemCell: \(councillorItem.firstName!) \n \(councillorItem.surname!)")
        name.text = councillorItem.firstName! + " " + councillorItem.surname!
        ward.text = "Ward No: " + councillorItem.wardNo!
        party.text = councillorItem.party
        let partyId = councillorItem.party
        let anc = "ANC"
        let da = "DA"
        if partyId == da{
            partyImage.image = UIImage(named: "da")
        }else if partyId == anc{
            partyImage.image = UIImage(named: "anc")
        }
        self.councillorItem = councillorItem
    }
    
    
}
