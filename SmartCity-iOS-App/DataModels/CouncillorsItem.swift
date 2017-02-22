//
//  CouncillorsFeedItem.swift
//  SmartCity-iOS-App
//
//  Created by Christian Nhlabano on 2017/02/16.
//  Copyright © 2017 Aubrey Malabie. All rights reserved.
//

import Foundation
import Gloss
import ObjectMapper

class CouncillorsItem: Decodable, Mappable {
    var id: String? = nil
    var surname: String? = nil
    var firstName: String? = nil
    var telephoneHome: String? = nil
    var faxNumber: String? = nil
    var mobile: String? = nil
    var emailAddress: String? = nil
    var wardNo: String? = nil
    var gender: String? = nil
    var party: String? = nil
    var domain: String? = nil
    
    init() { }
    required  init?(json: JSON) {
        self.id = "id" <~~ json
        self.surname = "surname" <~~ json
        self.firstName = "firstName" <~~ json
        self.telephoneHome = "telephoneHome" <~~ json
        self.faxNumber = "faxNumber" <~~ json
        self.mobile = "mobile" <~~ json
        self.emailAddress = "emailAddress" <~~ json
        self.wardNo = "wardNo" <~~ json
        self.gender = "gender" <~~ json
        self.party = "party" <~~ json
        self.domain = "domain" <~~ json
    }
    required  init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        
        self.id <- map["id"]
        self.surname <- map["surname"]
        self.firstName <- map["firstName"]
        self.telephoneHome <- map["telephoneHome"]
        self.faxNumber <- map["faxNumber"]
        self.mobile <- map["mobile"]
        self.emailAddress <- map["emailAddress"]
        self.wardNo <- map["wardNo"]
        self.gender <- map["gender"]
        self.party <- map["party"]
        self.domain <- map["domain"]
    }
}
class CouncillorItems: Decodable, Mappable {
    var councillorsItem: [CouncillorsItem] = [CouncillorsItem]()
    required  init?(json: JSON) {
        self.councillorsItem = ("councillors" <~~ json)!
    }
    required  init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        
        self.councillorsItem <- map["councillorsItems"]
    }
    init() { }
    
}

