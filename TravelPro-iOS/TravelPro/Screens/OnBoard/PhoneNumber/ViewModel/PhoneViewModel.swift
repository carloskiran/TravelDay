//
//  EmailViewModel.swift
//  TravelPro
//
//  Created by Mac-OBS-32 on 25/04/23.
//


import Foundation
import UIKit
import Alamofire
class PhoneViewModel {
    
    /// LoginApiData
    /// - Parameters:
    ///   - email: String
    ///   - password: String
    ///   - success: LoginDetailsResponse
    ///   - failure: String
    ///   - view: UIView
    ///   - enableLoader: Bool
    func getCountryListApi( _ view: UIView,enableLoader:Bool ,onSuccess success: @escaping (CountryModel) -> Void, onFailure failure: @escaping (String) -> Void){

        let params = ["": ""]
        let request = CountryAPIRequest(params)
        if enableLoader {
            Loader.startLoading(view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: CountryModel.self) { responses in
            if enableLoader {
                Loader.stopLoading(view)
            }
            switch responses {
            case .success(let response):
                success(response)
            case .failure(let error):
                failure(error.description)
            }
        }

    }
    
    
    typealias Result<T: Codable> = Swift.Result<T, ServiceManger.Error>
    typealias Completion<T: Codable> = (Result<T>) -> Void
    static func MobileValidationAPIRequest(with param: MobileParam, controller : UIViewController, boolLoaderEnable : Bool, completion: @escaping Completion<EmailCheckModel>) {
        ServiceManger.postJSONRequest(ServerOnboardEndpoint.mobilecheck_api, parameters: param, controller: controller, boolLoaderEnable: boolLoaderEnable, headerEnable: false, methodType: .post, jsonType: JSONParameterEncoder.default) { responseData in
            completion(responseData)
        }
    }
    
    static func RegisterAPIRequest(with param: RegisterParam, controller : UIViewController, boolLoaderEnable : Bool, completion: @escaping Completion<RegisterResponse>) {
        ServiceManger.postJSONRequest(ServerOnboardEndpoint.register_api, parameters: param, controller: controller, boolLoaderEnable: boolLoaderEnable, headerEnable: false, methodType: .post, jsonType: JSONParameterEncoder.default) { responseData in
            completion(responseData)
        }
    }
 
}

struct MobileParam: Codable {
    let mobileNo: String
    let countryCode: String
}
struct RegisterParam :Codable {
    let firstName : String
    let lastName : String
    let mobileNo : String
    let userType : String
    let countryCode : String
    let email : String
    let resident : String
    let verifiedStatus: Bool
}
