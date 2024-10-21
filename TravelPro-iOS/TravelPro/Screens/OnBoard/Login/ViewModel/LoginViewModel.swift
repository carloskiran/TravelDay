//
//  LoginViewModel.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 18/04/23.
//

import Foundation
import UIKit
import Alamofire
class LoginViewModel {
    
    /// LoginApiData
    /// - Parameters:
    ///   - email: String
    ///   - password: String
    ///   - success: LoginDetailsResponse
    ///   - failure: String
    ///   - view: UIView
    ///   - enableLoader: Bool
    func loginApiData(email: String, password: String, _ view: UIView,enableLoader:Bool ,onSuccess success: @escaping (LoginDetailsResponse) -> Void, onFailure failure: @escaping (String) -> Void){

        let params = ["username": email,"password": password]
        let request = LoginAPIRequest(params)
        if enableLoader {
            Loader.startLoading(view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: LoginDetailsResponse.self) { responses in
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
    static func loginAPIRequest(with param: LoginParam, controller : UIViewController, boolLoaderEnable : Bool, completion: @escaping Completion<LoginDetailsResponse>) {
        ServiceManger.postJSONRequest(ServerOnboardEndpoint.login_api, parameters: param, controller: controller, boolLoaderEnable: boolLoaderEnable, headerEnable: false, methodType: .post, jsonType: URLEncodedFormParameterEncoder.default) { responseData in
            completion(responseData)
        }
    }
    
    static func socialLoginAPIRequest(with param: SignupSocialParam, controller : UIViewController, boolLoaderEnable : Bool, completion: @escaping Completion<SocialLoginResponse>) {
        ServiceManger.postJSONRequest(ServerOnboardEndpoint.sociallogin_api, parameters: param, controller: controller, boolLoaderEnable: boolLoaderEnable, headerEnable: false, methodType: .post, jsonType: JSONParameterEncoder.default) { responseData in
            completion(responseData)
        }
    }

}
struct LoginParam: Codable {
    let username: String
    let password: String
}
struct SignupSocialParam : Codable {
    let email, socialId, type, firstName: String
    let lastName, mobileNo: String
}
