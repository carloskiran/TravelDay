//
//  ForgotPasswordViewModel.swift
//  TravelPro
//
//  Created by VIJAY M on 26/04/23.
//

import Foundation
import UIKit


class ForgotPasswordViewModel {
    
    /// ForgotpasswordAPI
    /// - Parameters:
    ///   - userName: String
    ///   - password: String
    ///   - success: LoginDetailsResponse
    ///   - failure: String
    ///   - view: UIView
    ///   - enableLoader: Bool
    func accountValidation(userName: String, _ view: UIView,enableLoader:Bool ,onSuccess success: @escaping (GenerateOTPModel) -> Void, onFailure failure: @escaping (String) -> Void){
        
        var params = ["email": userName]
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: userName)) {
            params = ["mobileNo": userName]
        }
        let request = ForgotPasswordAPIRequest(params)
        if enableLoader {
            Loader.startLoading(view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: GenerateOTPModel.self) { responses in
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
    
    /// OtpvalidationAPI
    func otpValidation(mobileNo: String, mobileOtp: String,email: String, emailOtp: String,otpType:OtpApiType , _ view: UIView,enableLoader:Bool ,onSuccess success: @escaping (ValidateOTPModel) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let params = ["email":email,"emailOtp":emailOtp]
//        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: userName)) {
//            params.updateValue("mobileNo", forKey: userName)
//            params.updateValue("mobileOtp", forKey: otp)
//        } else {
//            params.updateValue("email", forKey: userName)
//            params.updateValue("emailOtp", forKey: otp)
//        }
        let request:TravelTaxDayNetworkRequest?
        switch otpType {
        case .fromSignup:
             request = ValidateSignupOTPAPIRequest(params)
            
        default:
             request = ValidateProfileOTPAPIRequest(params)
        }
        if enableLoader {
            Loader.startLoading(view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request!, responseType: ValidateOTPModel.self) { responses in
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
    
    /// GenerateOTPAPI
    func generateOTP(mobileNo: String,email: String,countryCode: String, _ view: UIView,enableLoader:Bool ,onSuccess success: @escaping (GenerateOTPModel) -> Void, onFailure failure: @escaping (String) -> Void){
        
        
        let params = ["mobileNo": mobileNo, "email":email ,"countryCode" :countryCode ]
//        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: userName)) {
//            params.updateValue("mobileNo", forKey: userName)
//        } else {
//            params.updateValue("email", forKey: userName)
//        }
        let request = GenerateOTPAPIRequest(params)
        if enableLoader {
            Loader.startLoading(view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: GenerateOTPModel.self) { responses in
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
    
    /// GenerateOTPAPI
    func newUserOTPGenerate(mobileNo: String,email: String,countryCode: String, _ view: UIView,enableLoader:Bool ,onSuccess success: @escaping (NewUserOTPModel) -> Void, onFailure failure: @escaping (String) -> Void){
        
        
        let params = ["mobileNo": mobileNo, "email":email ,"countryCode" :countryCode ]

        let request = NewUserOTPAPIRequest(params)
        if enableLoader {
            Loader.startLoading(view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: NewUserOTPModel.self) { responses in
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
