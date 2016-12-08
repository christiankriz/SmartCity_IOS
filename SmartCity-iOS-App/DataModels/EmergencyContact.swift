//
//  EmergencyContact.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/3/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import Foundation

class EmergencyContact {
	var number: String?
	var name: String?
	var department: String?

	init (department: String, name: String, number: String) {
		self.department = department
		self.name = name
		self.number = number
	}

	static func createList() -> [EmergencyContact] {
		var list = [EmergencyContact]()
		let em1 = EmergencyContact(department: "Fire Department and Metro Police", name: "National Flying Squad", number: "10111")
		list.append(em1)

		let em2 = EmergencyContact(department: "Fire Department and Metro Police", name: "Report a Crime", number: "086 001 01111")
		list.append(em2)

		let em3 = EmergencyContact(department: "Fire Department and Metro Police", name: "Metro Police", number: "031 361 0000")
		list.append(em3)

		let em4 = EmergencyContact(department: "Water and Traffic", name: "Water and Traffic Hotline", number: "080 131 3013")
		list.append(em4)
		let em5 = EmergencyContact(department: "Water and Traffic", name: "Water and Traffic Hotline", number: "080 131 3111")
		list.append(em5)
		let em6 = EmergencyContact(department: "Ambulance", name: "General", number: "10177")
		list.append(em6)
		let em7 = EmergencyContact(department: "Ambulance", name: "City Med", number: "031 309 1404")
		list.append(em7)
		let em8 = EmergencyContact(department: "Ambulance", name: "City Med", number: "031 309 1778")
		list.append(em8)

		let em9 = EmergencyContact(department: "Ambulance", name: "SA Red Cross", number: "031 337 6552")
		list.append(em9)

		return list
	}
}
