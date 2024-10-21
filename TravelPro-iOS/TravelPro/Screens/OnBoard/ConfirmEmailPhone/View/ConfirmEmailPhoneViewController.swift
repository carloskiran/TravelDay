//
//  ConfirmEmailPhoneViewController.swift
//  TravelPro
//
//  Created by Mac-OBS-32 on 11/04/23.
//

import UIKit

class ConfirmEmailPhoneViewController: UIViewController {

    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var mobileNoLbl: UILabel!
    @IBOutlet weak var clickHereLbl: UIButton!
    @IBOutlet weak var wishViewLbl: UILabel!
    @IBOutlet weak var instructionLbl: UILabel!
    @IBOutlet weak var verifyNowBtn: CustomButton!
    @IBOutlet weak var verifyLaterBtn: CustomButton!
    @IBOutlet weak var phoneIconImageview: UIImageView!
    
    var firstName = String()
    var lastName = String()
    var email = String()
    var mobile = String()
    var mobileCode = String()
    var userType = String()
    var countryCode = String()
    var resident = String()
    
    let generateotp = ForgotPasswordViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let att = NSMutableAttributedString(string: resendButton.titleLabel?.text ?? "");
        att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: 22))
        att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(named: "headingText") ?? UIColor.lightGray, range: NSRange(location: 23, length: 10))
        resendButton.setAttributedTitle(att, for: .normal)
//        self.userNameLbl.text = "Hi, \(firstName) \(lastName)"
        UIConfigurations()
        self.emailLbl.text = self.email
        
        switch mobileCode {
        case "":
            self.mobileNoLbl.isHidden = true
            self.phoneIconImageview.isHidden = true
        default:
            self.mobileNoLbl.text = "\(mobileCode) \(mobile)"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let userdefault = UserDefaults.standard
//        let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
//        if isDarkMode {
//            self.verifyLaterBtn.backgroundColor = UIColor(named: "VioletAndBlueColor")
//        }
    }
    
    func UIConfigurations() {

//        let splitUserNameString = userNameString.components(separatedBy: ",")
        let splitClickHere = tp_strings.Confirm_Email_Controller.need_to_change.components(separatedBy: "!")
//        userNameLbl.attributedText = userNameString.multipleStringAndFont(firstString: "\(splitUserNameString[0]),", firstTextColor: UIColor.headingWhiteText, secondString: "\(splitUserNameString[1])", secondTextColor: UIColor.headingWhiteText, firstTextFont: UIFont(name: "Roboto-Bold", size: 26.0) ?? UIFont.systemFont(ofSize: 26.0), secondTextFont: UIFont.fontR26)
        
        let boldText = "Hi, "
        let attrs = [NSAttributedString.Key.font : UIFont.fontB26]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        let normalText = "\(firstName) \(lastName)"
        let normalString = NSMutableAttributedString(string:normalText)
        attributedString.append(normalString)
        userNameLbl.attributedText = attributedString
        instructionLbl.text = email_view_controller.confirm_email
        instructionLbl.font = .fontL14
        
//        let verify_email = tp_strings.Confirm_Email_Controller.verify_this_email.components(separatedBy: "-")
//        wishViewLbl.attributedText = String().multipleStringAndFont(firstString: verify_email[0], firstTextColor: .headingText, secondString: verify_email[1], secondTextColor: .darkGray, firstTextFont: .fontB14, secondTextFont: .fontM14)
        let titleString = String().multipleStringAndFont(firstString: "\(splitClickHere[0])! ", firstTextColor: UIColor.headingGrayColor, secondString: "\(splitClickHere[1])", secondTextColor: UIColor.headingText, firstTextFont: .fontR14, secondTextFont: .fontB14)
        clickHereLbl.setAttributedTitle(titleString, for: .selected)
        clickHereLbl.setAttributedTitle(titleString, for: .normal)
        
        verifyLaterBtn.titleLabel?.font = .fontB14
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {

        generateotp.newUserOTPGenerate(mobileNo: "\(self.mobile)", email: self.email, countryCode: self.mobileCode, self.view, enableLoader: true) { response in
            if response.status?.status == 200 {
                TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "confirmButtonAction - newUserOTPGenerate success - \(response)"))
                let sign = OTPViewController.loadFromNib()
                sign.email = self.email
                sign.mobile = self.mobile
                sign.flowtype = "Signup"
                sign.mobileCode = self.mobileCode
                sign.firstName = self.firstName
                sign.lastName = self.lastName
                sign.userType = self.userType
                sign.resident = self.resident
                sign.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(sign, animated: true)
            } else {
                TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "confirmButtonAction - newUserOTPGenerate not success - \(response)"))

                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: response.status?.message ?? TextConstant.sharedInstance.SEmpty, image: UIImage(named: "Notification") ?? nil,theme: .default)
            }
        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .login, state: .info, data: MixPanelData(message: "confirmButtonAction - newUserOTPGenerate failure - \(error)"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error.description, image: UIImage(named: "Notification") ?? nil,theme: .default)
        }
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func verifyLaterAction(_ sender: UIButton) {
        
        let signup = CreatePasswordViewController.loadFromNib()
        signup.userNameId = self.email
        signup.flowType = "Signup"
        signup.mobile = self.mobile
        signup.mobileCode = self.mobileCode
        signup.firstName = self.firstName
        signup.lastName = self.lastName
        signup.userType = self.userType
        signup.resident = self.resident
        signup.isVerifiedEmail = false
        self.navigationController?.pushViewController(signup, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

