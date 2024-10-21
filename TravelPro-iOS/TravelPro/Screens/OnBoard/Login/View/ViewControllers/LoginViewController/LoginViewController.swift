//
//  LoginViewController.swift
//  TravelPro
//
//  Created by Mac-OBS-32 on 11/04/23.
//

import UIKit
import AuthenticationServices
class LoginViewController: UIViewController {

    // MARK: - Properties
    var loginViewModel = LoginViewModel()
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextfield: FloatingTF!
    @IBOutlet weak var passwordTextfield: FloatingTF!
    @IBOutlet weak var erremaillbl: UILabel!
    @IBOutlet weak var errpasswordlbl: UILabel!
    @IBOutlet weak var btnshowPasswordOutlet: UIButton!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var nxtBtn: CustomButton!
    @IBOutlet weak var continueLBl: UILabel!
    @IBOutlet weak var forgotBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    
    var registerAPIToken = updateToken()
    
    
    // MARK: - View life cycle
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        utilsClass.sharedInstance.setTheme()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Private methods
    
    private func setupUI() {
        TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "LoginViewController - setupUI"))

        emailTextfield.addPlaceholderText(edit_profile_localize.email, color: UIColor(named: "grayText"))
        passwordTextfield.addPlaceholderText(login_localize.password, color: UIColor(named: "grayText"))
        self.emailTextfield.delegate = self
        self.passwordTextfield.delegate = self
        
        welcomeLbl.text = login_page_controller.hello_again
        forgotBtn.setTitle(login_page_controller.forgot_password, for: .normal)
        nxtBtn.setTitle(login_page_controller.next, for: .normal)
        continueLBl.text = login_page_controller.continue_with
    }
    
    @IBAction func appleButtonAct(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "LoginViewController - appleButtonAct"))

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
        TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "LoginViewController - signupSocialApiCall"))

        LoginViewModel.socialLoginAPIRequest(with: param, controller: self, boolLoaderEnable: true) { Response in
            switch Response {
            case .failure(let error):
                utilsClass.sharedInstance.debugprint(message: error)
            case .success(let result):
                if result.status?.status == 200 {
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
                            if appdelegate.locationToken != "" {
                                self.registerAPIToken.RegisterTokenAPICall(userId: userId, token: appdelegate.deviceToken, loctionToken: appdelegate.locationToken) { response in
                                    TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "LoginViewController - loctionToken - success response"))
                                } onFailure: { error in
                                    TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "LoginViewController - loctionToken - failure response - \(error)"))
                                }

                            }
                        }
                        appdelegate.moveToTabbarViaIndex(intIndex: 3)
                    }
                } else {
                    utilsClass.sharedInstance.debugprint(message: result)
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: result.status?.message ?? "", image: UIImage(named: "Notification") ?? nil,theme: .default)
                }
            }
        }
        
    }
    // MARK: - User interactions
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        //loginAPICall()
//        self.emailTextfield.text = "che.amu1207@gmail.com"
//        self.passwordTextfield.text = "Test@123"
        TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "LoginViewController - confirmButtonAction"))

        self.clearAllFields()
        var boolValidationEnable : Bool = false
        boolValidationEnable = updateErrorData(emailTextfield)
        boolValidationEnable = updateErrorData(passwordTextfield)
        self.view.endEditing(true)
        if boolValidationEnable == true {
        let logingparam  = LoginParam.init(username: self.emailTextfield.text!, password: self.passwordTextfield.text!)
        LoginViewModel.loginAPIRequest(with: logingparam, controller: self, boolLoaderEnable: true) { Response in
            switch Response {
            case .failure(let error):
                TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "LoginViewController - loginAPI error \(error)"))
                utilsClass.sharedInstance.debugprint(message: error)
            case .success(let result):
                if result.status?.status == "200" {
                    TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "LoginViewController - loginAPI success"))
                    utilsClass.sharedInstance.debugprint(message: result)
                    UserDefaultModule.shared.setUserName(userID: "\(result.profile?.userID?.firstName ?? "") \(result.profile?.userID?.lastName ?? "")")
                    UserDefaultModule.shared.setProfilePic(userID: AWSConfig.kAWSBaseURL + AWSConfig.kstaticfolderPath + (result.profile?.profileImage ?? ""))
                    UserDefaultModule.shared.setUserResident(resident: result.profile?.userID?.resident ?? "")
                    UserDefaultModule.shared.setUserID(userID: result.userID ?? "")
                    UserDefaultModule.shared.setUseremail(email: result.profile?.userID?.emailID ?? "")
                    UserDefaultModule.shared.set("true", forKey: "loginNewAccount")
                    if let userDefaults = UserDefaults(suiteName: "group.com.obs.travelpro") {
                        userDefaults.set(result.userID ?? "", forKey: "user_id")
                    }
                    UserDefaultModule.shared.setAccessToken(token: result.accessToken ?? "")
                    if let userDefaults = UserDefaults(suiteName: "group.com.obs.travelpro") {
                        userDefaults.set(result.accessToken ?? "", forKey: "accessToken")
                    }
                    UserDefaultModule.shared.setEmailID(userID: self.emailTextfield.text!)
                    if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
                        if let userId = UserDefaultModule.shared.getUserID() {
                            self.registerAPIToken.RegisterTokenAPICall(userId: userId, loctionToken: appdelegate.locationToken, isLocationToken: true) { response in
                                print(response)
                                TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "LoginViewController - loctionToken - success response"))

                            } onFailure: { error in
                                print(error)
                                TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "LoginViewController - loctionToken - failure response - \(error)"))
                            }
                            
                            self.registerAPIToken.RegisterTokenAPICall(userId: userId, token: appdelegate.deviceToken) { response in
                                print(response)
                            } onFailure: { error in
                                print(error)
                            }
                        }
                        appdelegate.moveToTabbarViaIndex(intIndex: 3)
                    }
                } else {
                    TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "LoginViewController - loginAPI not scucess \(result.status?.status ?? "")"))

                    utilsClass.sharedInstance.debugprint(message: result)
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: result.status?.message ?? "", image: UIImage(named: "Notification") ?? nil,theme: .default)
                }
            }
        }
        }
    }
    @IBAction func btnSecure_Act(_ sender: Any) {
        if(self.passwordTextfield.isSecureTextEntry == true){
            self.passwordTextfield.isSecureTextEntry = false
            self.btnshowPasswordOutlet.setImage(UIImage(named: "eyeclose"), for: .normal)
        }else{
            self.passwordTextfield.isSecureTextEntry = true
            self.btnshowPasswordOutlet.setImage(UIImage(named: "eyeopen"), for: .normal)
        }
    }
    func clearAllFields() {
        TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "LoginViewController - clearAllFields"))

        self.emailTextfield.setErrorAlertActive = false
        self.passwordTextfield.setErrorAlertActive = false
        self.erremaillbl.isHidden = true
        self.errpasswordlbl.isHidden = true
    }
    @IBAction func forgorPasswordAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "LoginViewController - forgorPasswordAction"))
        let forgot = ForgotPasswordViewController.loadFromNib()
        self.navigationController?.pushViewController(forgot, animated: true)
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "LoginViewController - signUpAction"))
        let forgot = SignUpViewController.loadFromNib()
        self.navigationController?.pushViewController(forgot, animated: true)
    }
}
extension LoginViewController: UITextFieldDelegate {
    func updateErrorData(_ sender: UITextField) -> Bool {
        var isValid = true
        if sender == emailTextfield {
            if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: sender.text ?? "")) {
                self.erremaillbl.isHidden = true
                emailTextfield.setErrorAlertActive = false
                isValid = true
                return isValid
            } else {
                
                if sender.text == TextConstant.sharedInstance.SEmpty {
                    isValid = false
                    self.erremaillbl.text = TextConstant.sharedInstance.emptyemailerror
                    self.erremaillbl.isHidden = false
                    emailTextfield.setErrorAlertActive = true
                }
                else if !sender.isValidEmail() {
                    isValid = false
                    self.erremaillbl.text = TextConstant.sharedInstance.erroremail
                    self.erremaillbl.isHidden = false
                    emailTextfield.setErrorAlertActive = true
                }
                else {
                    self.erremaillbl.isHidden = true
                }
                return isValid
            }

        } else {
            if sender.text == TextConstant.sharedInstance.SEmpty{
                isValid = false
                self.errpasswordlbl.text = TextConstant.sharedInstance.emptypassworderror
                self.errpasswordlbl.isHidden = false
                passwordTextfield.setErrorAlertActive = true
            }
            else {
                self.errpasswordlbl.isHidden = true
            }
            return isValid
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
