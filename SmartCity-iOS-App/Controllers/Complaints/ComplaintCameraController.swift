//
//  ComplaintCameraController.swift
//  SmartCity-003b
//
//  Created by Aubrey Malabie on 9/3/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import UIKit
import UNAlertView
import ObjectMapper
import Toast_Swift
import Cloudinary
import CoreLocation

class ComplaintCameraController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLUploaderDelegate, CLLocationManagerDelegate, DataProtocol {

	var complaint: ComplaintDTO?
	var Cloudinary: CLCloudinary!
	let API_KEY = "397571984789619"
	let API_SECRET = "2RBq1clEHC5X_0eQlNP-K3yhA8U"
	let CLOUD_NAME = "bohatmx"

	@IBOutlet weak var busy: UIActivityIndicatorView!
	@IBOutlet weak var btnUpload: UIButton!
	@IBOutlet weak var picture: UIImageView!
	var cloudinary_url = ""
	var mImage: UIImage?
	var locationManager: CLLocationManager?
	var location: CLLocation?
	var muni: MunicipalityDTO?

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Complaint Photos"
		btnUpload.hidden = true
		busy.hidden = true
		do {
			muni = try Util.getMunicipality()
		} catch {
			Util.logMessage("Muni not found - trouble in George")
			exit(0)
		}
		cloudinary_url = "cloudinary://\(API_KEY):\(API_SECRET)@\(CLOUD_NAME)"
		Cloudinary = CLCloudinary(url: cloudinary_url)
		getLocation()
		startCamera()
	}

	func goBack() {
		self.navigationController?.popViewControllerAnimated(true)
	}
	@IBAction func uploadPicture(sender: AnyObject) {
		Util.logMessage(".... start photo upload")
		doToast("Photo uploading ...........")
		busy.hidden = false
		busy.startAnimating()
		self.btnUpload.hidden = true

		let xImage = resizeImage(mImage!, newWidth: 1024)

		let uploader: CLUploader = CLUploader(Cloudinary, delegate: self)
		uploader.upload(UIImageJPEGRepresentation(xImage, 0.8), options: ["format": "jpg"], withCompletion: { (res: [NSObject: AnyObject]!, errorResult: String!, code: Int, context: AnyObject!) -> Void in

			self.busy.stopAnimating()
			self.busy.hidden = true
			if code == 200 {
				let dict = res as? Dictionary<String, AnyObject>
				let url = dict!["url"]! as! String
				let secure_url = dict!["secure_url"]! as! String
				let bytes = dict!["bytes"]! as! Int
				let height = dict!["height"]! as! Int
				let width = dict!["width"]! as! Int

				Util.logMessage("the fucking url: \(url) secure: \(secure_url) bytes:\(bytes) height: \(height) width: \(width)")
				self.doToast("Photo has been uploaded")
				self.uploadPhotoMetadata(url, secureUrl: secure_url, bytes: bytes, height: height, width: width)

			}

			}, andProgress: { (p1: Int, p2: Int, p3: Int, p4: AnyObject!) -> Void in
			Util.logMessage("Downloaded:  bytes:\(p2) of image size:\(p3)")
		})

	}
	func uploadPhotoMetadata(url: String, secureUrl: String,
		bytes: Int, height: Int, width: Int) {

			let request = RequestDTO(requestType: RequestDTO.ADD_PHOTO)
			request.municipalityID = muni!.municipalityID

			let ci = ComplaintImageDTO()
			ci.bytes = bytes
			ci.url = url
			ci.secureUrl = secureUrl
			ci.dateTaken = currentTimeMillis()
			ci.municipalityID = muni?.municipalityID
			ci.height = height
			ci.width = width
			ci.activeFlag = true
			if location != nil {
				ci.latitude = location?.coordinate.latitude
				ci.longitude = location?.coordinate.longitude
			}
			if complaint != nil {
				ci.referenceNumber = complaint?.referenceNumber
			} else {
				ci.referenceNumber = "NO REFERENCE APPLICABLE"
			}

			let photoDTO = PhotoUploadDTO()
			photoDTO.municipalityID = muni?.municipalityID
			photoDTO.complaintImage = ci
			request.photoUpload = photoDTO

			DataUtil.sendRequest(request, listener: self)

	}
	func onResponseDataReceived(response: ResponseDTO) {
		self.doToast("Photo has been uploaded")
	}
	func onError(message: String) {
		let d = UNAlertView(title: "Services Error", message: message)
		d.addButton("OK", action: {
			d.hidden = true
		})
		d.show()
	}

	func currentTimeMillis() -> Int64 {
		let nowDouble = NSDate().timeIntervalSince1970
		return Int64(nowDouble * 1000)
	}
	@IBAction func takeNewPicture(sender: AnyObject) {
		startCamera()
	}
	func startCamera() {
		Util.logMessage("starting the cam ....")
		let d = UNAlertView(title: "Complaint Picture", message: "Add picture to complaint")
		d.addButton("Photos", action: {
			self.openPhotoLibrary()
		})
		d.addButton("Camera", action: {
			if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
				let imagePicker = UIImagePickerController()
				imagePicker.delegate = self
				imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
				imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true, completion: nil)
			}

		})
		d.addButton("Cancel", action: {
			d.hidden = true
		})
		d.show()

	}
	func openPhotoLibrary() {
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
			imagePicker.allowsEditing = true
			self.presentViewController(imagePicker, animated: true, completion: nil)
		}
	}
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject: AnyObject]!) {
		Util.logMessage("didFinishPickingImage .....")
		mImage = image
		picture.image = image
		savePicture(image)
		btnUpload.hidden = false

		self.dismissViewControllerAnimated(true, completion: nil)	}
	func savePicture(image: UIImage) {
		let imageData = UIImageJPEGRepresentation(image, 0.6)
		let compressedJPGImage = UIImage(data: imageData!)
		UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
		Util.logMessage("image saved........ ")

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

	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
	}
	func getLocation() {
		locationManager = CLLocationManager()
		locationManager!.delegate = self
		locationManager!.desiredAccuracy = kCLLocationAccuracyBest
		locationManager!.requestAlwaysAuthorization()
	}
	// Location Manager Delegate stuff
	func locationManager(manager: CLLocationManager, didFailWithError error: Error) {
		Util.logMessage("did fail with error")
		locationManager!.stopUpdatingLocation()

	}
	func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
		Util.logMessage("location determined: \(newLocation)")
		location = newLocation
		locationManager?.stopUpdatingLocation()
		Util.logMessage("location updates stopped")
	}

	// authorization status
	func locationManager(manager: CLLocationManager,
		didChangeAuthorization status: CLAuthorizationStatus) {
			Util.logMessage("didChangeAuthorizationStatus: \(status)")
			var shouldIAllow = false
        var locationStatus = ""

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
				Util.logMessage("Location to Allowed")
				// Start location services
				locationManager!.startUpdatingLocation()
			} else {
				Util.logMessage("Denied access: \(locationStatus)")

			}
	}
	func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {

		let scale = newWidth / image.size.width
		let newHeight = image.size.height * scale
		UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
		image.drawInRect(CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		Util.logMessage("old width: \(image.size.width) new width: \(newImage.size.width)")
		return newImage!
	}

	var locationStatus: String?

}
