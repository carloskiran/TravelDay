//
//  SignupViewController+GoogleSigninExtension.swift
//  Todra
//
//  Created by Mac-OBS-18 on 26/02/22.
//

import Foundation
import FirebaseCore
import GoogleSignIn
//import FirebaseAuth
import Alamofire

extension LoginViewController  {
    
    func googleAuth() {
        TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "LoginViewController - googleAuth"))

        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
              TravelTaxMixPanelAnalytics(action: .welcome, state: .info, data: MixPanelData(message: "LoginViewController - GIDSignIn \(error.debugDescription)"))
           return
          }
            let idToken = result?.user.userID
            let user1 = result?.user.profile
            let signupParam = SignupSocialParam.init(email: user1?.email ?? "", socialId: idToken ?? "", type: "GOOGLE", firstName:user1?.name ?? "", lastName: user1?.familyName ?? "", mobileNo: "")
            DispatchQueue.main.async {
                self.signupSocialApiCall(param: signupParam, loginType: "GOOGLE")
            }
        }
   
    }
    
     
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
    }
}
