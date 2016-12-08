//
//  LandingPageController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 8/29/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit
import UNAlertView

class LandingPageController: UIViewController, FeedListener, DataProtocol {

	@IBOutlet weak var logo: UIImageView!
	@IBOutlet weak var mDate: UILabel!
	@IBOutlet weak var headLine: UILabel!
	@IBOutlet weak var image: UIImageView!

	@IBOutlet weak var btnComplaints: UIBarButtonItem!
	@IBOutlet weak var iconLogin: UIImageView!

	let SEGUE_citizenTabs = "citizenTabsSegue"
	let SEGUE_touristTabs = "touristTabsSegue"
	let SEGUE_login = "loginSegue"
	let SEGUE_complaint = "toComplaintFromLanding"

	let SEGUE_link = "feedLinkSegue"

	let C_ACCOUNTS = 2, T_ALERTS = 0, T_NEWS = 1, T_FAQ = 2, T_CONTACTS = 3,
		C_ALERTS = 0, C_NEWS = 1, C_FAQ = 5, C_CONTACTS = 4

	var screen = 0;
	let isTourist = true
	var isAccountHolder = false;
	var municipality: MunicipalityDTO?
	var profile: ProfileInfoDTO?
	var feedItems: [FeedItem] = [FeedItem]()
    var isLogout = false

	override func viewDidLoad() {
		super.viewDidLoad()

		isAccountHolder = Util.checkProfileSignedIn()
		do {
			municipality = try Util.getMunicipality()
		} catch {
			getMunicipality()
		}
		do {
			profile = try Util.getProfile()
			btnComplaints.enabled = true
		} catch {
			btnComplaints.enabled = false
		}
		headLine.text = ""
		mDate.text = ""
		setupIcons()
		getNewsFeed()

		let logoutRec = UITapGestureRecognizer(target: self, action: #selector(LandingPageController.logout))
		logo.userInteractionEnabled = true
		logo.addGestureRecognizer(logoutRec)

	}

	var timer: NSTimer?
	func setTimer() {
		timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector:
				#selector(LandingPageController.controlPage), userInfo: nil, repeats: true)
	}

	func controlPage() {
		currentIndex = currentIndex + 1
		if currentIndex < feedItems.count {
			loadItem()
		}
		if (currentIndex == feedItems.count) {
			currentIndex = 0
			loadItem()
		}

	}

	@IBAction func refresh(sender: AnyObject) {
		getNewsFeed()
	}
	func getMunicipality() {
		let req = RequestDTO(requestType: RequestDTO.GET_MUNICIPALITY_BY_NAME)
		req.municipalityName = Constants.MUNICIPALITY_NAME
		DataUtil.sendRequest(req, listener: self)
	}

	func onResponseDataReceived(response: ResponseDTO) {
		Util.setMunicipality(response.municipalityList![0])
		municipality = response.municipalityList![0]
		Util.setMunicipality(municipality!)
	}
	func onError(message: String) {
		let d = UNAlertView(title: "Municipality Error", message: "The Municipality is not available at this time. Please try later")
		d.addButton("OK") {
			d.hidden = true
			// exit(0)
		}
		d.show();
	}
	override func viewWillAppear(animated: Bool) {
		Util.logMessage("checking profile")
		do {
			profile = try Util.getProfile()
			iconLogin.image = UIImage(named: "account")
			btnComplaints.enabled = true
		} catch {
			btnComplaints.enabled = false
		}

	}
	func logout() {
		Util.logMessage("...........logging out")

		let d = UNAlertView(title: "Services LogOut", message: "Do you want to log out?");
		d.addButton("Yes", action: {
			Util.removeProfile()
			self.iconLogin.image = UIImage(named: "lock")
			self.profile = nil
			self.btnComplaints.enabled = false
			self.isLogout = true
            self.startSegue()

		})
		d.addButton("No", action: {
			d.hidden = true
		})
		d.show()
	}
	func setupIcons() {

		let loginRec = UITapGestureRecognizer(target: self, action: #selector(LandingPageController.btnLoginTapped))
		iconLogin.userInteractionEnabled = true
		iconLogin.addGestureRecognizer(loginRec)

		let titleRec = UITapGestureRecognizer(target: self, action: #selector(LandingPageController.imageTapped))
		headLine.userInteractionEnabled = true

		headLine.addGestureRecognizer(titleRec)
		let imgRec = UITapGestureRecognizer(target: self, action: #selector(LandingPageController.imageTapped))
		image.userInteractionEnabled = true
		image.addGestureRecognizer(imgRec)

		leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(LandingPageController.handleLeftSwipe))
		leftSwipe!.direction = .Left
		image.addGestureRecognizer(leftSwipe!)

		rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(LandingPageController.handleRightSwipe))
		rightSwipe!.direction = .Right
		image.addGestureRecognizer(rightSwipe!)

	}
	var leftSwipe: UISwipeGestureRecognizer?
	var rightSwipe: UISwipeGestureRecognizer?

	var currentIndex = 0
	func handleLeftSwipe() {
		print("handleLeftSwipe")
		currentIndex = currentIndex + 1
		if currentIndex < feedItems.count {
			loadItem()
		}
		if (currentIndex == feedItems.count) {
			currentIndex = 0
			loadItem()
		}

	}
	func handleRightSwipe() {
		print("handleRightSwipe")
		currentIndex = currentIndex - 1
		if (currentIndex < 0) {
			currentIndex = 0
			loadItem()
		}
		if currentIndex < feedItems.count {
			loadItem()
		}

	}
	func startSegue() {
		if profile != nil {
			performSegueWithIdentifier(SEGUE_citizenTabs, sender: self)
		} else if isLogout{
			performSegueWithIdentifier(SEGUE_login, sender: self)
        } else {
            performSegueWithIdentifier(SEGUE_touristTabs, sender: self)
        }

	}

	@IBAction func btnComplaintTapped(sender: AnyObject) {
		Util.logMessage("iconComplaintTapped")
		performSegueWithIdentifier(SEGUE_complaint, sender: self)
	}

	@IBAction func btnAlertsTapped(sender: AnyObject) {
		print("iconAlertsTapped")
		if profile != nil {
			screen = C_ALERTS
		} else {
			screen = T_ALERTS
		}
		startSegue()

	}
	@IBAction func btnNewsTapped(sender: AnyObject) {
		print("iconNewsTapped")
		if profile != nil {
			screen = C_NEWS
		} else {
			screen = T_NEWS
		}
		startSegue()

	}
	func btnLoginTapped() {
		print("iconLoginTapped")
		if profile == nil {
			performSegueWithIdentifier(SEGUE_login, sender: self)
		} else {
			screen = C_ACCOUNTS
			performSegueWithIdentifier(SEGUE_citizenTabs, sender: self)
		}

	}
	@IBAction func btnContactsTapped(sender: AnyObject) {
		print("iconContactsTapped")
		performSegueWithIdentifier("toContactsFromLanding", sender: self)
	}
	@IBAction func btnFAQTapped(sender: AnyObject) {
		print("iconFAQTapped")
		performSegueWithIdentifier("faqSegue", sender: self)
	}

	func imageTapped()
	{
		print("imageTapped")
		performSegueWithIdentifier(SEGUE_link, sender: self);
	}

	func getNewsFeed() {
		RSSUtil.getNewsFeed(self);
	}
	func getAlertsFeed() {
		RSSUtil.getAlertsFeed(self);
	}

	func handleSwipes(sender: UISwipeGestureRecognizer) {
		if (sender.direction == .Left) {

		}

		if (sender.direction == .Right) {

		}
	}

	let TEST_INDEX = 0

	func onFeedReceived(items: [FeedItem]) {
		Util.logMessage("newsfeed arrived .............")
		feedItems = items
		currentIndex = 0;
		if !items.isEmpty {
			loadItem()
			setTimer()
		}

	}

	func loadItem() {

		headLine.slideInFromLeft()
		headLine.text = feedItems[currentIndex].title
		let item = feedItems[currentIndex]

		if item.thumbnailUrl != nil {
			Util.loadImageFromUrl(item.thumbnailUrl!, view: image)
		} else {
			image.image = UIImage(named: "news_default")
			image.slideInFromLeft()
			self.animateImage()
		}

		mDate.slideInFromLeft()
		mDate.text = item.pubDate

	}
	func animateImage() {
		image!.alpha = 0.1

		UIView.animateWithDuration(2.0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () in
			self.image!.alpha = 1.0;
			},
			completion: { (Bool) in

		})
	}
	enum NSComparisonResult: Int {
		case orderedAscending
		case orderedSame
		case orderedDescending
	}

	// MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

		if segue.identifier == SEGUE_touristTabs {
			let ttabs = segue.destinationViewController as! TouristBarController
			ttabs.setPageToStart(screen)
		}
		if segue.identifier == SEGUE_citizenTabs {
			let ttabs = segue.destinationViewController as! CitizenTabController
			ttabs.setPageToStart(screen)
		}

		if segue.identifier == SEGUE_link {
			let ttabs = segue.destinationViewController as! FeedLinkController
			ttabs.urlString = feedItems[currentIndex].link
		}

	}

}
