//
//  EmailViewController.swift
//  TravelPro
//
//  Created by Mac-OBS-32 on 11/04/23.
//

import UIKit

class EmailViewController: UIViewController {
    
    
    // MARK: - Properties
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextfield: FloatingTF!
    @IBOutlet weak var emailAlrtLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var instructionLbl: UILabel!
    @IBOutlet weak var nxtBtn: CustomButton!
    
    var emailViewModel = EmailViewModel()
    var firstName = String()
    var lastName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
//        emailTextfield.addPlaceholderText(edit_profile_localize.email, color: UIColor(named: "grayText"))
        headingLbl.text = email_view_controller.contact_digitally
        instructionLbl.text = email_view_controller.first_instruction
        nxtBtn.setTitle(login_page_controller.next, for: .normal)
        utilsClass.sharedInstance.debugprint(message: firstName)
        utilsClass.sharedInstance.debugprint(message: lastName)
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        self.clearAllFields()
        var boolValidationEnable : Bool = false
        boolValidationEnable = updateErrorData(emailTextfield)
        self.view.endEditing(true)
        if boolValidationEnable == true {
            
            
            let mobileparam = EmailValidationParam(email: self.emailTextfield.text ?? "")
            EmailViewModel.EmailValidationAPIRequest(with: mobileparam, controller: self, boolLoaderEnable: true) { Response in
                switch Response {
                case .failure(let error):
                    TravelTaxMixPanelAnalytics(action: .signup, state: .info, data: MixPanelData(message: "nextButtonAction - EmailValidationAPIRequest - error: \(error)"))
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error.localizedDescription , image: UIImage(named: "Notification") ?? nil,theme: .default)
                    utilsClass.sharedInstance.debugprint(message: error)
                case .success(let result):
                    if result.status?.status == 204 {
                        let sign = PhoneNumViewController.loadFromNib()
                        sign.firstName = self.firstName
                        sign.lastName = self.lastName
                        sign.email = self.emailTextfield.text ?? TextConstant.sharedInstance.SEmpty
                        sign.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(sign, animated: true)
                        
                    } else {
                        utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: result.status?.message ?? "", image: UIImage(named: "Notification") ?? nil,theme: .default)
                    }
                }
            }
        }
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func clearAllFields() {
        self.emailTextfield.setErrorAlertActive = false
        self.emailAlrtLbl.isHidden = true
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
extension EmailViewController: UITextFieldDelegate {
    func updateErrorData(_ sender: UITextField) -> Bool {
        var isValid = true
        if sender.text == TextConstant.sharedInstance.SEmpty{
            isValid = false
            self.emailAlrtLbl.text = TextConstant.sharedInstance.emptyemailerror
            self.emailAlrtLbl.isHidden = false
            emailTextfield.setErrorAlertActive = true
        }
        else if !sender.isValidEmail() {
            isValid = false
            self.emailAlrtLbl.text = TextConstant.sharedInstance.erroremail
            self.emailAlrtLbl.isHidden = false
            emailTextfield.setErrorAlertActive = true
        }
        else {
            self.emailAlrtLbl.isHidden = true
            
            
        }
        return isValid
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

