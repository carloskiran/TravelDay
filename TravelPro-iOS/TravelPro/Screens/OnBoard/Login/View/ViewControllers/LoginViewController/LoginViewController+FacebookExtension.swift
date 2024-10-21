//
//  SignupViewController+Facebook.swift
//  Todra
//
//  Created by Mac-OBS-18 on 26/02/22.
//

import Foundation
import FBSDKLoginKit

extension LoginViewController {
    
    /// Our custom functions
    func handleFacebookAuthentication() {
        TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "LoginViewController - handleFacebookAuthentication"))

        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
        let fbLoginManager = LoginManager()
        fbLoginManager.logOut()
        let cookies = HTTPCookieStorage.shared
        let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
        for cookie in facebookCookies! {
            cookies.deleteCookie(cookie )
        }
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "LoginViewController - handleFacebookAuthenticationlogIn error \(error.debugDescription)"))
                return
            }
            guard let token = AccessToken.current else {
                print("Failed to get access token")
                TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "LoginViewController - handleFacebookAuthentication Failed to get access token"))
                return
            }
            print("AppID\(token.appID)")
            let request = GraphRequest(
                graphPath: "/me",
                parameters: [
                    "fields": "id,name,email,first_name,last_name"
                ],
                httpMethod: HTTPMethod(rawValue: "GET"))
            request.start() { connection, result, error in
                if let dataValues = result as? NSDictionary {
                    self.faceBookLoginConfigurations(dataValues: dataValues)
                }
                
            }
            
        }
    }
    
    func faceBookLoginConfigurations(dataValues: NSDictionary) {
        if let email = dataValues.object(forKey: "email") as? String {
            let first_name = dataValues.object(forKey: "first_name") as? String
            let last_name = dataValues.object(forKey: "last_name") as? String
            let idValue = dataValues.object(forKey: "id") as? String
            let signupParam = SignupSocialParam.init(email: email , socialId: idValue ?? "", type: "FACEBOOK", firstName:first_name ?? "", lastName: last_name ?? "", mobileNo: "")
            DispatchQueue.main.async {
                self.signupSocialApiCall(param: signupParam, loginType: "GOOGLE")
            }
        } else {
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "Traveltaxday", subTitle: TextConstant.sharedInstance.emptyText, body: "Without Email we cannot Accept", image: UIImage(named: "Notfication1") ?? nil,theme: .default)
            
        }
    }
}
