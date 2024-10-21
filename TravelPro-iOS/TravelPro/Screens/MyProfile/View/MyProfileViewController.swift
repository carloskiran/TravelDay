//
//  MyProfileViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 12/04/23.
//

import UIKit
import KFGradientProgressView
import SDWebImage

class MyProfileViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - IBOutlets
    @IBOutlet weak var userHiLabel: UILabel!
    @IBOutlet weak var emailVerifiedButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var editButton: UIButton!
//    @IBOutlet weak var profileProgressView: UIProgressView!
    @IBOutlet weak var editTitleLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
    @IBOutlet weak var genderDOBLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    let viewprofile = MyProfileViewModel()
    let generateotp = ForgotPasswordViewModel()
    // MARK: - View life cycle
    var viewProfileResponseDetails : ViewProfileModel? = nil
    // MARK: - ViewDidLoad
    @IBOutlet weak var preferenceCollection: UICollectionView!
    var getAreaOfInterestData = ["India","India","America and information"]
    override func viewDidLoad() {
        super.viewDidLoad()
        getAreaOfInterestData.removeAll()
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        setupLocalizeTexts()
        viewProfileApi(isFromViewWillAppear: true)
    }
    func registerCells() {
        preferenceCollection.register(UINib(nibName: "PerferenceCell", bundle: nil), forCellWithReuseIdentifier: "PerferenceCell")
        preferenceCollection.delegate = self
        preferenceCollection.dataSource = self
        preferenceCollection.allowsMultipleSelection = false
        self.preferenceCollection.reloadData()
        self.preferenceCollection.layoutIfNeeded()
        let lastItemIndex = IndexPath(item: self.getAreaOfInterestData.count-1, section: 0)
        self.preferenceCollection.scrollToItem(at: lastItemIndex, at: .right, animated: true)
        //    preferenceCollectionHeight.constant =  self.preferenceCollection.contentSize.height + 30
        
    }
    
    func viewProfileApi(isFromViewWillAppear:Bool) {
        let usertypeParam = forceUpdateParam.init(userId: "")
        MyProfileViewModel.getForceUpdateDetails(with: usertypeParam, controller: self, boolLoaderEnable: true) {  Response in
            switch Response {
            case .failure(let error):
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error.description, image: nil,theme: .default)
                utilsClass.sharedInstance.debugprint(message: "\(error)")
            case .success(let result):
                utilsClass.sharedInstance.debugprint(message: "\(result)")
                self.viewProfileResponseDetails = result
                print(">>>>>>\(result.entity?.resident ?? "")")
                UserDefaultModule.shared.setUserName(userID:"\(result.entity?.userID?.firstName ?? "") \(result.entity?.userID?.lastName ?? "")")

                if result.entity?.userID?.emailVerification == false {
                    self.emailVerifiedButton.setTitle("Unverified", for: .normal)
                    self.emailVerifiedButton.setTitleColor(UIColor.red, for: .normal)

                } else {
                    self.emailVerifiedButton.setTitle("Verified", for: .normal)
                    self.emailVerifiedButton.setTitleColor(UIColor.green, for: .normal)
                }
//                if result.entity?.userID?.mobileVerification == false {
//                    self.phoneNumberVerifiedButton.setTitle("Unverified", for: .normal)
//                    self.phoneNumberVerifiedButton.setTitleColor(UIColor.red, for: .normal)
//                } else {
//                    self.phoneNumberVerifiedButton.setTitle("Verified", for: .normal)
//                    self.phoneNumberVerifiedButton.setTitleColor(UIColor.green, for: .normal)
//                }
                self.userHiLabel.text = "\(result.entity?.userID?.firstName ?? "") \(result.entity?.userID?.lastName ?? "")"
                self.emailLbl.text = result.entity?.userID?.emailID
                self.mobileLbl.text = result.entity?.userID?.mobileNo
                if let profileImage = result.entity?.profileImage {
                    UserDefaultModule.shared.setProfilePic(userID: AWSConfig.kAWSBaseURL + AWSConfig.kstaticfolderPath + profileImage)
                    utilsClass.sharedInstance.DebugPrint(strLog: AWSConfig.kAWSBaseURL + profileImage)
                    self.profileImage.sd_setImage(with: URL(string: utilsClass.sharedInstance.checkNullvalue(passedValue: AWSConfig.kAWSBaseURL + AWSConfig.kstaticfolderPath + profileImage)), placeholderImage: UIImage.init(named: "profile-default-icon"), completed: nil)
                    self.profileImage.contentMode  = .scaleAspectFill
                }
                
                self.profileImage.roundCorner()
                var profession1 : String?
                if let business = result.entity?.userID?.gender{
                    profession1 = business + " | "
                    
                }
                if let business = result.entity?.dob{
                    profession1 = (profession1 ?? "") + business
                }
                
                if profession1 != " | " {
                    self.genderDOBLbl.text = profession1
                }
              
                if isFromViewWillAppear {
                    let residentData = self.viewProfileResponseDetails?.entity?.userID?.resident
                    let fullNameArr = residentData?.components(separatedBy: ",")
                    if fullNameArr?.count ?? 0 > 0{
                        for iData in 0 ..< (fullNameArr?.count ?? 0) {
                            if !self.getAreaOfInterestData.contains(fullNameArr?[iData] ?? "") {
                                self.getAreaOfInterestData.append(fullNameArr?[iData] ?? "")
                            }
                        }
                    }
                    if self.getAreaOfInterestData.count > 0 {
                        UserDefaultModule.shared.setUserResident(resident: self.getAreaOfInterestData.last ?? "")
                        self.registerCells()
                    } else {
                        UserDefaultModule.shared.setUserResident(resident: "")
                    }
                }
            }
        }
    }
    
    func getAreaOfInterestArray() {
       
    }
    
    // MARK: - Private methods
    
    /// SetupLocalizeTexts
    private func setupLocalizeTexts() {
//        userHiLabel.text = my_profile_localize.hi_text
      //  emailVerifiedButton.setTitle(my_profile_localize.verify, for: .normal)
     //   phoneNumberVerifiedButton.setTitle(my_profile_localize.vertified, for: .normal)
     //   travelCountInfoLabel.text = my_profile_localize.trips
//        editButton.setTitle(my_profile_localize.edit_text, for: .normal)
        editTitleLbl.text = "Edit your details"
    }
    
    // MARK: - User interactions
    
    @IBAction func LogoutButtonAction(_ sender: UIButton) {
        
        let refreshAlert = UIAlertController(title: "LOGOUT", message: "Are you sure you want to log out?", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            UserDefaults.standard.removeObject(forKey: "selectedUser")
            UserDefaults.standard.removeObject(forKey: "usertype")
            UserDefaults.standard.removeObject(forKey: "userTypeid")
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            appdelegate?.logoutSession()
            appdelegate?.welcomeLandingpage()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    @IBAction func CountryAction(_ sender: UIButton) {
        if self.getAreaOfInterestData.contains(""), self.getAreaOfInterestData.count >= 3 {
            let alertVC = PMAlertController(title:"", description: "You can now add up to 2 tax resident countries.", image: UIImage(named: "Notification1"), style: .walkthrough)
            alertVC.alertDescription.textColor = Constant.sharedInstance.appColor
            alertVC.alertTitle.textColor = Constant.sharedInstance.appColor
            alertVC.addAction(PMAlertAction(title: "Ok", style: .default, backgroundColor: UIColor.white,buttonTitleColor: Constant.sharedInstance.appColor,  action: { () in
            }))
            self.present(alertVC, animated: true, completion: nil)
        } else if !self.getAreaOfInterestData.contains(""), self.getAreaOfInterestData.count >= 2 {
            let alertVC = PMAlertController(title:"", description: "You can now add up to 2 tax resident countries.", image: UIImage(named: "Notification1"), style: .walkthrough)
            alertVC.alertDescription.textColor = Constant.sharedInstance.appColor
            alertVC.alertTitle.textColor = Constant.sharedInstance.appColor
            alertVC.addAction(PMAlertAction(title: "Ok", style: .default, backgroundColor: UIColor.white,buttonTitleColor: Constant.sharedInstance.appColor,  action: { () in
            }))
            self.present(alertVC, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                let alertVC = PMAlertController(title:"", description: "Are you sure, you want to update the Tax Resident Country?", image: UIImage(named: "Notification1"), style: .walkthrough)
                alertVC.alertDescription.textColor = Constant.sharedInstance.appColor
                alertVC.alertTitle.textColor = Constant.sharedInstance.appColor
                alertVC.addAction(PMAlertAction(title: "Ok", style: .default, backgroundColor: UIColor.white,buttonTitleColor: Constant.sharedInstance.appColor,  action: { () in
                    let countryPicker = CountryCodePickerViewController()
                    countryPicker.isHiddenCountryCode = true
                    countryPicker.delegate = self
                    self.present(countryPicker, animated: true)
                }))
                alertVC.addAction(PMAlertAction(title: "Cancel", style: .default, backgroundColor: UIColor.white,buttonTitleColor: Constant.sharedInstance.appColor,  action: { () in
                    
                }))
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
        
    
    @IBAction func editButtonAction(_ sender: UIButton) {
            let sign = EditProfileViewController.loadFromNib()
            sign.viewProfileResponseDetails = self.viewProfileResponseDetails
            self.navigationController?.pushViewController(sign, animated: true)
        
    }
    @IBAction func unverifiedBtn(_ sender: UIButton) {
        if sender.titleLabel?.text == "Unverified" {
            
            let refreshAlert = UIAlertController(title: "", message: "Are you sure you want to Verify?", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [self] (action: UIAlertAction!) in
                generateotp.generateOTP(mobileNo: self.viewProfileResponseDetails?.entity?.userID?.mobileNo ?? "", email:"", countryCode: self.viewProfileResponseDetails?.entity?.userID?.countryCode ?? "", self.view, enableLoader: true) { response in
                    if response.status?.status == 200 {
                        let sign = ForgotPasswordMobileOtpViewController.loadFromNib()
                        sign.FlowType = "MyProfile"
                        sign.OTPType = "Mobile"
                        sign.userNameId = self.viewProfileResponseDetails?.entity?.userID?.mobileNo ?? ""
                        self.navigationController?.pushViewController(sign, animated: true)
                    } else {
                        utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: response.status?.message ?? TextConstant.sharedInstance.SEmpty, image: UIImage(named: "Notification") ?? nil,theme: .default)
                    }
                } onFailure: { error in
                    print(error)
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error.description, image: UIImage(named: "Notification") ?? nil,theme: .default)
                }
   
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        
        }
    }
    
    @IBAction func unverifiedEmailBtn(_ sender: UIButton) {
        if sender.titleLabel?.text == "Unverified" {
            
            let refreshAlert = UIAlertController(title: "", message: "Are you sure you want to Verify?", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [self] (action: UIAlertAction!) in
                generateotp.generateOTP(mobileNo: "", email: self.viewProfileResponseDetails?.entity?.userID?.emailID ?? "", countryCode: self.viewProfileResponseDetails?.entity?.userID?.countryCode ?? "", self.view, enableLoader: true) { response in
                    if response.status?.status == 200 {
                        let sign = ForgotPasswordMobileOtpViewController.loadFromNib()
                        sign.FlowType = "MyProfile"
                        sign.OTPType = "Email"
                        sign.userNameId = self.viewProfileResponseDetails?.entity?.userID?.emailID ?? ""
                        self.navigationController?.pushViewController(sign, animated: true)
                    } else {
                        utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: response.status?.message ?? TextConstant.sharedInstance.SEmpty, image: UIImage(named: "Notification") ?? nil,theme: .default)
                    }
                } onFailure: { error in
                    print(error)
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error.description, image: UIImage(named: "Notification") ?? nil,theme: .default)
                }
   
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UnitTestcase

    func unitTestcase() {
        
        self.getAreaOfInterestData = ["India","India"]
        CountryAction(UIButton())
        self.getAreaOfInterestData = ["India","India","America and information"]
        CountryAction(UIButton())
        self.getAreaOfInterestData = ["India","India","America and information","test","test1"]
        CountryAction(UIButton())
        editButtonAction(UIButton())
        unverifiedBtn(UIButton())
        unverifiedEmailBtn(UIButton())
        countryPicker(didSelect: Country(phoneCode: "+91", isoCode: "2"))
    }

}
// MARK:- UICollectionView Delegate and Data source
extension MyProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    // MARK:- collectionViewLayout
    /*
     Adding the size of the collection view cell if it is in list view we are applying the size inside the if condition or if it is a grid view the properties inside the else condition is initilized
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellWidth  : Double = 0.0
        if let country = CountryManager.shared.getCountries().first(where: { $0.isoCode == self.getAreaOfInterestData[indexPath.row] }) {
            let text = country.localizedName
             cellWidth = (text.size(withAttributes:[.font: Constant.sharedInstance.regularFont!]).width) + 65.0
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
        if self.getAreaOfInterestData.count > 0 {
            DispatchQueue.main.async {
                if let country = CountryManager.shared.getCountries().first(where: { $0.isoCode == self.getAreaOfInterestData[indexPath.row] }) {
                    cell?.lblPerference.text = self.getAreaOfInterestData[indexPath.row].getFlag() + " " + country.localizedName
                    
                }
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyProfileViewController.cellTappedMethod(_:)))
                
                cell?.imgFlag.isUserInteractionEnabled = true
                cell?.imgFlag.tag = indexPath.row
                cell?.imgFlag.addGestureRecognizer(tapGestureRecognizer)
                //            cell?.imgFlag.isHidden = true
                //            cell?.imgWidth.constant = 0
                //            cell?.imgHeight.constant = 0
                cell?.lblPerference.textColor = Constant.sharedInstance.borderlineColor
                cell?.layer.cornerRadius = 5
            }
            UserDefaultModule.shared.setUserResident(resident: self.getAreaOfInterestData.last ?? "")
        } 

        return cell ?? UICollectionViewCell()
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
}
extension MyProfileViewController: CountryCodePickerDelegate {
    func countryPicker(didSelect country: Country) {
        print(country.localizedName)
        if getAreaOfInterestData.contains(country.isoCode){
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Country Already Added", image: UIImage(named: "Notification") ?? nil,theme: .default)
        } else {
            getAreaOfInterestData.append(country.isoCode)
            registerCells()
            var residentData = ""
            if getAreaOfInterestData.count > 0 {
                for iData in 0 ..< getAreaOfInterestData.count {
                            if iData == 0 {
                                residentData = getAreaOfInterestData[iData]
                            } else {
                                residentData = residentData + "," + getAreaOfInterestData[iData]
                            }
                }
            }
            let params = EditProfileParam.init(firstName: self.viewProfileResponseDetails?.entity?.userID?.firstName ?? "", lastName: self.viewProfileResponseDetails?.entity?.userID?.lastName ?? "", dob: self.viewProfileResponseDetails?.entity?.dob ?? "", email: self.viewProfileResponseDetails?.entity?.userID?.emailID ?? "", mobileNo: self.viewProfileResponseDetails?.entity?.userID?.mobileNo ?? "", profileImage: self.viewProfileResponseDetails?.entity?.profileImage ?? "", resident: residentData, gender: self.viewProfileResponseDetails?.entity?.userID?.gender ?? "", countryCode: self.viewProfileResponseDetails?.entity?.userID?.countryCode ?? "")
            print(">>>>>>>\(self.viewProfileResponseDetails?.entity?.resident ?? "")")
            self.upDateProfileApi(params: params)
        }
    }
    func upDateProfileApi(params :EditProfileParam) {
        EditProfilePageViewModel.EditProfileAPIRequest(with: params, controller: self, boolLoaderEnable: true) { Response in
            switch Response {
            case .failure(let error):
                utilsClass.sharedInstance.debugprint(message: error)
            case .success(let result):
                utilsClass.sharedInstance.debugprint(message: result)
                self.viewProfileApi(isFromViewWillAppear: false)
//                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    @objc func cellTappedMethod(_ sender:AnyObject){
         print("you tap image number: \(sender.view.tag)")
      
        var countryName:String = ""
        if let country = CountryManager.shared.getCountries().first(where: { $0.isoCode == self.getAreaOfInterestData[sender.view.tag] }) {
            countryName = country.localizedName
        }
        
//        let refreshAlert = UIAlertController(title: "", message: "Are you sure, you want to remove \(countryName)?", preferredStyle: .alert)
//        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
//
//            self.getAreaOfInterestData.remove(at: sender.view?.tag ?? 0)
//            self.registerCells()
//            var residentData = ""
//            if self.getAreaOfInterestData.count > 0 {
//                for iData in 0 ..< self.getAreaOfInterestData.count {
//                            if iData == 0 {
//                                residentData = self.getAreaOfInterestData[iData]
//                            } else {
//                                residentData = residentData + "," + self.getAreaOfInterestData[iData]
//                            }
//                }
//            }
//            let params = EditProfileParam.init(firstName: self.viewProfileResponseDetails?.entity?.userID?.firstName ?? "", lastName: self.viewProfileResponseDetails?.entity?.userID?.lastName ?? "", dob: self.viewProfileResponseDetails?.entity?.dob ?? "", email: self.viewProfileResponseDetails?.entity?.userID?.emailID ?? "", mobileNo: self.viewProfileResponseDetails?.entity?.userID?.mobileNo ?? "", profileImage: self.viewProfileResponseDetails?.entity?.profileImage ?? "", resident: residentData, gender: self.viewProfileResponseDetails?.entity?.userID?.gender ?? "", countryCode: self.viewProfileResponseDetails?.entity?.userID?.countryCode ?? "")
//            print(">>>>>>>\(self.viewProfileResponseDetails?.entity?.resident ?? "")")
//            self.upDateProfileApi(params: params)
//        }))
//        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
//        }))
//        present(refreshAlert, animated: true, completion: nil)
//
        
        let alertVC = PMAlertController(title:"", description: "Are you sure, you want to remove \(countryName)?", image: UIImage(named: "Notification1"), style: .walkthrough)
        alertVC.alertDescription.textColor = Constant.sharedInstance.appColor
        alertVC.alertTitle.textColor = Constant.sharedInstance.appColor
        alertVC.addAction(PMAlertAction(title: "Yes", style: .default, backgroundColor: UIColor.white,buttonTitleColor: Constant.sharedInstance.appColor,  action: { () in
            
            self.getAreaOfInterestData.remove(at: sender.view?.tag ?? 0)
            self.registerCells()
            var residentData = ""
            if self.getAreaOfInterestData.count > 0 {
                for iData in 0 ..< self.getAreaOfInterestData.count {
                            if iData == 0 {
                                residentData = self.getAreaOfInterestData[iData]
                            } else {
                                residentData = residentData + "," + self.getAreaOfInterestData[iData]
                            }
                }
            }
            let params = EditProfileParam.init(firstName: self.viewProfileResponseDetails?.entity?.userID?.firstName ?? "", lastName: self.viewProfileResponseDetails?.entity?.userID?.lastName ?? "", dob: self.viewProfileResponseDetails?.entity?.dob ?? "", email: self.viewProfileResponseDetails?.entity?.userID?.emailID ?? "", mobileNo: self.viewProfileResponseDetails?.entity?.userID?.mobileNo ?? "", profileImage: self.viewProfileResponseDetails?.entity?.profileImage ?? "", resident: residentData, gender: self.viewProfileResponseDetails?.entity?.userID?.gender ?? "", countryCode: self.viewProfileResponseDetails?.entity?.userID?.countryCode ?? "")
            print(">>>>>>>\(self.viewProfileResponseDetails?.entity?.resident ?? "")")
            self.upDateProfileApi(params: params)
        }))
        alertVC.addAction(PMAlertAction(title: "No", style: .default, backgroundColor: UIColor.white,buttonTitleColor: Constant.sharedInstance.appColor,  action: { () in
        }))
        self.present(alertVC, animated: true, completion: nil)

        
    }
}
