//
//  CreatePasswordViewModel.swift
//  TravelPro
//
//  Created by VIJAY M on 26/04/23.
//

import Foundation
import UIKit

class CreatePasswordViewModel {
    
    /// LoginApiData
    /// - Parameters:
    ///   - email: String
    ///   - password: String
    ///   - success: LoginDetailsResponse
    ///   - failure: String
    ///   - view: UIView
    ///   - enableLoader: Bool
    func CreatePasswordApi(email: String, password: String, confirmPassword: String, _ view: UIView,enableLoader:Bool ,onSuccess success: @escaping (CreatePasswordResponse) -> Void, onFailure failure: @escaping (String) -> Void){

        let params = ["email": email, "password": password, "confirmPassword": confirmPassword]
        let request = CreatePasswordAPIRequest(params)
        if enableLoader {
            Loader.startLoading(view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: CreatePasswordResponse.self) { responses in
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

}
