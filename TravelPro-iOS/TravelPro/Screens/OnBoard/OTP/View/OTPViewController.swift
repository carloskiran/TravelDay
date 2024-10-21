//
//  OTPViewController.swift
//  TravelPro
//
//  Created by Mac-OBS-32 on 12/04/23.
//

import UIKit

class OTPViewController: UIViewController {
    
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    var emailOTP = String()
    var mobileOTP = String()
    var email = String()
    var password = String()
    var mobile = String()
    var mobileCode = String()
    var flowtype = String()
    
    var firstName = String()
    var lastName = String()
    var userType = String()
    var resident = String()
    var isVerifiedEmail = Bool()
    var otpApiType:OtpApiType = .fromSignup
    
    @IBOutlet weak var emailOTPView: DPOTPView!
    let validateOTP = ForgotPasswordViewModel()
    let generateotp = ForgotPasswordViewModel()
    @IBOutlet var countDownLabel: UILabel!
    var count = 120
    var timer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let att = NSMutableAttributedString(string: resendButton.titleLabel?.text ?? "");
        att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: 26))
        att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(named: "headingText") ?? UIColor.lightGray, range: NSRange(location: 27, length: 6))
        resendButton.setAttributedTitle(att, for: .normal)
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(OTPViewController.update), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.emailOTPView.text = ""
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
    @IBAction func backAction(_ sender: UIButton) {
        self.timer?.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnResendOTP(_ sender: UIButton) {
        self.timer?.invalidate()
        generateotp.newUserOTPGenerate(mobileNo: "", email: self.email, countryCode: self.mobileCode, self.view, enableLoader: true) { response in
            if response.status?.status == 200 {
                TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "btnResendOTP - newUserOTPGenerate success - \(response)"))
//                self.emailOTP = response.entity?.emailOtp ?? ""
//                self.mobileOTP = response.entity?.mobileOtp ?? ""
                self.submitButton.isUserInteractionEnabled = true
                self.submitButton.alpha = 1.0
                self.count = 120
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(OTPViewController.update), userInfo: nil, repeats: true)
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: response.status?.message ?? TextConstant.sharedInstance.SEmpty, image: UIImage(named: "Notification") ?? nil,theme: .default)
            } else {
                TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "btnResendOTP - newUserOTPGenerate not success - \(response)"))
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: response.status?.message ?? TextConstant.sharedInstance.SEmpty, image: UIImage(named: "Notification") ?? nil,theme: .default)
            }
        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "btnResendOTP - newUserOTPGenerate failure - \(error)"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error.description, image: UIImage(named: "Notification") ?? nil,theme: .default)
        }
        
    }
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        
        if emailOTPView.text == "" {
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Please Fill Email OTP", image: UIImage(named: "Notification") ?? nil,theme: .default)
            
        }
        else {
            validateOTP.otpValidation(mobileNo: "", mobileOtp:  "", email: self.email,emailOtp: self.emailOTPView.text ?? "", otpType:self.otpApiType, self.view, enableLoader: true) { response in
                if response.status?.status == 200 {
                    self.timer?.invalidate()
                    let alertVC = PMAlertController(title:"", description:response.status?.message, image: UIImage(named: "email_otp_icon"), style: .walkthrough)
                    alertVC.alertDescription.textColor = Constant.sharedInstance.appColor
                    alertVC.alertTitle.textColor = Constant.sharedInstance.appColor
                    alertVC.addAction(PMAlertAction(title: "Ok", style: .default, backgroundColor: UIColor.white,buttonTitleColor: Constant.sharedInstance.appColor,  action: { () in
                        if self.flowtype == "MyProfile" {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            let sign = CreatePasswordViewController.loadFromNib()
                            sign.userNameId = self.email
                            sign.flowType = "Signup"
                            sign.userNameId = self.email
                            sign.mobile = self.mobile
                            sign.mobileCode = self.mobileCode
                            sign.firstName = self.firstName
                            sign.lastName = self.lastName
                            sign.userType = self.userType
                            sign.resident = self.resident
                            sign.isVerifiedEmail = true
                            self.navigationController?.pushViewController(sign, animated: true)
                        }
                    }))
                    self.present(alertVC, animated: true, completion: nil)
                } else {
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: response.status?.message ?? "", image: UIImage(named: "Notification") ?? nil,theme: .default)
                }
            } onFailure: { error in
                
            }
        }
        
    }
    
}
class ActualGradientButton: CustomButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [UIColor.systemYellow.cgColor, UIColor.systemPink.cgColor]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 16
        layer.insertSublayer(l, at: 0)
        return l
    }()
}

enum OtpApiType: String {
    case fromProfile
    case fromSignup
}
