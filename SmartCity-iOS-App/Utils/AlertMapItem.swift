//
//  AlertMapItem.swift
//  SmartCity003a
//
//  Created by Aubrey Malabie on 5/8/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import Foundation
import MapKit

class AlertMapItem: NSObject, MKAnnotation {
	let desc: String
	let date: String
	let coordinate: CLLocationCoordinate2D

	init(title: String, date: String, coordinate: CLLocationCoordinate2D) {
		self.desc = title
		self.date = date
		self.coordinate = coordinate

		super.init()
	}

}
