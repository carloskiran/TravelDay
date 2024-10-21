//
//  EmailViewModel.swift
//  TravelPro
//
//  Created by Mac-OBS-32 on 25/04/23.
//


import Foundation
import UIKit
import Alamofire
class EmailViewModel {
    
    /// LoginApiData
    /// - Parameters:
    ///   - email: String
    ///   - password: String
    ///   - success: LoginDetailsResponse
    ///   - failure: String
    ///   - view: UIView
    ///   - enableLoader: Bool
    typealias Result<T: Codable> = Swift.Result<T, ServiceManger.Error>
    typealias Completion<T: Codable> = (Result<T>) -> Void
    static func EmailValidationAPIRequest(with param: EmailValidationParam, controller : UIViewController, boolLoaderEnable : Bool, completion: @escaping Completion<EmailCheckModel>) {
        ServiceManger.postJSONRequest(ServerOnboardEndpoint.emailcheck_api, parameters: param, controller: controller, boolLoaderEnable: boolLoaderEnable, headerEnable: false, methodType: .post, jsonType: JSONParameterEncoder.default) { responseData in
            completion(responseData)
        }
    }
}
struct EmailValidationParam: Codable {
    let email: String
}
