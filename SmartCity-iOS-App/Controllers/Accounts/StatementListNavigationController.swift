//
//  StatementListNavigationController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/13/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit

class StatementListNavigationController: UINavigationController {

	var account: AccountDTO?

	override func viewDidLoad() {
		super.viewDidLoad()

		let vc = viewControllers[0] as! StatementListController
		vc.account = account
	}

}
