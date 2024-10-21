//
//  EditProfileViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 13/04/23.
//

import UIKit
import Alamofire
import SDWebImage
class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    // MARK: - Properties
    var viewProfileResponseDetails : ViewProfileModel? = nil
    var editProfileViewModel = EditProfilePageViewModel()
    let datePicker = UIDatePicker()
    var genderArray:[String] = ["Male","Female"]
    var selectedProfileURL : String = ""
    // MARK: - IBOutlets
    var getAreaOfInterestData = ["India","India","America and information"]
    @IBOutlet weak var updateButtonLabel: CustomButton!
    @IBOutlet weak var firstNameAlrtLbl: UILabel!
    @IBOutlet weak var lastNameAlrtLbl: UILabel!
    @IBOutlet weak var emailAlrtLbl: UILabel!
    @IBOutlet weak var aboutYouAlrtLbl: UILabel!
    @IBOutlet weak var addressAlrtLbl: UILabel!
    @IBOutlet weak var phoneAlrtLbl: UILabel!
    @IBOutlet weak var countryCodeAlrtLbl: UILabel!
    @IBOutlet weak var genderAlrtLbl: UILabel!
    @IBOutlet weak var dobAlrtLbl: UILabel!
    @IBOutlet weak var firstNameTxtFld: FloatingTF!
    @IBOutlet weak var lastNameTxtFld: FloatingTF!
    @IBOutlet weak var emailTxtFld: FloatingTF!
    @IBOutlet weak var aboutTxtFld: FloatingTF!
    @IBOutlet weak var countryTxtFld: FloatingTF!
    @IBOutlet weak var phoneTxtFld: FloatingTF!
    @IBOutlet weak var dobTxtFld: FloatingTF!
    @IBOutlet weak var genderTxtFld: DropDown!
    @IBOutlet weak var addressTxtFld: FloatingTF!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var btnCountry: UIButton!
    @IBOutlet weak var btnCountryPicker: UIButton!
    var countryPickerisResident : Bool?
    @IBOutlet weak var countryArrowDropDown: DropDown!
    // MARK: - View life cycle
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var preferenceCollection: UICollectionView!
    @IBOutlet weak var preferenceCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var totalHeight: NSLayoutConstraint!
    var selectedIndex : [String] = [String]()
   
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        getAreaOfInterestData.removeAll()
        genderTxtFld.checkMarkEnabled = false
        genderTxtFld.isSearchEnable = false
        genderTxtFld.didSelect{(selectedText , index , id) in
            self.genderTxtFld.text = selectedText
            self.genderAlrtLbl.isHidden = true
        }
        genderTxtFld.arrowSize = 15
        genderTxtFld.listHeight = 200
        genderTxtFld.optionArray = genderArray
        dobTxtFld.addPlaceholderText("Date of Birth", color: UIColor(named: "grayText"))
        firstNameTxtFld.addPlaceholderText("First Name", color: UIColor(named: "grayText"))
        lastNameTxtFld.addPlaceholderText("Last Name", color: UIColor(named: "grayText"))
        aboutTxtFld.addPlaceholderText("You are a", color: UIColor(named: "grayText"))
        addressTxtFld.addPlaceholderText("Nationality", color: UIColor(named: "grayText"))
        showDatePicker()
        self.firstNameTxtFld.delegate = self
        self.lastNameTxtFld.delegate = self
        self.aboutTxtFld.delegate = self
        self.phoneTxtFld.delegate = self
        self.countryTxtFld.delegate = self
    }
    @IBAction func btnProfileAction(_sender : UIButton) {
        
        openGallary()
    }
    @IBAction func btnCountryPickerAction(_sender : UIButton) {
        let alertVC = PMAlertController(title:"", description: "Are you sure, you want to update the Tax Resident Country?", image: UIImage(named: "Notification1"), style: .walkthrough)
        alertVC.alertDescription.textColor = Constant.sharedInstance.appColor
        alertVC.alertTitle.textColor = Constant.sharedInstance.appColor
        alertVC.addAction(PMAlertAction(title: "Ok", style: .default, backgroundColor: UIColor.white,buttonTitleColor: Constant.sharedInstance.appColor,  action: { () in
            self.countryPickerisResident = true
            let countryPicker = CountryCodePickerViewController()
            countryPicker.isHiddenCountryCode = true
            countryPicker.delegate = self
            self.present(countryPicker, animated: true)
        }))
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .default, backgroundColor: UIColor.white,buttonTitleColor: Constant.sharedInstance.appColor,  action: { () in
            
        }))
        self.present(alertVC, animated: true, completion: nil)
       
    }
    func openGallary(){
        DispatchQueue.main.async {
            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.imagePicker.allowsEditing = true
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if info[UIImagePickerController.InfoKey.mediaType]as? String == "public.image" {
            var image = UIImage()
            if imagePicker.sourceType == UIImagePickerController.SourceType.camera{
                // MARK: Choose camera
                image = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage)!
                let docDir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let imageUniqueName : Int64 = Int64(NSDate().timeIntervalSince1970 * 1000);
                if let _ = docDir?.appendingPathComponent("\(imageUniqueName).png") {
                    // selectedImageUrlForProfile = filePath
                    
                }
            }
            else {
                // MARK: Choose gallery
                image = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage)!
                self.profileImage.image = image
                self.profileImage.contentMode = .scaleAspectFill
                self.profileImage.roundCorner()
                self.callUpdateProfile()
                
            }
            picker.dismiss(animated: true)
        }
    }
    
    func callUpdateProfile(){
        Loader.startLoading(self.profileImage, userIneration: false)
        AWSManager.shared.uploadImageToAWS(uploadImage: self.profileImage.image, viewController: self) { uploadUrl, statusCode in
            self.selectedProfileURL = uploadUrl
            Loader.stopLoading(self.profileImage)
        }

    }
 
    // MARK: Getting document
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }


    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        setupLocalizeTexts()
      //  self.registerCells()
    }
    func registerCells() {
        preferenceCollection.register(UINib(nibName: "PerferenceCell", bundle: nil), forCellWithReuseIdentifier: "PerferenceCell")
        preferenceCollection.delegate = self
        preferenceCollection.dataSource = self
        preferenceCollection.allowsMultipleSelection = false
        self.preferenceCollection.reloadData()
        self.preferenceCollection.layoutIfNeeded()
        preferenceCollectionHeight.constant =  self.preferenceCollection.contentSize.height + 30
       // self.totalHeight.constant = 950 + preferenceCollectionHeight.constant
    }
    // MARK: - Private methods
    
    /// SetupLocalizeTexts
    private func setupLocalizeTexts() {
        updateButtonLabel.setTitle(edit_profile_localize.update_now, for: .normal)
        firstNameTxtFld.placeholder = edit_profile_localize.first_name
        lastNameTxtFld.placeholder = edit_profile_localize.last_name
        emailTxtFld.placeholder = edit_profile_localize.email
        aboutTxtFld.placeholder = edit_profile_localize.you_are
        countryTxtFld.placeholder = edit_profile_localize.country
        phoneTxtFld.placeholder = edit_profile_localize.phone
        dobTxtFld.placeholder = edit_profile_localize.dateOfBirth
        genderTxtFld.placeholder = edit_profile_localize.gender
        addressTxtFld.placeholder = edit_profile_localize.residents
        self.firstNameTxtFld.text = self.viewProfileResponseDetails?.entity?.userID?.firstName
        self.lastNameTxtFld.text = self.viewProfileResponseDetails?.entity?.userID?.lastName
        self.emailTxtFld.text = self.viewProfileResponseDetails?.entity?.userID?.emailID
        self.countryTxtFld.text = self.viewProfileResponseDetails?.entity?.userID?.countryCode
        self.phoneTxtFld.text = self.viewProfileResponseDetails?.entity?.userID?.mobileNo
        self.dobTxtFld.text = self.viewProfileResponseDetails?.entity?.dob
       // self.addressTxtFld.text = self.viewProfileResponseDetails?.entity?.resident
        self.genderTxtFld.text = self.viewProfileResponseDetails?.entity?.userID?.gender
        if self.viewProfileResponseDetails?.entity?.userID?.socialAccount == true
        {
            if self.viewProfileResponseDetails?.entity?.userID?.mobileVerification == false {
//                self.phoneTxtFld.isUserInteractionEnabled = true
//                self.countryTxtFld.isUserInteractionEnabled = true
//                self.btnCountry.isUserInteractionEnabled = true
//                self.btnCountry.isHidden = false
            } else {
//                self.btnCountry.isHidden = true
//                self.countryArrowDropDown.isUserInteractionEnabled = false
            }
        } else {
//            self.btnCountry.isHidden = true
//            self.btnCountry.isUserInteractionEnabled = false
//            self.countryArrowDropDown.isUserInteractionEnabled = false
        }
        if let profileImage = self.viewProfileResponseDetails?.entity?.profileImage {
            self.selectedProfileURL = profileImage
            UserDefaultModule.shared.setProfilePic(userID: AWSConfig.kAWSBaseURL + AWSConfig.kstaticfolderPath + profileImage)
            utilsClass.sharedInstance.DebugPrint(strLog: AWSConfig.kAWSBaseURL + profileImage)
            self.profileImage.sd_setImage(with: URL(string: utilsClass.sharedInstance.checkNullvalue(passedValue: AWSConfig.kAWSBaseURL + profileImage)), placeholderImage: UIImage.init(named: "profile-default-icon"), completed: nil)
            self.profileImage.contentMode  = .scaleAspectFill
        }
        self.phoneTxtFld.delegate = self
        self.profileImage.roundCorner()
        _ = self.viewProfileResponseDetails?.entity?.resident
//        let fullNameArr = residentData?.components(separatedBy: ",")
//        if fullNameArr?.count ?? 0 > 0{
//            for iData in 0 ..< (fullNameArr?.count ?? 0) {
//                self.getAreaOfInterestData.append(fullNameArr?[iData] ?? "")
//            }
//        }
//        if self.getAreaOfInterestData.count > 0 {
//            self.registerCells()
//        }

    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -150, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        
       //ToolBar
       let toolbar = UIToolbar();
       toolbar.sizeToFit()
       let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

     toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        dobTxtFld.inputAccessoryView = toolbar
        dobTxtFld.inputView = datePicker
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
     }

      @objc func donedatePicker(){

       let formatter = DateFormatter()
        //yyyy-MM-dd HH:mm:ss
       formatter.dateFormat = "dd/MM/yyyy"
          dobTxtFld.text = formatter.string(from: datePicker.date)
          self.dobAlrtLbl.isHidden = true
       self.view.endEditing(true)
     }

    @IBAction func countrybtnAction(_sender : UIButton) {
        countryPickerisResident = false
        let countryPicker = CountryCodePickerViewController()
        countryPicker.isHiddenCountryCode = false
        countryPicker.selectedCountry = "IN"
        countryPicker.delegate = self
        self.present(countryPicker, animated: true)
    }
     @objc func cancelDatePicker(){
        self.view.endEditing(true)
      }
    // MARK: - User interactions
    
    // MARK: - Network requests#imageLiteral(resourceName: "simulator_screenshot_1BB2CD84-D01D-4651-B303-29807B42DF37.png")
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateBtnTapped(_ sender: Any) {
        var errorCount = 0
        
        if self.firstNameTxtFld.text?.count ?? 0 < 3 {
            self.firstNameAlrtLbl.isHidden = false
            errorCount += 1
        }
        
        if self.lastNameTxtFld.text?.count ?? 0 < 1 {
            self.lastNameAlrtLbl.isHidden = false
            errorCount += 1
        }
        
        if self.emailTxtFld.text?.count ?? 0 < 5 || !self.emailTxtFld.isValidEmail() {
            self.emailAlrtLbl.isHidden = false
            errorCount += 1
        }
        
        if self.aboutTxtFld.text?.count ?? 0 < 5 {
            self.aboutYouAlrtLbl.isHidden = false
            errorCount += 1
        }
        
        if self.countryTxtFld.text?.count ?? 0 > 0 {
            if self.phoneTxtFld.text?.count ?? 0 < 5 {
                self.phoneAlrtLbl.isHidden = false
                errorCount += 1
            }
        }
        
        if self.phoneTxtFld.text?.count ?? 0 > 0 {
            if self.countryTxtFld.text?.count == 0 {
                self.countryCodeAlrtLbl.isHidden = false
                errorCount += 1
            }
        }
        
//        if self.phoneTxtFld.text?.count ?? 0 < 5 {
//            self.phoneAlrtLbl.isHidden = false
//            errorCount += 1
//        }
//
//        if self.dobTxtFld.text == "" {
//            self.dobAlrtLbl.isHidden = false
//            errorCount += 1
//        }
//
//        if self.genderTxtFld.text?.lowercased() != "male" && self.genderTxtFld.text?.lowercased() != "female" {
//            self.genderAlrtLbl.isHidden = false
//            errorCount += 1
//        }
        
//        if self.addressTxtFld.text?.count ?? 0 < 2 {
//            self.addressAlrtLbl.isHidden = false
//            errorCount += 1
//        }
        
        guard errorCount == 0 else {
            return
        }
//        var residentData = ""
//        if getAreaOfInterestData.count > 0 {
//            for iData in 0 ..< getAreaOfInterestData.count {
//                        if iData == 0 {
//                            residentData = getAreaOfInterestData[iData]
//                        } else {
//                            residentData = residentData + "," + getAreaOfInterestData[iData]
//                        }
//            }
//        }
        let params = EditProfileParam.init(firstName: self.firstNameTxtFld.text ?? "", lastName: self.lastNameTxtFld.text ?? "", dob: self.dobTxtFld.text ?? "", email: self.emailTxtFld.text ?? "", mobileNo: self.phoneTxtFld.text ?? "", profileImage: self.selectedProfileURL, resident: self.viewProfileResponseDetails?.entity?.resident ?? "", gender: self.genderTxtFld.text ?? "", countryCode: self.countryTxtFld.text ?? "")
        EditProfilePageViewModel.EditProfileAPIRequest(with: params, controller: self, boolLoaderEnable: true) { Response in
            switch Response {
            case .failure(let error):
                utilsClass.sharedInstance.debugprint(message: error)
            case .success(let result):
                UserDefaultModule.shared.setUserName(userID: "\(result.entity?.userID?.firstName ?? "") \(result.entity?.userID?.lastName ?? "")")
                UserDefaultModule.shared.setProfilePic(userID: AWSConfig.kAWSBaseURL + AWSConfig.kstaticfolderPath + (result.entity?.profileImage ?? ""))
                utilsClass.sharedInstance.debugprint(message: result)
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Your profile updated successfully", image: UIImage(named: "Notification") ?? nil,theme: .default)
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
    }
    
    //MARK: - UnitTestcase
    
    func unitTestcase() {
        self.btnProfileAction(_sender: UIButton())
        self.btnCountryPickerAction(_sender: UIButton())
        self.openGallary()
        self.callUpdateProfile()
        _ = self.getDocumentsDirectory()
        self.registerCells()
        self.donedatePicker()
        self.countrybtnAction(_sender: UIButton())
        
        firstNameTxtFld.text = "test"
        lastNameTxtFld.text = "et"
        emailTxtFld.text = "test"
        aboutTxtFld.text = "test"
        phoneTxtFld.text = "1234"
        dobTxtFld.text = ""
        genderTxtFld.text = "male"
        updateBtnTapped(UIButton())
        countryPicker(didSelect: Country(isoCode: "IN"))
        
        phoneTxtFld.text = "1234567890"
        _ = textField(phoneTxtFld, shouldChangeCharactersIn: NSRange(location: 1, length: 1), replacementString: "")
        firstNameTxtFld.text = "first"
        _ = textField(firstNameTxtFld, shouldChangeCharactersIn: NSRange(location: 1, length: 1), replacementString: "")
        lastNameTxtFld.text = "last"
        _ = textField(lastNameTxtFld, shouldChangeCharactersIn: NSRange(location: 1, length: 1), replacementString: "")
        let index = IndexPath(row: 0, section: 0)
        _ = collectionView(preferenceCollection, layout: preferenceCollection.collectionViewLayout, sizeForItemAt: index)
        self.backBtnTapped(UIButton())
    }
    
}
extension EditProfileViewController: CountryCodePickerDelegate {
    func countryPicker(didSelect country: Country) {
        print(country.localizedName)
        if countryPickerisResident == false {
            self.countryTxtFld.text = "+" + country.phoneCode
        }
        if getAreaOfInterestData.contains(country.isoCode){
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Country Already Added", image: UIImage(named: "Notification") ?? nil,theme: .default)
        } else {
            getAreaOfInterestData.append(country.isoCode)
            registerCells()
        }
        let totalStr = self.countryTxtFld.text ?? ""
        self.countryCodeAlrtLbl.isHidden = (totalStr.count > 0)
    }
    @objc func cellTappedMethod(_ sender:AnyObject){
         print("you tap image number: \(sender.view.tag)")
        self.getAreaOfInterestData.remove(at: sender.view?.tag ?? 0)
        self.preferenceCollection.reloadData()
        
    }
}
// MARK: UITextFieldDelegate
extension EditProfileViewController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == phoneTxtFld {
            var is_check : Bool
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            is_check = string == numberFiltered
            if is_check {
                let maxLength = 15
                let currentString: NSString = textField.text! as NSString
                let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
                is_check = newString.length <= maxLength
            }
            self.phoneAlrtLbl.isHidden = (self.phoneTxtFld.text!+string).count > 5
            return is_check
        }
        if textField == firstNameTxtFld {
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
            if self.firstNameTxtFld.text?.count ?? 0 < 2 {
                self.firstNameAlrtLbl.isHidden = false
                self.firstNameAlrtLbl.text = "First Name should have Minimum 3 Character"
            } else {
                self.firstNameAlrtLbl.isHidden = true
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
        
        if textField == lastNameTxtFld {
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
            if self.lastNameTxtFld.text?.count ?? 0 < 1 {
                self.lastNameAlrtLbl.isHidden = false
                self.lastNameAlrtLbl.text = "Last Name should have Minimum 1 Character"
            } else {
                self.lastNameAlrtLbl.isHidden = true
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
        
        if textField == self.aboutTxtFld {
            let totalStr = self.aboutTxtFld.text!+string
            self.aboutYouAlrtLbl.isHidden = (totalStr.count > 5)
        }
        
        if textField == self.phoneTxtFld {
            let totalStr = self.aboutTxtFld.text!+string
            self.phoneAlrtLbl.isHidden = (totalStr.count > 9)
        }
        return true
    }
}
// MARK:- UICollectionView Delegate and Data source
extension EditProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    // MARK:- collectionViewLayout
    /*
     Adding the size of the collection view cell if it is in list view we are applying the size inside the if condition or if it is a grid view the properties inside the else condition is initilized
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellWidth  : Double = 0.0
        if let country = CountryManager.shared.getCountries().first(where: { $0.isoCode == self.getAreaOfInterestData[indexPath.row] }) {
            let text = country.localizedName
             cellWidth = (text.size(withAttributes:[.font: Constant.sharedInstance.regularFont!]).width) + 50.0
            return CGSize(width: cellWidth, height: 40.0)
        }
       
        return CGSize(width: cellWidth, height: 40.0)
        
    }
    
    
    // MARK:- numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.getAreaOfInterestData.count
    }
    // MARK:- cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = preferenceCollection.dequeueReusableCell(withReuseIdentifier: "PerferenceCell", for: indexPath) as? PerferenceCell
        DispatchQueue.main.async {
            if let country = CountryManager.shared.getCountries().first(where: { $0.isoCode == self.getAreaOfInterestData[indexPath.row] }) {
                cell?.lblPerference.text = self.getAreaOfInterestData[indexPath.row].getFlag() + " " + country.localizedName
               
            }
          //  cell?.imgFlag.text = self.getAreaOfInterestData[indexPath.row].getFlag()
            cell?.layer.backgroundColor = UIColor.white.cgColor
            cell?.layer.borderColor = Constant.sharedInstance.borderlineColor.cgColor
            cell?.lblPerference.textColor = Constant.sharedInstance.borderlineColor
            cell?.layer.borderWidth = 1.0
            cell?.layer.cornerRadius = 7
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.cellTappedMethod(_:)))

            cell?.imgFlag.isUserInteractionEnabled = true
            cell?.imgFlag.tag = indexPath.row
            cell?.imgFlag.addGestureRecognizer(tapGestureRecognizer)
        }
        return cell ?? UICollectionViewCell()
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
}
