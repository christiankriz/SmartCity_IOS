//
//  ComplaintListController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/21/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit
import UNAlertView

class ComplaintListController: UITableViewController, DataProtocol {

	var profile: ProfileInfoDTO?
	var muni: MunicipalityDTO?
	var complaints = [ComplaintDTO]()
	var currentComplaint: ComplaintDTO?

	override func viewDidLoad() {
		super.viewDidLoad()
		Util.logMessage("starting ....")

		tableView.delegate = self
		tableView.dataSource = self

		do {
			profile = try Util.getProfile()
			muni = try Util.getMunicipality()
			let resp = Util.getData()
			if (resp.statusCode == 0) {
				complaints = resp.complaintList!
				tableView.reloadData()
			}
			// refresh data
			getComplaints()

		} catch {

		}
	}

	func getComplaintStatus() {
		req = RequestDTO(requestType: RequestDTO.GET_COMPLAINT_STATUS)
		req!.municipalityID = muni?.municipalityID
		req!.referenceNumber = currentComplaint?.href

		DataUtil.sendRequest(req!, listener: self)
	}
	var req: RequestDTO?
	func getComplaints() {

		req = RequestDTO(requestType: RequestDTO.SIGN_IN_CITIZEN)
		req!.municipalityID = muni?.municipalityID
		req!.userName = profile?.email
		req!.password = profile?.password

		DataUtil.sendRequest(req!, listener: self)

	}
	func onResponseDataReceived(response: ResponseDTO) {
		if (req?.requestType == RequestDTO.SIGN_IN_CITIZEN) {
			complaints = response.complaintList!
			tableView.reloadData()
		}
		if (req?.requestType == RequestDTO.GET_COMPLAINT_STATUS) {
			Util.logMessage("case details arrived")
			if response.complaintUpdateStatusList != nil {
				popStatus(response.complaintUpdateStatusList![0])
			} else {
				onError("Complaint status not available")
			}

		}

	}
	func popStatus(status: ComplaintUpdateStatusDTO) {

		let message = "\(currentComplaint!.category!) - \(currentComplaint!.subCategory!) \nStatus: \(status.status!)\n\n\(status.remarks!)\n\nUpdated: \(status.stringDate!)"
		let d = UNAlertView(title: "Complaint Status", message: message)
		d.addButton("OK", action: {
			d.hidden = true
		})
		d.show()
	}

	func onError(message: String) {
		let d = UNAlertView(title: "Server Error", message: message)
		d.addButton("OK", action: {
			d.hidden = true
		})
		d.show()
	}
	// MARK: - Table view data source
	var currentIndex: Int = 0
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		currentComplaint = complaints[(indexPath as NSIndexPath).row]
		currentIndex = (indexPath as NSIndexPath).row
		getComplaintStatus()
	}
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return complaints.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ComplaintCell

		let c = complaints[(indexPath as NSIndexPath).row]
		cell.complaint = c;
		cell.ref.text = "Reference: \(c.referenceNumber!)"
		cell.subCategory.text = "\(c.category!) - \(c.subCategory!)"

		cell.date.text = c.stringDate!
		return cell
	}

}
