//
//  ComplaintBuilderController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/2/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//
import UIKit
import CoreLocation
import UNAlertView
import DropDown
import Toast_Swift

class ComplaintBuilderController: UIViewController, CLLocationManagerDelegate,
DataProtocol, UITextFieldDelegate {
    
    @IBOutlet weak var previousLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var desc: UITextField!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var newComplaint: UILabel!
    
    @IBOutlet weak var busy: UIActivityIndicatorView!
    @IBOutlet weak var cameraIcon: UIImageView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    var locationManager: CLLocationManager?
    var location: CLLocation?
    var locationStatus: String?
    var response: ResponseDTO?
    
    var categoryDropDown: DropDown = DropDown()
    
    var subCategoryDropDown: DropDown = DropDown()
    
    var subCat: String = ""
    var cat: String = ""
    var profile: ProfileInfoDTO?
    var muni: MunicipalityDTO?
    let SEGUE_complaints = "toComplaintsSegue"
    
    let SEGUE_camera = "toCameraFromComplaint"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSend.hidden = true
        busy.hidden = true
        desc.delegate = self
        desc.hidden = true
        descLabel.hidden = true
        do {
            muni = try Util.getMunicipality()
            
        } catch {
            Util.logMessage("Something wrong in George ...")
        }
        
        do {
            profile = try Util.getProfile()
            response = Util.getData()
            setupCatgeryDropDown()
            countLabel.text = "\(response!.complaintList!.count)"
        } catch {
            countLabel.text = "0"
            btnStart.hidden = true
        }
        
        getLocation()
        let imageRec = UITapGestureRecognizer(target: self, action: #selector(ComplaintBuilderController.startCamera))
        // cameraIcon.userInteractionEnabled = true
        cameraIcon.addGestureRecognizer(imageRec)
        cameraIcon.alpha = 0
        
        let prevRec = UITapGestureRecognizer(target: self, action: #selector(ComplaintBuilderController.goToComplaintList))
        previousLabel.userInteractionEnabled = true
        previousLabel.addGestureRecognizer(prevRec)
        
        let prevRec2 = UITapGestureRecognizer(target: self, action: #selector(ComplaintBuilderController.goToComplaintList))
        countLabel.userInteractionEnabled = true
        countLabel.addGestureRecognizer(prevRec2)
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        desc.resignFirstResponder()
        return true
    }
    func goToComplaintList() {
        let count = response?.complaintList?.count
        if (count > 0) {
            performSegueWithIdentifier(SEGUE_complaints, sender: self)
        }
    }
    
    @IBAction func lodgeComplaint(sender: AnyObject) {
        
        confirmDialog()
    }
    @IBAction func startComplaint(sender: AnyObject) {
        DropDown.appearance().textColor = UIColor.blackColor()
        DropDown.appearance().textFont = UIFont.systemFontOfSize(18)
        DropDown.appearance().backgroundColor = UIColor.whiteColor()
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGrayColor()
        DropDown.appearance().cellHeight = 50
        
        categoryDropDown.anchorView = btnStart
        categoryDropDown.show()
    }
    @IBAction func sendTapped(sender: AnyObject) {
        confirmDialog()
    }
    func sendComplaint() {
        Util.logMessage("sending complaint: \(cat) \(subCat)")
        textFieldShouldReturn(desc)
        btnSend.hidden = true
        let c = ComplaintDTO()
        let p = ProfileInfoDTO()
        p.email = profile?.email
        p.password = profile?.password
        p.CustomerID = profile?.CustomerID
        c.profileInfo = p
        
        c.category = cat
        c.subCategory = subCat
        c.description = desc.text
        
        let req = RequestDTO(requestType: RequestDTO.ADD_COMPLAINT)
        req.complaint = c
        req.municipalityID = muni?.municipalityID
        
        busy.hidden = false
        busy.startAnimating()
        DataUtil.sendRequest(req, listener: self)
        
    }
    
    var complaint: ComplaintDTO?
    
    func onResponseDataReceived(response: ResponseDTO) {
        busy.stopAnimating()
        busy.hidden = true
        complaint = response.complaintList![0]
        showResponse((complaint?.complaintUpdateStatusList![0])!)
        // cameraIcon.alpha = 1
        // addPicturesDialog()
    }
    func showResponse(status: ComplaintUpdateStatusDTO) {
        let d = UNAlertView(title: "Complaint Status", message: status.remarks!)
        d.addButton("OK", action: {
            d.hidden = true
            self.performSegueWithIdentifier(self.SEGUE_complaints, sender: self)
        })
        d.show()
    }
    
    func onError(message: String) {
        Util.logMessage(message)
        busy.stopAnimating()
        busy.hidden = true
        // todo - cache complaint for later
        let d = UNAlertView(title: "Services Message",
                            message: "Unable to lodge complaint at this time. Please try again later. Thanks!")
        d.addButton("OK", action: {
            d.hidden = true
        })
        d.show()
    }
    
    func setupCatgeryDropDown() {
        var cats = [String]()
        
        for cat in (response?.complaintCategoryList)! {
            cats.append(cat.complaintCategoryName!)
        }
        categoryDropDown.dataSource = cats
        categoryDropDown.width = 200
        categoryDropDown.selectionAction = { (index: Int, item: String) in
            print("Selected cat: \(item) at index: \(index)")
            self.cat = item
            self.newComplaint.text = "\(self.cat)"
            self.newComplaint.hidden = false
            self.setupSubCategoryDropDown((self.response?.complaintCategoryList![index])!)
            
        }
        DropDown.appearance().textColor = UIColor.blueColor()
        DropDown.appearance().textFont = UIFont.systemFontOfSize(18)
        DropDown.appearance().backgroundColor = UIColor.whiteColor()
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGrayColor()
        DropDown.appearance().cellHeight = 50
        
        categoryDropDown.anchorView = desc
        
    }
    func setupSubCategoryDropDown(cat: ComplaintCategoryDTO) {
        var subcats = [String]()
        for subCat in cat.complaintTypeList! {
            subcats.append(subCat.complaintTypeName!)
        }
        subCategoryDropDown.dataSource = subcats
        subCategoryDropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.desc.text = ""
            self.subCat = item
            self.newComplaint.text = "\(self.cat), \(self.subCat)"
            
            self.desc.hidden = false
            self.descLabel.hidden = false
            self.btnSend.hidden = false
            self.doToast("Please enter a description if appropriate")
        }
        
        DropDown.appearance().textColor = UIColor.blueColor()
        DropDown.appearance().textFont = UIFont.systemFontOfSize(18)
        DropDown.appearance().backgroundColor = UIColor.whiteColor()
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGrayColor()
        DropDown.appearance().cellHeight = 50
        
        subCategoryDropDown.anchorView = desc
        subCategoryDropDown.width = 300
        subCategoryDropDown.show()
    }
    
    func confirmDialog() {
        let d = UNAlertView(title: "Lodge Complaint", message: "Please confirm the complaint: \(cat), \(subCat)")
        d.addButton("Yes", action: {
            d.hidden = true
            self.sendComplaint()
        })
        d.addButton("No", action: {
            d.hidden = true
        })
        d.show()
    }
    func addPicturesDialog() {
        let d = UNAlertView(title: "Add Complaint Pictures", message: "Complaint has been sent. Do you want to add pictures to your complaint?")
        d.addButton("Yes", action: {
            d.hidden = true
            self.startCamera()
        })
        d.addButton("No", action: {
            d.hidden = true
        })
        d.show()
    }
    
    func startCamera() {
        performSegueWithIdentifier(SEGUE_camera, sender: self)
    }
    
    func getLocation() {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestAlwaysAuthorization()
        // locationManager!.startUpdatingLocation()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_camera {
            let linkController = segue.destinationViewController as! ComplaintCameraController
            linkController.complaint = complaint
        }
        if segue.identifier == SEGUE_complaints {
            let linkController = segue.destinationViewController as! CitizenTabController
            linkController.page = 3
        }
    }
    
    // Location Manager Delegate stuff
    // If failed
    func locationManager(manager: CLLocationManager, didFailWithError error: Error) {
        Util.logMessage("did fail with error")
        locationManager!.stopUpdatingLocation()
        
    }
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        Util.logMessage("location updated: \(newLocation)")
        location = newLocation
        locationManager!.stopUpdatingLocation()
        
    }
    
    // authorization status
    func locationManager(manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        Util.logMessage("didChangeAuthorizationStatus: \(status)")
        var shouldIAllow = false
        
        switch status {
        case CLAuthorizationStatus.Restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.Denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.NotDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager!.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
            
        }
    }
    func doToast(message: String) {
        // create a new style
        var style = ToastStyle()
        
        style.messageColor = UIColor.yellowColor()
        
        // or perhaps you want to use this style for all toasts going forward?
        // just set the shared style and there's no need to provide the style again
        ToastManager.shared.style = style
        
        // toggle "tap to dismiss" functionality
        ToastManager.shared.tapToDismissEnabled = true
        
        // toggle queueing behavior
        ToastManager.shared.queueEnabled = true
        // display toast with an activity spinner
        // self.view.makeToastActivity(.Center)
        // present the toast with the new style
        self.navigationController?.view.makeToast(message)
    }
    
}
