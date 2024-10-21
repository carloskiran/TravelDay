//
//  SettingsViewController.swift
//  TravelPro
//
//  Created by VIJAY M on 03/05/23.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {
        
    // MARK: - IBOutlets
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var alertThresholdTextfiled: FloatingTF!
    @IBOutlet weak var alertLocationTextfiled: FloatingTF!
    @IBOutlet weak var themeSwitch: UISwitch!
    @IBOutlet weak var alertThresholdlbl: UILabel!
    @IBOutlet weak var alertLocationlbl: UILabel!
    @IBOutlet weak var profileCustomView: CustomView!
    @IBOutlet weak var locationCustomView: CustomView!
    @IBOutlet weak var thresholdCustomView: CustomView!
    @IBOutlet weak var darkThemeCustomView: CustomView!
    @IBOutlet weak var changePasswordCustomView: CustomView!
    @IBOutlet weak var termsCustomView: CustomView!
    @IBOutlet weak var deleteCustomView: CustomView!
    @IBOutlet weak var logoutCustomView: CustomView!
    @IBOutlet weak var fisicalStartDateTxtFld: FloatingTF!
    @IBOutlet weak var fisicalEndDateTxtFld: FloatingTF!
    @IBOutlet weak var minimumStayDateLbl: UILabel!
    @IBOutlet weak var minimumStayAlertTextfield: FloatingTF!
    @IBOutlet weak var taxYearView: CustomView!
    @IBOutlet weak var maximumStayDayView: CustomView!
    @IBOutlet weak var definitionTextfield: FloatingTF!
    @IBOutlet weak var definitionLbl: UILabel!

    // MARK: - Properties
    var thresholdPickerView = UIPickerView()
    var LocationPickerView = UIPickerView()
    var fiscalstartDatePicker = UIDatePicker()
    var fiscalEndDatePicker = UIDatePicker()
    var taxableDaysPickerView = UIPickerView()
    var settingsViewModel = SettingsViewModel()
    var daysList = NSMutableArray()
    var selectedThreshold: String?
    var selectedLocationType:String?
    var isChangesMade = false
    var viewSettingsResponseDetails : ShowSettingsEntity? = nil
    var selectedTaxableDay:String?
    var startedTaxDay = String()
    var endTaxDay = String()
    var definitionDayDatePicker = UIDatePicker()
    lazy var locationCheck:[String] = {
        return ["4 hours","6 hours","8 hours","12 hours"]
    }()
    lazy var thresholdDays:[String] = {
        return Array(5...20).map(String.init)
    }()
    lazy var taxableDays:[String] = {
        return Array(1...366).map(String.init)
    }()

    // MARK: - View life cycle
   
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - viewDidLoad"))
        let array = NSMutableArray()
        for i in thresholdDays{
            let val = "\(i) days"
            array.add(val)
        }
        if let thres = array as? [String] {
            thresholdDays = thres
        } else {
            thresholdDays = []
        }

    }
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - viewWillAppear"))
        setupUI()
        ViewUserSettingsAPICall()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - setupUI"))
        self.navigationController?.hidesBottomBarWhenPushed = false
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        self.userNameLabel.text = UserDefaultModule.shared.getUserName()
        self.profileImageView.sd_setImage(with: URL(string: utilsClass.sharedInstance.checkNullvalue(passedValue: UserDefaultModule.shared.getProfilePic())), placeholderImage: UIImage.init(named: "profile-default-icon"), completed: nil)
        self.profileImageView.roundCorner()
        //threshold picker setup
        thresholdPickerView.delegate = self
        thresholdPickerView.tag = 1
        alertThresholdTextfiled.delegate = self
        alertThresholdTextfiled.tintColor = .clear
        alertThresholdTextfiled.inputView = thresholdPickerView
        setupDismissThresholdPickerView()
        //fiscal start
        fisicalStartDateTxtFld.delegate = self
        fisicalStartDateTxtFld.tintColor = .clear
        setupfiscalStartDatePicker()
        //fiscal end
        fisicalEndDateTxtFld.delegate = self
        fisicalEndDateTxtFld.tintColor = .clear
        setupfiscalEndDatePicker()
        //travelType picker setup
        taxableDaysPickerView.delegate = self
        taxableDaysPickerView.tag = 8
        minimumStayAlertTextfield.delegate = self
        minimumStayAlertTextfield.tintColor = .clear
        minimumStayAlertTextfield.inputView = taxableDaysPickerView
        setupDismissTravelTypePickerView()
        //travelType picker setup
        LocationPickerView.delegate = self
        LocationPickerView.tag = 2
        alertLocationTextfiled.delegate = self
        alertLocationTextfiled.tintColor = .clear
        alertLocationTextfiled.inputView = LocationPickerView
        setupDismissLocationPickerView()
        let userdefault = UserDefaults.standard
        let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
        themeSwitch.isOn = isDarkMode
        definitionTextfield.delegate = self
        definitionTextfield.tintColor = .clear
        setupDefinitionDatePicker()
    }
    private func setupDefinitionDatePicker(){
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - setupDefinitionDatePicker"))
        definitionDayDatePicker.datePickerMode = .countDownTimer
        definitionDayDatePicker.addTarget(self, action: #selector(respondToChanges(picker:)), for: .valueChanged)
        definitionDayDatePicker.minuteInterval = 1
        var components = DateComponents()
        components.minute = 10
        let date = Calendar.current.date(from: components)!
        definitionDayDatePicker.setDate(date, animated: true)
        let toolbar = createPickerToolbar(8)
        definitionTextfield.inputAccessoryView = toolbar
        definitionTextfield.inputView = definitionDayDatePicker
        if #available(iOS 14, *) {
            definitionDayDatePicker.preferredDatePickerStyle = .wheels
            definitionDayDatePicker.sizeToFit()
        }
     }
    @objc
    private func respondToChanges(picker: UIDatePicker) {
        if (picker.countDownDuration <= 540) {
            var components = DateComponents()
            components.minute = 10
            let date = Calendar.current.date(from: components)!
            picker.setDate(date, animated: true)
        }
    }
    
    private func setupfiscalStartDatePicker(){
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - setupfiscalStartDatePicker"))
        fiscalstartDatePicker.datePickerMode = .date
        let calendar: Calendar = Calendar.current
        let startDate = calendar.startOfYear(Date())
        fiscalstartDatePicker.minimumDate = startDate
        let toolbar = createPickerToolbar(6)
        fisicalStartDateTxtFld.inputAccessoryView = toolbar
        fisicalStartDateTxtFld.inputView = fiscalstartDatePicker
        fiscalstartDatePicker.timeZone = Calendar.current.timeZone
        if #available(iOS 14, *) {
            fiscalstartDatePicker.preferredDatePickerStyle = .wheels
            fiscalstartDatePicker.sizeToFit()
        }
        // Set min and max date based on start date year
        let gregorian = Calendar(identifier: .gregorian)
        let minimumDate = gregorian.date(from: DateComponents(year: gregorian.component(.year, from: Date()), month: 1, day: 1))!
        let maximumDate = gregorian.date(from: DateComponents(year: gregorian.component(.year, from: Date()), month: 12, day: 31))!
        fiscalstartDatePicker.minimumDate = minimumDate
        fiscalstartDatePicker.maximumDate = maximumDate
     }
    
    private func setupfiscalEndDatePicker(){
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - setupfiscalEndDatePicker"))
        fiscalEndDatePicker.datePickerMode = .date
        fiscalEndDatePicker.minimumDate = Date()
        let dateString = viewSettingsResponseDetails?.taxEndYear ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateString)
        // Assuming you have a UIDatePicker instance named "datePicker"
        fiscalEndDatePicker.minimumDate = date
        fiscalEndDatePicker.maximumDate = date
        let toolbar = createPickerToolbar(7)
        fisicalEndDateTxtFld.inputAccessoryView = toolbar
        fisicalEndDateTxtFld.inputView = fiscalEndDatePicker
        if #available(iOS 14, *) {
            fiscalEndDatePicker.preferredDatePickerStyle = .wheels
            fiscalEndDatePicker.sizeToFit()
        }
     }
    
    private func setupDismissTravelTypePickerView() {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - setupDismissTravelTypePickerView"))
        let toolbar = createPickerToolbar(3)
        minimumStayAlertTextfield.inputAccessoryView = toolbar
    }
    
    // MARK: - User interactions
    @IBAction func myProfileButtonAction(_ sender: Any) {
        TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - myProfileButtonAction"))
        self.view.endEditing(true)
        let profile = MyProfileViewController.loadFromNib()
        profile.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(profile, animated: true)
    }

    @IBAction func updateButtonAction(_ sender: Any) {
        TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - updateButtonAction"))
        if isChangesMade{
            UpdateSettingsAPI()
        }
    }
    @IBAction func editButtonAction(_ sender: Any) {
        TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - editButtonAction"))
    }

    @IBAction func daysButtonAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - daysButtonAction"))
        let tag = sender.tag
        if sender.backgroundColor != .lightGray {
            daysList.add(tag)
            sender.backgroundColor = .lightGray
        }
        else
        {
            daysList.remove(tag)
            sender.backgroundColor = .systemGreen
        }
        isChangesMade = true
    }

    @IBAction func DeleteAccountButtonAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - DeleteAccountButtonAction"))
        let refreshAlert = UIAlertController(title: "Are you sure, you want to delete your account?", message: "Note: If you delete your account, then you will lose all the data with respect to your profile and travel records.", preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.DeleteAccountAPICall()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func ThemeButtonAction(_ sender: UISwitch) {
        TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - ThemeButtonAction"))
         
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let userdefault = UserDefaults.standard
            if sender.isOn{
                appDelegate.window!.overrideUserInterfaceStyle = .dark
                userdefault.set(true, forKey: "isDark")
            }
            else
            {
                appDelegate.window!.overrideUserInterfaceStyle = .light
                userdefault.set(false, forKey: "isDark")
            }
        }
    }

    @IBAction func LogoutButtonAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - LogoutButtonAction"))
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


    @IBAction func ChangePasswordButtonAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - ChangePasswordButtonAction"))
        let pageObj = CreatePasswordViewController.loadFromNib()
        pageObj.userNameId = UserDefaultModule.shared.getEmailID() ?? ""
        pageObj.navigationType = .settings
        pageObj.flowType = "Settings"
        self.navigationController?.pushViewController(pageObj, animated: true)
    }

    @IBAction func TermsButtonAction(_ sender: UIButton) {
        let pageObj = TermsAndConditionViewController.loadFromNib()
        pageObj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(pageObj, animated: true)
    }

    private func setupDismissThresholdPickerView() {
        TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - setupDismissThresholdPickerView"))
        let toolbar = createPickerToolbar(1)
        alertThresholdTextfiled.inputAccessoryView = toolbar
    }

    private func setupDismissLocationPickerView() {
        TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - setupDismissLocationPickerView"))
        let toolbar = createPickerToolbar(2)
        alertLocationTextfiled.inputAccessoryView = toolbar
    }


    private func createPickerToolbar(_ tag:Int) -> UIToolbar {
        TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - createPickerToolbar"))
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        var doneButton = UIBarButtonItem()
        switch tag {
        case 1: // threshold
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.thresholdDone))
        case 3: // travel type
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.taxableDonePicker))
        case 6: //fiscal start
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donefiscalStartDatePicker))
        case 7: //fiscal end
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donefiscalEndDatePicker))
        case 8: //fiscal end
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneDefinitiondatePicker))
        default: //location days
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.locationDone))
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
       toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
       return toolbar

    }
    @objc func doneDefinitiondatePicker(){
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - doneDefinitiondatePicker"))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        self.definitionTextfield.text = formatter.string(from: definitionDayDatePicker.date)
        self.definitionTextfield.textColor = UIColor.clear
        self.settingDefinitionLabelData(dateDefiniton: definitionDayDatePicker.date)
        self.view.endEditing(true)
        self.UpdateSettingsAPI()
    }
    func settingDefinitionLabelData(dateDefiniton : Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let format1 = "HH:mm"
        if containsHoursAndMinutes(dateString: formatter.string(from: dateDefiniton), format: format1) {
            formatter.dateFormat = "HH"
            let hours = formatter.string(from: dateDefiniton)
            formatter.dateFormat = "mm"
            let minutes = formatter.string(from: dateDefiniton)
            self.definitionLbl.text = "\(hours) Hours : \(minutes) Minutes"
        } else {
            formatter.dateFormat = "mm"
            self.definitionLbl.text = formatter.string(from: dateDefiniton) +
            " Minutes"
        }
    }
    
    func containsHoursAndMinutes(dateString: String, format: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: date)
            return (components.hour != nil) && (components.minute != nil) &&  (components.hour != 0)
        }
        return false
    }
    
    @objc func donefiscalStartDatePicker(){
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - donefiscalStartDatePicker"))
        let selectedDate = fiscalstartDatePicker.date
        // Get the current calendar and time zone
        let calendar = Calendar.current
        let timeZone = calendar.timeZone
        // Convert the date from UTC to local time zone
        _ = calendar.date(byAdding: .second, value: timeZone.secondsFromGMT(), to: selectedDate) ?? selectedDate
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        formatter.timeZone = TimeZone.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
        let dateString = dateFormatter.string(from: selectedDate)
        fisicalStartDateTxtFld.text = formatter.string(from: selectedDate)
        self.startedTaxDay = dateString
        // Set min and max date based on start date year
        let gregorian = Calendar(identifier: .gregorian)
        var dateComponent = gregorian.dateComponents([.year, .month, .day], from: selectedDate)
        dateComponent.year! += 1
        dateComponent.day! -= 1
        self.fiscalEndDatePicker.minimumDate = gregorian.date(from: dateComponent)
        self.fiscalEndDatePicker.maximumDate = gregorian.date(from: dateComponent)
        self.fisicalEndDateTxtFld.text = ""
        self.view.endEditing(true)
    }
    
    @objc func donefiscalEndDatePicker() {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - donefiscalEndDatePicker"))
        let selectedDate = fiscalEndDatePicker.date
        // Get the current calendar and time zone
        let calendar = Calendar.current
        let timeZone = calendar.timeZone
        // Convert the date from UTC to local time zone
        let localDate = calendar.date(byAdding: .second, value: timeZone.secondsFromGMT(), to: selectedDate) ?? selectedDate
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        guard fisicalStartDateTxtFld.text != formatter.string(from: localDate) else {
            self.view.endEditing(true)
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Fiscal End date should be greater than fiscal start date", image: nil,theme: .default)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
        let dateString = dateFormatter.string(from: selectedDate)
        fisicalEndDateTxtFld.text = formatter.string(from: selectedDate)
        self.endTaxDay = dateString
        self.view.endEditing(true)
        UpdateSettingsAPI()
    }
    
    @objc private func taxableDonePicker() {
        self.view.endEditing(true)
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - taxableDonePicker"))
        minimumStayDateLbl.text = selectedTaxableDay
        UpdateSettingsAPI()
    }
    
    private func getIntervalDays(_ startDate:Date,_ endDate:Date) -> Int {
        let diffInDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        return diffInDays
    }

    @objc private func cancelDatePicker(){
       self.view.endEditing(true)
     }

    @objc private func thresholdDone() {
        TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - thresholdDone"))
        self.view.endEditing(true)
        alertThresholdlbl.text = "\(selectedThreshold ?? "")"
        UpdateSettingsAPI()
    }
    @objc private func locationDone() {
        TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - locationDone"))
        self.view.endEditing(true)
        alertLocationlbl.text = "\(selectedLocationType ?? "")"
        UpdateSettingsAPI()
    }

    //MARK: - UnitTestcase
    
    func unitTestCase() {
        self.doneDefinitiondatePicker()
        self.donefiscalStartDatePicker()
        self.donefiscalEndDatePicker()
        self.taxableDonePicker()
        _ = self.getIntervalDays(Date(), Date())
        self.thresholdDone()
        self.locationDone()
        self.UpdateSettingsAPI()
        textFieldDidBeginEditing(alertLocationTextfiled)
        textFieldDidBeginEditing(alertThresholdTextfiled)
        textFieldDidBeginEditing(minimumStayAlertTextfield)
        let datepicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        datepicker.countDownDuration = TimeInterval(10)
        respondToChanges(picker: datepicker)
        myProfileButtonAction(UIButton())
        updateButtonAction(UIButton())
        editButtonAction(UIButton())
        daysButtonAction(UIButton())
        ThemeButtonAction(UISwitch())
        LogoutButtonAction(UIButton())
        ChangePasswordButtonAction(UIButton())
        TermsButtonAction(UIButton())
    }
}
