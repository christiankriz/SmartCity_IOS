//
//  DataUtil.swift
//  SmartCity
//
//  Created by Aubrey Malabie on 4/23/16.
//  Copyright © 2016 Aubrey Malabie. All rights reserved.
//

import Foundation
import Gloss
import ObjectMapper
import Alamofire

class DataUtil {

	static var resp: ResponseDTO?
	static var err: NSError?
//	 static let url = "http://192.168.1.233:40405/sc/smart"
	static let url = "http://smartcitydev.ocgroup.co.za/sc/smart"

	static var muni: MunicipalityDTO?

	static func sendRequest(req: RequestDTO, listener: DataProtocol) {
		req.zipResponse = false;
		do {
			muni = try Util.getMunicipality()
			req.municipalityID = muni?.municipalityID
		} catch {

		}
		let JSONString = Mapper().toJSONString(req, prettyPrint: true)
		Util.logMessage("\n\nGenerated JSON: \(JSONString!)")

		Alamofire.request(.GET, url, parameters: ["JSON": JSONString!]).responseJSON { response in
			print(response.request) // original URL request
			Util.logMessage("\n\n############## result ##############################\n\n\(response.result.value)")

            if response.response?.statusCode == 200 {
                Util.logMessage("")
            }
			switch response.result {
			case .Success(let x):
				Util.logMessage("******** Alamofire Response status: \(response.result)") // URL response
				let resp = ResponseDTO(json: x as! JSON)
				Util.logMessage("+++++++ SmartCity Server response, statusCode: \(resp!.statusCode!) message: \(resp?.message)")

				if (resp?.statusCode > 0) {
					Util.logMessage("Server web app related issue: \(resp?.message)")
					listener.onError(resp!.message!)
					return
				} else {
					switch (req.requestType!) {
					case RequestDTO.SIGN_IN_CITIZEN:
						Util.setProfile((resp?.profileInfoList![0])!)
						Util.writeToFile(resp!.getJSON())
						break
					case RequestDTO.SIGN_IN_USER:
						Util.writeToFile(resp!.getJSON())
						break
					case RequestDTO.GET_MUNICIPALITY_BY_NAME:
						Util.setMunicipality((resp?.municipalityList![0])!)
						break

					default:
						Util.logMessage("Not cacheing this response. Cool")
						break
					}
				}

				listener.onResponseDataReceived(resp!)
			case .Failure(let error):

				Util.logMessage("******** Alamofire ERROR status: \(error.localizedDescription)\n\(error.localizedFailureReason)")

				// TODO - parse the error type and set appr messsage
				listener.onError("Server unable to process request")
			}

		}

	}
}

protocol DataProtocol {
	func onResponseDataReceived(response: ResponseDTO)
	func onError(message: String)
}
