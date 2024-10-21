//
//  EditProfileViewModel.swift
//  TravelPro
//
//  Created by VIJAY M on 29/04/23.
//

import Foundation
import Alamofire
import UIKit

class EditProfilePageViewModel {
    typealias Result<T: Codable> = Swift.Result<T, ServiceManger.Error>
    typealias Completion<T: Codable> = (Result<T>) -> Void
    static func EditProfileAPIRequest(with param: EditProfileParam!, controller : UIViewController, boolLoaderEnable : Bool, completion: @escaping Completion<EditProfileResponseDetails>) {
        ServiceManger.postJSONRequest(ServerOnboardEndpoint.edit_profile_api, parameters: param, controller: controller, boolLoaderEnable: boolLoaderEnable, headerEnable: true, methodType: .post, jsonType: JSONParameterEncoder.default) { responseData in
            completion(responseData)
        }
    }
}


struct EditProfileParam: Codable {
    let firstName: String
    let lastName: String
    let dob: String
    let email: String
    let mobileNo: String
    let profileImage: String
    let resident : String
    let gender : String
    let countryCode : String
}
