//
//  CreatePasswordViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 13/04/23.
//

import UIKit

enum PasswordStrength {
    case weak
    case average
    case strong
}

enum pageFrom {
    case signup
    case settings
}

class CreatePasswordViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var newPasswordTextfield: UITextField!
    @IBOutlet weak var resetPasswordButton: CustomButton!
    @IBOutlet weak var newPasswordAlrtLbl: UILabel!
    @IBOutlet weak var confirmPasswordAlrtLbl: UILabel!
    @IBOutlet weak var newPasswordeyeBtn: UIButton!
    @IBOutlet weak var confirmPasswordEyeBtn: UIButton!
    @IBOutlet weak var smilyImgView: UIImageView!
    @IBOutlet weak var strenghtLbl: UILabel!
    @IBOutlet weak var strengthDescLbl: UILabel!
    @IBOutlet weak var backBtnView: UIView!
    
    var createPasswordModel = CreatePasswordViewModel()
    var userNameId = String()
    var flowType = String()
    var email = String()
    var password = String()
    var passwordStrn: PasswordStrength?
    var navigationType: pageFrom?
    
    var firstName = String()
    var lastName = String()
    var mobile = String()
    var mobileCode = String()
    var userType = String()
    var resident = String()
    var isVerifiedEmail = Bool()

    // MARK: - Properties
    
    // MARK: - View life cycle
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        newPasswordTextfield.addPlaceholderText(confirm_password_localize.new_password_placeholder, color: UIColor(named: "grayText"))
        confirmPasswordTextfield.addPlaceholderText(confirm_password_localize.confirm_password_placeholder, color: UIColor(named: "grayText"))
        smilyImgView.image = nil
        strenghtLbl.text = ""
        strengthDescLbl.text = ""
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        setupLocalizeTexts()
//        if self.navigationType == .settings {
            self.navigationController?.hidesBottomBarWhenPushed = true
            self.navigationController?.tabBarController?.tabBar.isHidden = true
//        }
    }
    
    // MARK: - Private methods
    
    /// SetupLocalizeTexts
    private func setupLocalizeTexts() {
        titleLabel.text = confirm_password_localize.title
        descriptionLabel.text = confirm_password_localize.Description
        newPasswordTextfield.placeholder = confirm_password_localize.new_password_placeholder
        confirmPasswordTextfield.placeholder = confirm_password_localize.confirm_password_placeholder
        resetPasswordButton.setTitle(confirm_password_localize.confirm, for: .normal)
    }
    
    private func registerAndConfirmPasswordAPI() {
        let registerparam = RegisterParam(firstName: self.firstName, lastName: self.lastName, mobileNo: self.mobile, userType: "1", countryCode: self.mobileCode , email: self.userNameId, resident: self.resident, verifiedStatus: self.isVerifiedEmail)
        PhoneViewModel.RegisterAPIRequest(with: registerparam, controller: self, boolLoaderEnable: true) { Response in
            switch Response {
            case .failure(let error):
                utilsClass.sharedInstance.debugprint(message: error)
            case .success(let result):
                if result.status?.status == 200 {
                    UserDefaultModule.shared.setUserID(
                        userID: result.entity?.userID ?? "")
                    UserDefaultModule.shared.setUserResident(resident: result.entity?.resident ?? "")
                    UserDefaultModule.shared.setUseremail(email: result.entity?.emailID ?? "")
                    UserDefaultModule.shared.setUserResident(resident: result.entity?.resident ?? "")
                    UserDefaultModule.shared.setUserName(userID: "\(result.entity?.firstName ?? "") \(result.entity?.lastName ?? "")")
                    UserDefaultModule.shared.set("true", forKey: "loginNewAccount")
                    if let userDefaults = UserDefaults(suiteName: "group.com.obs.travelpro") {
                        userDefaults.set(result.entity?.userID ?? "", forKey: "user_id")
                    }
                    UserDefaultModule.shared.setEmailID(userID: self.email)
                    
                    self.createPasswordModel.CreatePasswordApi(email: self.userNameId, password: self.newPasswordTextfield.text ?? "", confirmPassword: self.confirmPasswordTextfield.text ?? "", self.view, enableLoader: true) { response in
                        
                        if response.status?.status == 200 {
                            let alertVC = PMAlertController(title:"", description: response.status?.message, image: UIImage(named: "success-msg-face-icon"), style: .walkthrough)
                            alertVC.alertDescription.textColor = Constant.sharedInstance.appColor
                            alertVC.alertTitle.textColor = Constant.sharedInstance.appColor
                            alertVC.addAction(PMAlertAction(title: "Ok", style: .default, backgroundColor: UIColor.white,buttonTitleColor: Constant.sharedInstance.appColor,  action: { () in
                                let sign = PrivacyViewControllerViewController.loadFromNib()
                                sign.email = self.userNameId
                                sign.password = self.newPasswordTextfield.text ?? ""
                                self.navigationController?.pushViewController(sign, animated: true)
                            }))
                            self.present(alertVC, animated: true, completion: nil)
                        } else {
                            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: response.status?.message ?? "", image: UIImage(named: "Notification") ?? nil,theme: .default)
                        }
                    } onFailure: { error in
                        print(error)
                    }
                    
                } else {
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: result.status?.message ?? "", image: UIImage(named: "Notification") ?? nil,theme: .default)
                }
            }
        }
    }
    
    private func createPasswordAPI() {
        self.createPasswordModel.CreatePasswordApi(email: userNameId, password: newPasswordTextfield.text ?? "", confirmPassword: confirmPasswordTextfield.text ?? "", self.view, enableLoader: true) { response in
            
            if response.status?.status == 200 {
                let alertVC = PMAlertController(title:"", description: response.status?.message, image: UIImage(named: "success-msg-face-icon"), style: .walkthrough)
                alertVC.alertDescription.textColor = Constant.sharedInstance.appColor
                alertVC.alertTitle.textColor = Constant.sharedInstance.appColor
                alertVC.addAction(PMAlertAction(title: "Ok", style: .default, backgroundColor: UIColor.white,buttonTitleColor: Constant.sharedInstance.appColor,  action: { () in
                    if self.flowType == "Settings" {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.setLoginViewcontroller()
                    }
                }))
                self.present(alertVC, animated: true, completion: nil)
            } else {
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: response.status?.message ?? "", image: UIImage(named: "Notification") ?? nil,theme: .default)
            }
        } onFailure: { error in
            print(error)
        }
    }
    
    // MARK: - User interactions
    
    @IBAction func resetPasswordAction(_ sender: Any) {
        
        self.newPasswordAlrtLbl.isHidden = true
        self.confirmPasswordAlrtLbl.isHidden = true
        
        guard let newPassword = self.newPasswordTextfield.text, let confirmPassword = self.confirmPasswordTextfield.text, newPassword == confirmPassword else {
            self.confirmPasswordAlrtLbl.text = confirm_password_localize.Not_same_password
            return self.confirmPasswordAlrtLbl.isHidden = false
        }
        
        guard self.newPasswordTextfield.isValidPassword() else {
            return self.newPasswordAlrtLbl.isHidden = false
        }
        
        guard confirmPasswordTextfield.isValidPassword() else {
            return self.confirmPasswordAlrtLbl.isHidden = false
        }
        
        guard passwordStrn == .strong else {
            return
        }
        
        switch self.flowType {
        case "Signup":
            registerAndConfirmPasswordAPI()
        default:
            createPasswordAPI()
        }
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getPasswordStrength(_ password: String) -> PasswordStrength {
        
       
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^\\da-zA-Z]).{8,15}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", regex)
        if !passwordTest.evaluate(with: password) {
            return .weak
        }
        var score = 0
        _ = "abcdefghijklmnopqrstuvwxyz"
        _ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        _ = "0123456789"
        let symbols = "!@#$%^&*()_-+=~`|]}[{':;?/.,<>"
        // Add points for password length
        score += min(password.count, 12) * 2
        // Add points for different character types
        if password.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil {
            score += 2
        }
        if password.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil {
            score += 2
        }
        if password.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
            score += 2
        }
        if password.rangeOfCharacter(from: CharacterSet(charactersIn: symbols)) != nil {
            score += 2
        }
        // Deduct points for common words or patterns
        let commonWords = ["password", "123456", "qwerty", "letmein", "admin", "welcome", "monkey", "login", "abc123", "solo"]
        let commonPatterns = ["123", "abc", "qwe", "asd", "zxc", "111", "222", "333", "444", "555", "666", "777", "888", "999", "000"]
        if commonWords.contains(password.lowercased()) {
            score -= 5
        }
        if commonPatterns.contains(where: password.lowercased().contains) {
            score -= 5
        }
        // Determine password strength based on score
        switch score {
        
        case 0..<10:
            return .weak
        case 10..<20:
            return .average
        default:
            return .strong
        }
    }


    
    
    @IBAction func newPasswordEyeTapped(_ sender: Any) {
        if(self.newPasswordTextfield.isSecureTextEntry == true){
            self.newPasswordTextfield.isSecureTextEntry = false
            self.newPasswordeyeBtn.setImage(UIImage(named: "eyeclose"), for: .normal)
        }else{
            self.newPasswordTextfield.isSecureTextEntry = true
            self.newPasswordeyeBtn.setImage(UIImage(named: "eyeopen"), for: .normal)
        }
    }
    
    @IBAction func confirmPasswordEyeTapped(_ sender: Any) {
        if(self.confirmPasswordTextfield.isSecureTextEntry == true){
            self.confirmPasswordTextfield.isSecureTextEntry = false
            self.confirmPasswordEyeBtn.setImage(UIImage(named: "eyeclose"), for: .normal)
        }else{
            self.confirmPasswordTextfield.isSecureTextEntry = true
            self.confirmPasswordEyeBtn.setImage(UIImage(named: "eyeopen"), for: .normal)
        }
    }
    
    // MARK: - UnitTestcase
    
    func unitTestcase() {
        self.registerAndConfirmPasswordAPI()
        self.createPasswordAPI()
        self.resetPasswordAction(UIButton())
        let pass1 = self.getPasswordStrength("Test@1234")
        passwordStrengthUIChanges(strength: pass1)
        let pass2 = self.getPasswordStrength("Tes1234")
        passwordStrengthUIChanges(strength: pass2)
        let pass3 = self.getPasswordStrength("Te")
        passwordStrengthUIChanges(strength: pass3)
        newPasswordEyeTapped(UIButton())
        confirmPasswordEyeTapped(UIButton())
        let text = UITextField(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        text.text = "test case"
        newPasswordTextfield = text
        textFieldDidEndEditing(newPasswordTextfield)
        let _ = textField(newPasswordTextfield, shouldChangeCharactersIn: NSRange(), replacementString: "test")
    }


}

extension CreatePasswordViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == newPasswordTextfield {
            if newPasswordTextfield.text == "" {
                let strength = self.getPasswordStrength(newPasswordTextfield.text ?? "")
                self.passwordStrengthUIChanges(strength: strength)
                smilyImgView.image = nil
                strenghtLbl.text = ""
                strengthDescLbl.text = ""
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let whitespaceSet = NSCharacterSet.whitespaces
        if let _ = textField.text?.rangeOfCharacter(from: whitespaceSet) {
            textField.text! = textField.text!.replacingOccurrences(of: " ", with: "")
                return false
            }
        if let texts = textField.text {
            let totalString = texts + string
            
            if totalString.count < 16 {
                let strength = self.getPasswordStrength(totalString)
                self.passwordStrengthUIChanges(strength: strength)
            } else {
                let strength = self.getPasswordStrength(texts)
                self.passwordStrengthUIChanges(strength: strength)
            }
            return totalString.count < 16
        }
        return false
    }
    
    func passwordStrengthUIChanges(strength: PasswordStrength) {
        passwordStrn = strength
        switch strength {
        case .average:
            self.smilyImgView.image = UIImage(named: "Mail Smiley Straight Face")
            self.strenghtLbl.text = "Average"
            self.strenghtLbl.textColor = UIColor(named: "AverageStrengthColor")
            self.strengthDescLbl.text = "Your password is easily guessable. You can do better."
        case .weak:
            self.smilyImgView.image = UIImage(named: "Mail Smiley Sad Face")
            self.strenghtLbl.text = "Weak"
            self.strenghtLbl.textColor = UIColor(named: "WeakStrengthColor")
            self.strengthDescLbl.text = "Your password is easily guessable. You can do better."
        case .strong:
            self.smilyImgView.image = UIImage(named: "Mail Smiley Happy Face")
            self.strenghtLbl.text = "Strong"
            self.strenghtLbl.textColor = UIColor(named: "btnLoginColor")
            self.strengthDescLbl.text = "Your password looks great."
        }
    }
}
