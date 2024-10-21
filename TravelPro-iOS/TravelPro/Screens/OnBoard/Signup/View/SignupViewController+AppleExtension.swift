//
//  LoginViewController+AppleExtension.swift
//  Todra
//
//  Created by Mac-OBS-18 on 18/02/22.
//

import Foundation
import AuthenticationServices
@available(iOS 13.0, *)
extension SignUpViewController: ASAuthorizationControllerDelegate {

     // ASAuthorizationControllerDelegate function for authorization failed
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

        print(error.localizedDescription)

    }

       // ASAuthorizationControllerDelegate function for successful authorization

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let appleUniqueId = appleIDCredential.user
            var appleUserFirstName = appleIDCredential.fullName?.givenName
            var appleUserLastName = appleIDCredential.fullName?.familyName
            var appleUserEmail = appleIDCredential.email
           // var appleUserMobile = appleIDCredential.mobile
            if appleUserEmail == TextConstant.sharedInstance.emptyText || appleUserEmail == nil {
            let result   =   CoreDataManager.sharedInstance.fetchAllEntities(entityName: TextConstant.CoreDataKey.kAppLogDetails)
                if result != nil {
                    for initalValue in result!{
                        if let UserEmail =  initalValue.value(forKey: "appleEmail") as? String   {
                            if UserEmail != ""{
                            appleUserEmail = UserEmail
                            }
                        }
                        if let FirstName =  initalValue.value(forKey: "appleFname") as? String {
                            if FirstName != ""{
                            appleUserFirstName = FirstName
                            }
                        }
                        if let LastName =  initalValue.value(forKey: "appleLname") as? String{
                            if LastName != ""{
                            appleUserLastName = LastName
                            }
                        }
                    }
                }
            } else {
                self.appleDetailsSaveToCoreData(appleUniqueId: appleUniqueId, appleFname: appleUserFirstName ?? TextConstant.sharedInstance.SEmpty, appleLname: appleUserLastName ?? TextConstant.sharedInstance.SEmpty, appleEmail: appleUserEmail?.trimmingCharacters(in: .whitespacesAndNewlines) ?? TextConstant.sharedInstance.emptyText)
            }
            utilsClass.sharedInstance.DebugPrint(strLog: appleUniqueId)
            utilsClass.sharedInstance.DebugPrint(strLog: appleUserLastName ?? "")
            utilsClass.sharedInstance.DebugPrint(strLog: appleUserEmail ?? "")
            utilsClass.sharedInstance.DebugPrint(strLog: appleUniqueId)
            utilsClass.sharedInstance.DebugPrint(strLog: appleUserEmail ?? TextConstant.sharedInstance.emptyText)
            let signupParam = SignupSocialParam.init(email: appleUserEmail ?? TextConstant.sharedInstance.emptyText, socialId: appleUniqueId, type: "APPLE", firstName: appleUserFirstName ?? TextConstant.sharedInstance.emptyText, lastName: appleUserLastName ?? TextConstant.sharedInstance.emptyText, mobileNo: "")
            DispatchQueue.main.async {
                self.signupSocialApiCall(param: signupParam, loginType: "APPLE")
            }
            
        }
        else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            
            let appleUsername = passwordCredential.user
            let applePassword = passwordCredential.password
            utilsClass.sharedInstance.DebugPrint(strLog: appleUsername)
            utilsClass.sharedInstance.DebugPrint(strLog: applePassword)
            //Write your code
        }
        
    }
    func appleDetailsSaveToCoreData(appleUniqueId : String , appleFname : String,appleLname: String,appleEmail :String) {
          CoreDataManager.sharedInstance.deleteAllData(entity: TextConstant.CoreDataKey.kAppLogDetails)
        let albumDetails = CoreDataManager.sharedInstance.getEntityManagedObject(entityName: TextConstant.CoreDataKey.kAppLogDetails)
        do{
            albumDetails.setValue(appleUniqueId, forKey: "appleId")
            albumDetails.setValue(appleFname, forKey: "appleFname")
            albumDetails.setValue(appleLname, forKey: "appleLname")
            albumDetails.setValue(appleEmail, forKey: "appleEmail")
            _ = CoreDataManager.sharedInstance.saveOrUpdateEntity()
         }
        
    }
   

}

@available(iOS 13.0, *)
extension SignUpViewController: ASAuthorizationControllerPresentationContextProviding {

    //For present window

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {

        return self.view.window!

    }

}

