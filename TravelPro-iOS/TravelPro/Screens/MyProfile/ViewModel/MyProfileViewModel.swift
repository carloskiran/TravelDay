//
//  MyProfileViewModel.swift
//  TravelPro
//
//  Created by Mac-OBS-32 on 28/04/23.
//

import Foundation
import UIKit
import Alamofire
class MyProfileViewModel {
    typealias Result<T: Codable> = Swift.Result<T, ServiceManger.Error>
    typealias Completion<T: Codable> = (Result<T>) -> Void
    func ViewProfile(userName: String, _ view: UIView,enableLoader:Bool ,onSuccess success: @escaping (ViewProfileModel) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let params = ["": ""]
        
        let request = ViewProfileAPIRequest(params)
        if enableLoader {
            Loader.startLoading(view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: ViewProfileModel.self) { responses in
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
    
    static func getForceUpdateDetails(with param: forceUpdateParam, controller : UIViewController, boolLoaderEnable : Bool, completion: @escaping Completion<ViewProfileModel>) {
        ServiceManger.postJSONRequest(ServerOnboardEndpoint.viewprofile_api, parameters: param, controller: controller, boolLoaderEnable: boolLoaderEnable, headerEnable: true, methodType: .get, jsonType: URLEncodedFormParameterEncoder.default) { responseData in
            completion(responseData)
        }
    }
}

struct forceUpdateParam : Codable {
    let userId : String?
}

