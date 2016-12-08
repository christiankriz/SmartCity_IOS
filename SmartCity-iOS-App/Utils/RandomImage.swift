//
//  RandomImage.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/1/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit
import Foundation
class RandomImage {

	static func getImage() -> UIImage {
		let lower: UInt32 = 0
		let upper: UInt32 = 7
		let randomNumber = arc4random_uniform(upper - lower) + lower
		print("Random Index Generated: \(randomNumber)")

		var image: UIImage?

		switch randomNumber {
		case 0:
			image = UIImage(named: "back13")
		case 1:
			image = UIImage(named: "back2")

		case 2:
			image = UIImage(named: "back3")
		case 3:
			image = UIImage(named: "back6")
		case 4:
			image = UIImage(named: "back8")
		case 5:
			image = UIImage(named: "back5")

		case 6:
			image = UIImage(named: "back13")
		case 7:
			image = UIImage(named: "back10")

		default:
			image = UIImage(named: "back10")
		}

		return image!
	}
}
