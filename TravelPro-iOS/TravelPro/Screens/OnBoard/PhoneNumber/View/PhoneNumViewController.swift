//
//  PhoneNumViewController.swift
//  TravelPro
//
//  Created by Mac-OBS-32 on 11/04/23.
//

import UIKit

class PhoneNumViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var phoneAlertLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var instructionLbl: UILabel!
    @IBOutlet weak var submitBtn: CustomButton!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var countryImageView: UILabel!
    @IBOutlet weak var phoneCodeAlertLbl: UILabel!
    var phoneModel = PhoneViewModel()
    var firstName = String()
    var lastName = String()
    var email = String()
    var resident = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextfield.addPlaceholderText(edit_profile_localize.phone, color: UIColor(named: "grayText"))
        phoneTextfield.delegate = self
        headingLbl.text = email_view_controller.add_phone
        instructionLbl.text = email_view_controller.phone_first_instruction
        submitBtn.setTitle(email_view_controller.submit, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        self.phoneAlertLbl.isHidden = true
        self.phoneCodeAlertLbl.isHidden = true
        guard self.countryLbl.text?.count ?? 0 >= 1 else {
            return self.phoneCodeAlertLbl.isHidden = false
        }
        if self.phoneTextfield.text?.count == 0 {
            self.phoneAlertLbl.isHidden = false
            return
        }
//        guard self.phoneTextfield.text?.count ?? 0 == 10 else {
//            return self.phoneAlertLbl.isHidden = false
//        }
        let alertVC = PMAlertController(title: "Kindly check and confirm before you proceed for verification." , description: "\n Email \n \(self.email) \n Mobile \n \(self.phoneTextfield.text ?? TextConstant.sharedInstance.SEmpty)", image: UIImage(named: "Notification"), style: .walkthrough) //Image by freepik.com, taken on flaticon.com
        
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, backgroundColor: UIColor.white, buttonTitleColor: Constant.sharedInstance.appColor, action: { () -> Void in
            
        }))
        alertVC.addAction(PMAlertAction(title: "Ok", style: .default, backgroundColor: UIColor.white,buttonTitleColor: Constant.sharedInstance.appColor,  action: { () in
            // MARK: Clear all user default
            let mobileparam = MobileParam(mobileNo: self.phoneTextfield.text ?? "", countryCode: self.resident)
            PhoneViewModel.MobileValidationAPIRequest(with: mobileparam, controller: self, boolLoaderEnable: true) { Response in
                switch Response {
                case .failure(let error):
                    utilsClass.sharedInstance.debugprint(message: error)
                case .success(let result):
                    if result.status?.status == 204{
                        let sign = ConfirmEmailPhoneViewController.loadFromNib()
                        sign.firstName = self.firstName
                        sign.lastName = self.lastName
                        sign.mobileCode = self.countryLbl.text ?? TextConstant.sharedInstance.SEmpty
                        sign.mobile = "\(self.phoneTextfield.text ?? TextConstant.sharedInstance.SEmpty)"
                        sign.email = self.email
                        sign.resident = self.resident
                        self.navigationController?.pushViewController(sign, animated: true)

                        
//                        PhoneViewModel.RegisterAPIRequest(with: registerparam, controller: self, boolLoaderEnable: true) { Response in
//                            switch Response {
//                            case .failure(let error):
//                                utilsClass.sharedInstance.debugprint(message: error)
//                            case .success(let result):
//                                if result.status?.status == 200 {
//                                    UserDefaultModule.shared.setUserID(
//                                        userID: result.entity?.userID ?? "")
//                                    UserDefaultModule.shared.setUserResident(resident: result.entity?.resident ?? "")
//                                    UserDefaultModule.shared.setUseremail(email: result.entity?.emailID ?? "")
//                                    UserDefaultModule.shared.setUserResident(resident: result.entity?.resident ?? "")
//                                    if let userDefaults = UserDefaults(suiteName: "group.com.obs.travelpro") {
//                                        userDefaults.set(result.entity?.userID ?? "", forKey: "user_id")
//                                    }
////                                    let sign = ConfirmEmailPhoneViewController.loadFromNib()
////                                    sign.firstName = self.firstName
////                                    sign.lastName = self.lastName
////                                    sign.mobileCode = self.countryLbl.text ?? TextConstant.sharedInstance.SEmpty
////                                    sign.mobile = "\(self.phoneTextfield.text ?? TextConstant.sharedInstance.SEmpty)"
////                                    sign.email = self.email
//                                    UserDefaultModule.shared.setEmailID(userID: self.email)
//                                    self.navigationController?.pushViewController(sign, animated: true)
//
//                                } else {
//                                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: result.status?.message ?? "", image: UIImage(named: "Notification") ?? nil,theme: .default)
//                                }
//                            }
//                        }
                        
                    } else {
                        utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: result.status?.message ?? "", image: UIImage(named: "Notification") ?? nil,theme: .default)
                    }
                }
            }
            
        }))
        self.present(alertVC, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func skipButtonAction(_ sender: UIButton) {
        let sign = ConfirmEmailPhoneViewController.loadFromNib()
        sign.firstName = self.firstName
        sign.lastName = self.lastName
        sign.mobileCode = ""
        sign.mobile = ""
        sign.email = self.email
        sign.resident = ""
        self.navigationController?.pushViewController(sign, animated: true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func countrybtnAction(_sender : UIButton) {
        let countryPicker = CountryCodePickerViewController()
        countryPicker.selectedCountry = "IN"
        countryPicker.isHiddenCountryCode = false
        countryPicker.delegate = self
        self.present(countryPicker, animated: true)
    }

    //MARK: - UnitTestcase
    func uniTestcase() {
        self.skipButtonAction(UIButton())
    }
}
extension PhoneNumViewController: CountryCodePickerDelegate {
    func countryPicker(didSelect country: Country) {
        print(country.localizedName)
        self.countryLbl.text = "+" + country.phoneCode
        self.countryImageView.text = country.isoCode.getFlag()
        self.resident = country.isoCode
    }
}
// MARK: UITextFieldDelegate
extension PhoneNumViewController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == phoneTextfield {
            var is_check : Bool
            let aSet = NSCharacterSet(charactersIn:"0123456789()- ").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            is_check = string == numberFiltered
            if is_check {
                let maxLength = 15
                let currentString: NSString = textField.text! as NSString
                let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
                if newString.length == 0 {
                    self.phoneAlertLbl.isHidden = false
                } else {
                    self.phoneAlertLbl.isHidden = true
                }
                is_check = newString.length <= maxLength
            }
            return is_check
        }
        return true
    }
}
