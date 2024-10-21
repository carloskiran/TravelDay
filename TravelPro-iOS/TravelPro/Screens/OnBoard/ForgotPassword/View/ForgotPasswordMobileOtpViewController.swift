//
//  ForgotPasswordMobileOtpViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 17/04/23.
//

import UIKit

class ForgotPasswordMobileOtpViewController: UIViewController ,UITextFieldDelegate {

    @IBOutlet weak var oneTextfield: UITextField!
    @IBOutlet weak var twoTextfield: UITextField!
    @IBOutlet weak var threeTextfield: UITextField!
    @IBOutlet weak var fourTextfield: UITextField!
//    @IBOutlet weak var fiveTextfield: UITextField!
//    @IBOutlet weak var sixTextfield: UITextField!
    @IBOutlet weak var emailOTPView: DPOTPView!
    var forgotPasswordModel = ForgotPasswordViewModel()
    var userNameId = String()
    var FlowType = String()
    var OTPType = String()
    var count = 120
    var timer : Timer?
    @IBOutlet var countDownLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    // MARK: - Properties
    
    // MARK: - IBOutlets

    // MARK: - View life cycle
    
    // MARK: - ViewDidLoad
    var forgotPassword = ForgotPasswordViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ForgotPasswordMobileOtpViewController.update), userInfo: nil, repeats: true)
    }
    @objc func update() {
        if(count > 0) {
            count -= 1
            countDownLabel.text = self.timeFormatted(self.count)
        } else {
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "OTP Expired", image: UIImage(named: "Notification") ?? nil,theme: .default)
            timer?.invalidate()
            submitButton.isUserInteractionEnabled = false
            submitButton.alpha = 0.5
            
        }
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
            let seconds: Int = totalSeconds % 60
            let minutes: Int = (totalSeconds / 60) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: - Private methods
    
    // MARK: - User interactions
    @IBAction func backAction(_ sender: UIButton) {
        timer?.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func okAction(_ sender: Any) {
         if emailOTPView.text == "" {
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Please Fill Email OTP", image: UIImage(named: "Notification") ?? nil,theme: .default)
            
        }
        else {
            if FlowType == "MyProfile" {
                if OTPType == "Mobile" {
                    self.forgotPasswordModel.otpValidation(mobileNo: userNameId, mobileOtp:emailOTPView.text ?? "", email: "", emailOtp:  "", otpType: .fromSignup, self.view, enableLoader: true) { response in
                        if response.status?.status == 200 {
                            if self.FlowType == "MyProfile" {
                                self.timer?.invalidate()
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                self.timer?.invalidate()
                                let signup = CreatePasswordViewController.loadFromNib()
                                signup.userNameId = self.userNameId
                                self.navigationController?.pushViewController(signup, animated: true)
                            }
                        } else {
                            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: response.status?.message ?? "", image: UIImage(named: "Notification") ?? nil,theme: .default)
                        }
                    } onFailure: { error in
                        
                    }
                } else {
                    self.forgotPasswordModel.otpValidation(mobileNo: "", mobileOtp:"", email: userNameId, emailOtp:  emailOTPView.text ?? "", otpType: .fromProfile,self.view, enableLoader: true) { response in
                        if response.status?.status == 200 {
                            if self.FlowType == "MyProfile" {
                                self.timer?.invalidate()
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                self.timer?.invalidate()
                                let signup = CreatePasswordViewController.loadFromNib()
                                signup.userNameId = self.userNameId
                                self.navigationController?.pushViewController(signup, animated: true)
                            }
                        } else {
                            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: response.status?.message ?? "", image: UIImage(named: "Notification") ?? nil,theme: .default)
                        }
                    } onFailure: { error in
                        
                    }
                }
            } else {
                self.forgotPasswordModel.otpValidation(mobileNo: "", mobileOtp: "", email: userNameId, emailOtp: emailOTPView.text ?? "", otpType: .fromSignup,self.view, enableLoader: true) { response in
                    if response.status?.status == 200 {
                        self.timer?.invalidate()
                        let signup = CreatePasswordViewController.loadFromNib()
                        signup.userNameId = self.userNameId
                        self.navigationController?.pushViewController(signup, animated: true)
                    } else {
                        utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: response.status?.message ?? "", image: UIImage(named: "Notification") ?? nil,theme: .default)
                    }
                } onFailure: { error in
                    
                }
            }
        }
    }
    @IBAction func regenerateOTP(_sender : UIButton) {
        self.timer?.invalidate()
//        forgotPassword.generateOTP(mobileNo: "", email: self.userNameId, countryCode: "", self.view, enableLoader: true) { Response in
//            if Response.status?.status == 200 {
//                let alertVC = PMAlertController(title:"", description: "We have sent a OTP with recover instruction to your email", image: UIImage(named: "email_otp_icon"), style: .walkthrough)
//                alertVC.alertDescription.textColor = Constant.sharedInstance.appColor
//                alertVC.alertTitle.textColor = Constant.sharedInstance.appColor
//                alertVC.addAction(PMAlertAction(title: "Ok", style: .default, backgroundColor: UIColor.white,buttonTitleColor: Constant.sharedInstance.appColor,  action: { () in
//                    self.submitButton.isUserInteractionEnabled = true
//                    self.submitButton.alpha = 1.0
//                    self.count = 120
//                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ForgotPasswordMobileOtpViewController.update), userInfo: nil, repeats: true)
//                }))
//                self.present(alertVC, animated: true, completion: nil)
//            }
//        } onFailure: { error in
//
//        }
        
        forgotPassword.newUserOTPGenerate(mobileNo: "", email: self.userNameId, countryCode: "", self.view, enableLoader: true) { Response in
            if Response.status?.status == 200 {
                let alertVC = PMAlertController(title:"", description: "We have sent a OTP with recover instruction to your email", image: UIImage(named: "email_otp_icon"), style: .walkthrough)
                alertVC.alertDescription.textColor = Constant.sharedInstance.appColor
                alertVC.alertTitle.textColor = Constant.sharedInstance.appColor
                alertVC.addAction(PMAlertAction(title: "Ok", style: .default, backgroundColor: UIColor.white,buttonTitleColor: Constant.sharedInstance.appColor,  action: { () in
                    self.submitButton.isUserInteractionEnabled = true
                    self.submitButton.alpha = 1.0
                    self.count = 120
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ForgotPasswordMobileOtpViewController.update), userInfo: nil, repeats: true)
                }))
                self.present(alertVC, animated: true, completion: nil)
            } else {
                TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "regenerateOTP - newUserOTPGenerate - not success - \(Response)"))
            }
        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "regenerateOTP - newUserOTPGenerate failure - \(error)"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error.description, image: UIImage(named: "Notification") ?? nil,theme: .default)
        }


    }
    
    //MARK: - UnitTestcase
    
    func unitTestcase() {
        
        self.count = 1
        update()
        
        self.count = 0
        update()
        
        let _ = timeFormatted(120)
        self.backAction(UIButton())

    }
    
}
// MARK: extension
extension ForgotPasswordMobileOtpViewController {
    // MARK: Make round corner
     
       
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("TextField did shouldChangeCharactersIn method called")
        let content : String = UIPasteboard.general.string ?? ""
        if (content.count == 4){
        print("Tex imrn")
            if content.isNumber == true {
            let arr = content.map { String($0) }
            print(arr)
            self.oneTextfield.text = ""
            self.twoTextfield.text = ""
            self.threeTextfield.text = ""
            self.fourTextfield.text = ""
            self.oneTextfield.text = "\(arr[0])"
            self.twoTextfield.text = "\(arr[1])"
            self.threeTextfield.text = "\(arr[2])"
            self.fourTextfield.text = "\(arr[3])"
            UIPasteboard.general.string = ""
            //self.btnConfirm_Act(btnConfirmOutlet ?? (Any).self)
            } else {
                textField.text = ""
                return false
            }
        return false
        }
       else  if (content.count >= 4) {
            textField.text = ""
            return false
        }
       else  if ((textField.text?.count)! < 1  && string.count > 0){
            if(textField == oneTextfield){
                twoTextfield.becomeFirstResponder()
            }
            if(textField == twoTextfield){
                threeTextfield.becomeFirstResponder()
            }
            if(textField == threeTextfield){
                fourTextfield.becomeFirstResponder()
            }
            textField.text = string
            if(textField == fourTextfield){
               // self.btnConfirm_Act(btnConfirmOutlet ?? (Any).self)
            }
            return false
        }else if ((textField.text?.count)! >= 1  && string.count == 0){
            // on deleting value from Textfield
            if(textField == twoTextfield){
                oneTextfield.becomeFirstResponder()
            }
            if(textField == threeTextfield){
                twoTextfield.becomeFirstResponder()
            }
            if(textField == fourTextfield){
                threeTextfield.becomeFirstResponder()
            }
            
            textField.text = ""
            return false
        }else if ((textField.text?.count)! >= 1  ) {
            textField.text = string
            return false
        }
        return true
    }
}
extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
