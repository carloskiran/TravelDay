//
//  ForgotPasswordViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 17/04/23.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextfield: FloatingTF!
    @IBOutlet weak var erremaillbl: UILabel!
    
    var forgotPassword = ForgotPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: - Private methods
    
    // MARK: - User interactions
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func signupButtonAction(_ sender: Any) {
        let signup = SignUpViewController.loadFromNib()
        self.navigationController?.pushViewController(signup, animated: true)
    }
    func clearAllFields() {
        self.emailTextfield.setErrorAlertActive = false
        self.erremaillbl.isHidden = true
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        self.clearAllFields()
        var boolValidationEnable : Bool = false
        boolValidationEnable = updateErrorData(emailTextfield)
        self.view.endEditing(true)
        if boolValidationEnable == true {
            
//            forgotPassword.generateOTP(userName: emailTextfield.text ?? "", self.view, enableLoader: true) { response in
//                print(response)
//                if response.status.status == 200 {
//                    let alertVC = PMAlertController(title:"", description: "We have sent a OTP with recover instruction to your email", image: UIImage(named: "email_otp_icon"), style: .walkthrough)
//                    alertVC.alertDescription.textColor = Constant.sharedInstance.appColor
//                    alertVC.alertTitle.textColor = Constant.sharedInstance.appColor
//                    alertVC.addAction(PMAlertAction(title: "Ok", style: .default, backgroundColor: UIColor.white,buttonTitleColor: Constant.sharedInstance.appColor,  action: { () in
//                        let signup = ForgotPasswordMobileOtpViewController.loadFromNib()
//                        signup.userNameId = self.emailTextfield.text ?? ""
//                        self.navigationController?.pushViewController(signup, animated: true)
//                    }))
//                    self.present(alertVC, animated: true, completion: nil)
//                }
//            } onFailure: { error in
//                print(error)
//            }

            
            forgotPassword.accountValidation(userName: emailTextfield.text ?? "", self.view, enableLoader: true, onSuccess: { response in
                print(response)
                if response.status?.status == 200 {
                    let alertVC = PMAlertController(title:"", description: "We have sent a OTP with recover instruction to your email", image: UIImage(named: "email_otp_icon"), style: .walkthrough)
                    alertVC.alertDescription.textColor = Constant.sharedInstance.appColor
                    alertVC.alertTitle.textColor = Constant.sharedInstance.appColor
                    alertVC.addAction(PMAlertAction(title: "Ok", style: .default, backgroundColor: UIColor.white,buttonTitleColor: Constant.sharedInstance.appColor,  action: { () in
                        let signup = ForgotPasswordMobileOtpViewController.loadFromNib()
                        signup.userNameId = self.emailTextfield.text ?? ""
                        signup.FlowType = "signup"
                        self.navigationController?.pushViewController(signup, animated: true)
                    }))
                    self.present(alertVC, animated: true, completion: nil)
                } else {
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: response.status?.message ?? "", image: UIImage(named: "Notification") ?? nil,theme: .default)
                }
            }, onFailure: { error in
                print(error)
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error.description, image: UIImage(named: "Notification") ?? nil,theme: .default)
            })
        }
    }
    
}
extension ForgotPasswordViewController: UITextFieldDelegate {
    func updateErrorData(_ sender: UITextField) -> Bool {
        var isValid = true
        if sender == emailTextfield {
            if sender.text == TextConstant.sharedInstance.SEmpty{
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
        return isValid
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
