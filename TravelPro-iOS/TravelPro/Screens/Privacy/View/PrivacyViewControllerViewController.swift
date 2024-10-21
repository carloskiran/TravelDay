//
//  PrivacyViewControllerViewController.swift
//  TravelPro
//
//  Created by Mac-OBS-32 on 12/05/23.
//

import UIKit

class PrivacyViewControllerViewController: UIViewController {

    @IBOutlet weak var imgCondti1: UIImageView!
    @IBOutlet weak var imgCondti2: UIImageView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var nextBtn: CustomButton!
    
    @IBOutlet weak var personalInfoDescriptionLabel: UILabel!
    @IBOutlet weak var personalCollectInfoDescriptionLabel: UILabel!
    @IBOutlet weak var locationInfoDescriptionLabel: UILabel!
    @IBOutlet weak var locationCollectDescriptionLabel: UILabel!

    var email = String()
    var password = String()
    var registerAPIToken = updateToken()
    var isPersonalInfoCheck:Bool = false
    var isLocationPermissionCheck:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // Do any additional setup after loading the view.
        self.nextBtn.startColor = UIColor(named: "endGradientColor") ?? .green
        self.nextBtn.endColor = UIColor(named: "endGradientColor") ?? .green
        setupUIConfig()
    }

    @IBAction func Condition1Action(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .privacyViewController, state: .info, data: MixPanelData(message: "PrivacyViewControllerViewController - Condition1Action"))
        if imgCondti1.isHidden == false {
            imgCondti1.isHidden = true
        } else {
            imgCondti1.isHidden = false
        }
        errorcheck()
    }
    func errorcheck() {
        TravelTaxMixPanelAnalytics(action: .privacyViewController, state: .info, data: MixPanelData(message: "PrivacyViewControllerViewController - errorcheck"))
        if isPersonalInfoCheck == true && isLocationPermissionCheck == true {
            self.errorView.isHidden = true
            self.nextBtn.startColor = UIColor(named: "startGradientColor") ?? .green
            self.nextBtn.endColor = UIColor(named: "endGradientColor") ?? .green
        } else {
            self.errorView.isHidden = false
            self.nextBtn.startColor = UIColor(named: "endGradientColor") ?? .green
            self.nextBtn.endColor = UIColor(named: "endGradientColor") ?? .green
        }
    }
    @IBAction func Condition2Action(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .privacyViewController, state: .info, data: MixPanelData(message: "PrivacyViewControllerViewController - Condition2Action"))
        if imgCondti2.isHidden == false {
            imgCondti2.isHidden = true
        } else {
            imgCondti2.isHidden = false
        }
        errorcheck()
    }
    @IBAction func ButtonValidationNextAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .privacyViewController, state: .info, data: MixPanelData(message: "PrivacyViewControllerViewController - ButtonValidationNextAction"))
        if isPersonalInfoCheck == true && isLocationPermissionCheck == true {
            let logingparam  = LoginParam.init(username: self.email, password: self.password)
            LoginViewModel.loginAPIRequest(with: logingparam, controller: self, boolLoaderEnable: true) { Response in
                switch Response {
                case .failure(let error):
                    TravelTaxMixPanelAnalytics(action: .privacyViewController, state: .error, data: MixPanelData(message: "PrivacyViewControllerViewController - ButtonValidationNextAction - failure response"))
                    utilsClass.sharedInstance.debugprint(message: error)
                case .success(let result):
                    if result.status?.status == "200" {
                        TravelTaxMixPanelAnalytics(action: .privacyViewController, state: .success, data: MixPanelData(message: "PrivacyViewControllerViewController - ButtonValidationNextAction - success response"))
                        utilsClass.sharedInstance.debugprint(message: result)
                        UserDefaultModule.shared.setAccessToken(token: result.accessToken ?? "")
                        if let userDefaults = UserDefaults(suiteName: "group.com.obs.travelpro") {
                            userDefaults.set(result.accessToken ?? "", forKey: "accessToken")
                        }
                        UserDefaultModule.shared.setUserName(userID: "\(result.profile?.userID?.firstName ?? "") \(result.profile?.userID?.lastName ?? "")")
                        
                        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
                            if let userId = UserDefaultModule.shared.getUserID() {
                                self.registerAPIToken.RegisterTokenAPICall(userId: userId, loctionToken: appdelegate.locationToken, isLocationToken: true) { response in
                                    TravelTaxMixPanelAnalytics(action: .privacyViewController, state: .success, data: MixPanelData(message: "PrivacyViewControllerViewController - loctionToken - success response"))
                                    print(response)
                                } onFailure: { error in
                                    TravelTaxMixPanelAnalytics(action: .privacyViewController, state: .error, data: MixPanelData(message: "PrivacyViewControllerViewController - loctionToken - failure response"))
                                    print(error)
                                }
                                
                                self.registerAPIToken.RegisterTokenAPICall(userId: userId, token: appdelegate.deviceToken) { response in
                                    TravelTaxMixPanelAnalytics(action: .privacyViewController, state: .success, data: MixPanelData(message: "PrivacyViewControllerViewController - FCM push notification - success response"))
                                    print(response)
                                } onFailure: { error in
                                    TravelTaxMixPanelAnalytics(action: .privacyViewController, state: .error, data: MixPanelData(message: "PrivacyViewControllerViewController - FCM push notification - failure response"))
                                    print(error)
                                }
                            }
                            appdelegate.moveToTabbarViaIndex(intIndex: 3)
                        }
                    } else {
                        TravelTaxMixPanelAnalytics(action: .privacyViewController, state: .success, data: MixPanelData(message: "PrivacyViewControllerViewController - success response"))
                        utilsClass.sharedInstance.debugprint(message: result)
                        utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: result.status?.message ?? "", image: UIImage(named: "Notification") ?? nil,theme: .default)
                    }
                }
            }
        }
        
    }
    
    @IBAction func checkboxButtonAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            switch self.isPersonalInfoCheck {
            case true:
                self.isPersonalInfoCheck = false
                self.imgCondti1.image = UIImage(named: "consent_uncheck")
            default:
                self.isPersonalInfoCheck = true
                self.imgCondti1.image = UIImage(named: "consent_check")
            }
        default:
            switch self.isLocationPermissionCheck {
            case true:
                self.isLocationPermissionCheck = false
                self.imgCondti2.image = UIImage(named: "consent_uncheck")
            default:
                self.isLocationPermissionCheck = true
                self.imgCondti2.image = UIImage(named: "consent_check")
            }
        }
        errorcheck()
    }
         
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    private func setupUIConfig() {
        self.personalInfoDescriptionLabel.attributedText = setBoldText(withString: self.personalInfoDescriptionLabel.text ?? "", boldString: "TravelTaxDay", font: UIFont.fontR12)
        self.personalCollectInfoDescriptionLabel.attributedText = setBoldText(withString: self.personalCollectInfoDescriptionLabel.text ?? "", boldString: "TravelTaxDay", font: UIFont.fontR12)
        self.locationInfoDescriptionLabel.attributedText = setBoldText(withString: self.locationInfoDescriptionLabel.text ?? "", boldString: "Location Permission", font: UIFont.fontR12)
        self.locationCollectDescriptionLabel.attributedText = setBoldText(withString: self.locationCollectDescriptionLabel.text ?? "", boldString: "TravelTaxDay", font: UIFont.fontR12)

    }
    
    //MARK: - UnitTestcase
    
    func unitTestcase() {
        self.Condition1Action(UIButton())
        errorcheck()
        isPersonalInfoCheck = true
        isLocationPermissionCheck = true
        errorcheck()
        Condition2Action(UIButton())
        ButtonValidationNextAction(UIButton())
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        button.tag = 1
        checkboxButtonAction(button)
        button.tag = 2
        checkboxButtonAction(button)

    }
}
