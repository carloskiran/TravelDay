//
//  SignUpViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 04/04/23.
//

import UIKit
import AuthenticationServices
class SignUpViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - IBOutlets
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var firstNameAlertLbl: UILabel!
    @IBOutlet weak var lastNameAlertLbl: UILabel!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var nxtBtn: CustomButton!
    @IBOutlet weak var continueLbl: UILabel!
    
    let strCharacters = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    var registerAPIToken = updateToken()
    // MARK: - View life cycle
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        TravelTaxMixPanelAnalytics(action: .signup, state: .info, data: MixPanelData(message: "SignUpViewController - viewDidLoad"))

        firstNameTextfield.delegate = self
        lastNameTextfield.delegate = self
        firstNameTextfield.autocapitalizationType = .sentences
        lastNameTextfield.autocapitalizationType = .sentences
        firstNameTextfield.addPlaceholderText(signup_localize.first_name, color: UIColor(named: "grayText"))
        lastNameTextfield.addPlaceholderText(signup_localize.last_name, color: UIColor(named: "grayText"))

        welcomeLbl.text = login_page_controller.hello_signup
        nxtBtn.setTitle(login_page_controller.next, for: .normal)
        continueLbl.text = login_page_controller.continue_with
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        utilsClass.sharedInstance.setTheme()
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func appleButtonAct(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            TravelTaxMixPanelAnalytics(action: .signup, state: .info, data: MixPanelData(message: "SignUpViewController - appleButtonAct"))

            // self.appleButton.isUserInteractionEnabled = false
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
           // self.appleButton.isUserInteractionEnabled = true
        }
        
    }
    @IBAction func facebookButtonAct(_ sender: UIButton) {
        self.handleFacebookAuthentication()
    }
    @IBAction func googleButtonAct(_ sender: UIButton) {
        self.googleAuth()
    }
    func signupSocialApiCall(param : SignupSocialParam , loginType : String) {
        
        LoginViewModel.socialLoginAPIRequest(with: param, controller: self, boolLoaderEnable: true) { Response in
            switch Response {
            case .failure(let error):
                TravelTaxMixPanelAnalytics(action: .signup, state: .info, data: MixPanelData(message: "SignUpViewController - apple loginAPI \(error.description)"))

                utilsClass.sharedInstance.debugprint(message: error)
            case .success(let result):
                if result.status?.status == 200 {
                    TravelTaxMixPanelAnalytics(action: .signup, state: .info, data: MixPanelData(message: "SignUpViewController - apple loginAPI success"))

                    utilsClass.sharedInstance.debugprint(message: result)
                    UserDefaultModule.shared.setUserID(userID: result.entity?.userID ?? "")
                    UserDefaultModule.shared.set("true", forKey: "loginNewAccount")
                    UserDefaultModule.shared.setUseremail(email: param.email)
                    if let userDefaults = UserDefaults(suiteName: "group.com.obs.travelpro") {
                        userDefaults.set(result.entity?.userID ?? "", forKey: "user_id")
                    }
                    UserDefaultModule.shared.setAccessToken(token: result.entity?.accessToken ?? "")
                    if let userDefaults = UserDefaults(suiteName: "group.com.obs.travelpro") {
                        userDefaults.set(result.entity?.accessToken ?? "", forKey: "accessToken")
                    }
                    UserDefaultModule.shared.setEmailID(userID: param.email)
                    UserDefaultModule.shared.setUserName(userID: "\(param.firstName) \(param.lastName)")

                    if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
                        if let userId = UserDefaultModule.shared.getUserID() {
                            self.registerAPIToken.RegisterTokenAPICall(userId: userId, loctionToken: appdelegate.locationToken, isLocationToken: true) { response in
                                print(response)
                                TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "SignUpViewController - loctionToken:\(appdelegate.locationToken) - success response"))

                            } onFailure: { error in
                                print(error)
                                TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "SignUpViewController - loctionToken:\(appdelegate.locationToken) - failure response - \(error)"))
                            }
                            
                            self.registerAPIToken.RegisterTokenAPICall(userId: userId, token: appdelegate.deviceToken) { response in
                                print(response)
                                TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "SignUpViewController - deviceToken:\(appdelegate.deviceToken) - success response"))

                            } onFailure: { error in
                                print(error)
                                TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "SignUpViewController - deviceToken:\(appdelegate.deviceToken) - failure response - \(error)"))
                            }
                        }
                        appdelegate.moveToTabbarViaIndex(intIndex: 3)
                    }
                } else {
                    TravelTaxMixPanelAnalytics(action: .signup, state: .info, data: MixPanelData(message: "SignUpViewController - apple loginAPI not scucess"))

                    utilsClass.sharedInstance.debugprint(message: result)
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: result.status?.message ?? "", image: UIImage(named: "Notification") ?? nil,theme: .default)
                }
            }
        }
        
    }
    @IBAction func nextButtonAction(_ sender: UIButton) {
        var count = 0
        self.firstNameAlertLbl.isHidden = true
        self.lastNameAlertLbl.isHidden = true
        
        if self.firstNameTextfield.text?.count ?? 0 < 2 {
            self.firstNameAlertLbl.isHidden = false
            self.firstNameAlertLbl.text = "First Name should have Minimum 2 Characters"
            count+=1
        }
        
        if self.lastNameTextfield.text?.count ?? 0 < 1 {
            self.lastNameAlertLbl.isHidden = false
            count+=1
        }
        
        guard count == 0 else {
            return
        }
        self.firstNameTextfield.text = self.firstNameTextfield.text?.capitalized
        self.lastNameTextfield.text  = self.lastNameTextfield.text?.capitalized
        let sign = EmailViewController.loadFromNib()
        sign.hidesBottomBarWhenPushed = true
        sign.firstName = self.firstNameTextfield.text ?? TextConstant.sharedInstance.kEmpty
        sign.lastName = self.lastNameTextfield.text ?? TextConstant.sharedInstance.kEmpty
        self.navigationController?.pushViewController(sign, animated: true)
    }
    
    // MARK: - Private methods
    
    // MARK: - User interactions
    
    // MARK: - Network requests

}
// MARK: UITextFieldDelegate
extension SignUpViewController:UITextFieldDelegate {
     
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firstNameTextfield {
            var is_check : Bool
            let aSet = NSCharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            is_check = string == numberFiltered
            if is_check {
                let maxLength = 20
                let currentString: NSString = textField.text! as NSString
                let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
                is_check = newString.length <= maxLength
            }
         
            // Get the current text input
            guard let text = textField.text else {
                return true
            }
            
            guard is_check else {
                return false
            }
            let newString = NSString(string: text)
            let totalString = String(newString.replacingCharacters(in: range, with: string) as NSString)
            
            if totalString.count < 2 {
                self.firstNameAlertLbl.isHidden = false
                self.firstNameAlertLbl.text = "First Name should have Minimum 2 Characters"
            } else {
                self.firstNameAlertLbl.isHidden = true
            }
            
            if range.location == 0 && range.length == 0 {
                let firstString = totalString.prefix(1).uppercased()
                let remaingString = totalString.dropFirst(1).lowercased()
                textField.text = firstString + remaingString
            } else {
                return is_check
            }
           
            return false
        }
        
        if textField == lastNameTextfield {
            var is_check : Bool
            let aSet = NSCharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            is_check = string == numberFiltered
            if is_check {
                let maxLength = 20
                let currentString: NSString = textField.text! as NSString
                let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
                is_check = newString.length <= maxLength
            }
            if self.lastNameTextfield.text?.count ?? 0 < 1 {
                self.lastNameAlertLbl.isHidden = false
                self.lastNameAlertLbl.text = "Last Name should have Minimum 1 Character"
            } else {
                self.lastNameAlertLbl.isHidden = true
            }
            // Get the current text input
            guard let text = textField.text else {
                return true
            }
            
            guard is_check else {
                return false
            }
            let newString = NSString(string: text)
            let totalString = String(newString.replacingCharacters(in: range, with: string) as NSString)
            
            if range.location == 0 && range.length == 0 {
                let firstString = totalString.prefix(1).uppercased()
                let remaingString = totalString.dropFirst(1).lowercased()
                textField.text = firstString + remaingString
            } else {
                return is_check
            }
           
            return false
        }
        return true
    }
}
