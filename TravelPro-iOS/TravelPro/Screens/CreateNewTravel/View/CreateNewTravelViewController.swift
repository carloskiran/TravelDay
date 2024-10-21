//
//  CreateNewTravelViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 13/04/23.
//

import UIKit
import IQKeyboardManagerSwift
import UniformTypeIdentifiers
import FSCalendar
import AWSCore
import AWSS3
import SwiftMessages

class CreateNewTravelViewController: UIViewController {

    // MARK: - Properties
    var thresholdPickerView = UIPickerView()
    var travelTypePickerView = UIPickerView()
    var taxableDaysPickerView = UIPickerView()
    var definitionDayDatePicker = UIDatePicker()
    var startDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    var fiscalstartDatePicker = UIDatePicker()
    var fiscalEndDatePicker = UIDatePicker()
    var selectedThreshold: String?
    var selectedTravelType:String?
    var selectedTravelTypeId:Int = 0
    var selectedTaxableDay:String?
    var createTravelHandler:CreateTravelHelper! = CreateTravelHelper()
    let createTravelViewModel = CreateNewTravelViewModel()
    var travelID:String = ""
    lazy var thresholdDays:[String] = {
        return Array(5...10).map(String.init)

    }()
    lazy var taxableDays:[String] = {
        return Array(1...366).map(String.init)

    }()
    lazy var travelTypeList:[String] = {
        return ["Business Travel","Leisure Travel","Others"]
    }()
    var selectedDatesRange:[Date]?
    var isOverViewCompleted:Bool {
        return self.createTravelHandler.fromCountry > 0 &&
                self.createTravelHandler.toCountry > 0 &&
                self.createTravelHandler.startDateString != nil &&
                self.createTravelHandler.endDateString != nil &&
                self.createTravelHandler.noWorkDays.count > 0 &&
                self.createTravelHandler.definitionDay != nil &&
                self.createTravelHandler.fiscalYearStart != nil &&
                self.createTravelHandler.fiscalYearEnd?.count ?? 0 > 0 &&
                self.createTravelHandler.alertThresholdDays.count > 0
    }
    var pickedImageDictionary: [String: URL] = ["0": URL(fileURLWithPath: ""), "1": URL(fileURLWithPath: ""), "2": URL(fileURLWithPath: ""), "3": URL(fileURLWithPath: "")]
    var uploadedDocumentArray = [String]()
    var apiCallingEnableOrDisable = [String: String]()
    var travelAndHotelArray = ["0": URL(fileURLWithPath: ""), "1": URL(fileURLWithPath: ""), "2": URL(fileURLWithPath: ""), "3": URL(fileURLWithPath: "")]
    var travelAndHoterlDocumentArray = [String]()
    var travelApiCallingEnable = [String: String]()
    var foodAndEntertainment = ["0": URL(fileURLWithPath: ""), "1": URL(fileURLWithPath: ""), "2": URL(fileURLWithPath: ""), "3": URL(fileURLWithPath: "")]
    var foodAndEntertainmentDocumentArray = [String]()
    var foodApiCallingEnable = [String: String]()
    var shoppingAndUtility = ["0": URL(fileURLWithPath: ""), "1": URL(fileURLWithPath: ""), "2": URL(fileURLWithPath: ""), "3": URL(fileURLWithPath: "")]
    var shoppingAndUtilityDocumentArray = [String]()
    var shoppingApiCallingEnable = [String: String]()
    var others = ["0": URL(fileURLWithPath: ""), "1": URL(fileURLWithPath: ""), "2": URL(fileURLWithPath: ""), "3": URL(fileURLWithPath: "")]
    var othersDocumentArray = [String]()
    var othersApiCallingEnable = [String: String]()
    var editTravelDoc = [String]()
    var editFoodDoc = [String]()
    var editshoppingDoc = [String]()
    var editothersDoc = [String]()
    var travelTextNotes = String()
    var headerTitleArray = ["Travel and Hotel", "Food and Entertainment", "Shopping and Utility", "Others"]
    var selectedDocumentCategory: documentCategory!
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var nonWorkDayDates:[Date]?
    var manageTravel:ManageTravelType = .create
    var createdBy:String = ""
    var isCurrentDate:Bool = false
    var isCurrentCountry:Bool = false
    var existingRecordEntity:TravelSummaryEntity?
    var isTravelAndHotelEnable : Bool = true
    var isFoodAndEntertainmentEnable : Bool = true
    var isShoppingAndUntilityEnable : Bool = true
    var isOtherEnable : Bool = true
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - IBOutlets
 
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var taxableDayLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var returnLabel: UILabel!
    @IBOutlet weak var thresholdLabel: UITextField!
    @IBOutlet weak var newRecordLabel: CustomButton!
    @IBOutlet weak var createTravelLabel: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var overviewView: UIView!
    @IBOutlet weak var fromTextfield: FloatingTF!
    @IBOutlet weak var toTextfield: FloatingTF!
    @IBOutlet weak var alertThresholdTextfiled: FloatingTF!
    @IBOutlet weak var travelTypeTextfiled: FloatingTF!
    @IBOutlet weak var definitionTextfield: FloatingTF!
    @IBOutlet weak var startDateTextfield: FloatingTF!
    @IBOutlet weak var endDateTextfield: FloatingTF!
    @IBOutlet weak var fiscalStartTextfield: FloatingTF!
    @IBOutlet weak var fiscalEndTextfield: FloatingTF!
    @IBOutlet weak var taxableDaysTextfield: FloatingTF!
    @IBOutlet weak var travelNotesTextview: IQTextView!
    @IBOutlet weak var othersTextfield: FloatingTF!
    @IBOutlet weak var othersView: UIView!
    @IBOutlet weak var fromTextfieldView: UIView!
    @IBOutlet weak var toTextfieldView: UIView!
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var endDateView: UIView!
    @IBOutlet weak var travelTypeView: UIView!
    @IBOutlet weak var definitionView: UIView!
    @IBOutlet weak var alertThresholdView: UIView!
    @IBOutlet weak var fiscalEndView: UIView!
    @IBOutlet weak var fiscalStartView: UIView!
    @IBOutlet weak var maximumStayDayView: UIView!
    @IBOutlet weak var createButton: CustomButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var travelNotesView: UIView!
    @IBOutlet weak var tableviewHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var countryNameButton: UIButton!
    
    // MARK: - View life cycle

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - viewDidLoad"))
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - viewWillAppear"))
        setupLocalizeTexts()
        setupUI()
        switch self.manageTravel {
        case .edit:
            self.createButton.setTitle("Update", for: .normal)
            self.setupTravelEditData()
            self.backButton.isHidden = false
            self.closeButton.isHidden = true
            if self.createdBy == "App" && self.isCurrentDate == true && self.isCurrentCountry == true{
                self.countryNameButton.isUserInteractionEnabled = false
                self.endDateTextfield.isUserInteractionEnabled = false
                self.toTextfield.isUserInteractionEnabled = false
                self.toTextfieldView.backgroundColor = UIColor(named: "WhiteAndLightBlue")?.withAlphaComponent(0.6)
                self.endDateView.backgroundColor = UIColor(named: "WhiteAndLightBlue")?.withAlphaComponent(0.6)
            }
        default:
            self.createTravelHandler = CreateTravelHelper()
            self.closeButton.isHidden = false
            self.backButton.isHidden = true
            self.createButton.setTitle("Create", for: .normal)
            setupDefaultValue()
        }
    }
    
    // MARK: - ViewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        self.travelTypeTextfiled.text = ""
        self.othersTextfield.text = ""
        self.travelNotesTextview.text = ""
        self.travelTextNotes = ""
        self.createTravelHandler.travelNotes = ""
        self.travelAndHoterlDocumentArray.removeAll()
        self.foodAndEntertainmentDocumentArray.removeAll()
        self.shoppingAndUtilityDocumentArray.removeAll()
        self.othersDocumentArray.removeAll()
        self.travelApiCallingEnable.removeAll()
        self.foodApiCallingEnable.removeAll()
        self.shoppingApiCallingEnable.removeAll()
        self.othersApiCallingEnable.removeAll()
        self.travelAndHotelArray.removeAll()
        self.foodAndEntertainment.removeAll()
        self.shoppingAndUtility.removeAll()
        self.others.removeAll()
        self.tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    /// SetupUI
    internal func setupUI() {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - setupUI"))
        fromTextfield.text = ""
        toTextfield.text = ""
        startDateTextfield.text = ""
        endDateTextfield.text = ""
        taxableDaysTextfield.text = ""
        definitionTextfield.text = ""
        fiscalStartTextfield.text = ""
        fiscalEndTextfield.text = ""
        self.overviewView.isHidden = false
        self.tableView.register(UINib(nibName: AttachmentProgressTableViewCell.TableReuseIdentifier, bundle: nil),forCellReuseIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.sectionHeaderTopPadding = 0
        self.tableView.tableFooterView = UIView()
        //threshold picker setup
        thresholdPickerView.delegate = self
        thresholdPickerView.tag = 1
        alertThresholdTextfiled.delegate = self
        alertThresholdTextfiled.tintColor = .clear
        alertThresholdTextfiled.inputView = thresholdPickerView
        setupDismissThresholdPickerView()
        //travelType picker setup
        travelTypePickerView.delegate = self
        travelTypePickerView.tag = 2
        travelTypeTextfiled.delegate = self
        travelTypeTextfiled.tintColor = .clear
        travelTypeTextfiled.inputView = travelTypePickerView
        setupDismissTravelTypePickerView()
        //travelType picker setup
        taxableDaysPickerView.delegate = self
        taxableDaysPickerView.tag = 8
        taxableDaysTextfield.delegate = self
        taxableDaysTextfield.tintColor = .clear
        taxableDaysTextfield.inputView = taxableDaysPickerView
        setupDismissTravelTypePickerView()
        //definition day
        definitionTextfield.delegate = self
        definitionTextfield.tintColor = .clear
        setupDefinitionDatePicker()
        //start date
        startDateTextfield.delegate = self
        startDateTextfield.tintColor = .clear
        setupStartDateDatePicker()
        //end date
        endDateTextfield.delegate = self
        endDateTextfield.tintColor = .clear
        setupEndDateDatePicker()
        //fiscal start
        fiscalStartTextfield.delegate = self
        fiscalStartTextfield.tintColor = .clear
        setupfiscalStartDatePicker()
        //fiscal end
        fiscalEndTextfield.delegate = self
        fiscalEndTextfield.tintColor = .clear
        setupfiscalEndDatePicker()
        //taxable days
        taxableDaysTextfield.delegate = self
        taxableDaysTextfield.tintColor = .clear
        setupDismissTaxableDaysPickerView()
        //Reset pickerviews
        taxableDaysPickerView.selectRow(0, inComponent: 0, animated: true)
        self.pickerView(taxableDaysPickerView, didSelectRow: 0, inComponent: 0)
        travelTypePickerView.selectRow(0, inComponent: 0, animated: true)
        self.pickerView(travelTypePickerView, didSelectRow: 0, inComponent: 0)
        thresholdPickerView.selectRow(0, inComponent: 0, animated: true)
        self.pickerView(thresholdPickerView, didSelectRow: 0, inComponent: 0)
        thresholdPickerView.selectRow(0, inComponent: 0, animated: true)
        self.pickerView(thresholdPickerView, didSelectRow: 0, inComponent: 0)
        if self.manageTravel == .edit {
            let maximumValue = 4
            for index in 0..<maximumValue {
                if index < self.editTravelDoc.count {
                    let urlFile = URL(fileURLWithPath: AWSConfig.kAWSBaseURL + self.editTravelDoc[index])
                    self.travelAndHotelArray.updateValue(urlFile, forKey: "\(index)")
                    self.travelApiCallingEnable.updateValue("completed", forKey: "\(index)")
                } else {
                    self.travelAndHotelArray.updateValue(URL(fileURLWithPath: ""), forKey: "\(index)")
                }
                if index < self.editFoodDoc.count {
                    let urlFile = URL(fileURLWithPath: AWSConfig.kAWSBaseURL + self.editFoodDoc[index])
                    self.foodAndEntertainment.updateValue(urlFile, forKey: "\(index)")
                    self.foodApiCallingEnable.updateValue("completed", forKey: "\(index)")
                } else {
                    self.foodAndEntertainment.updateValue(URL(fileURLWithPath: ""), forKey: "\(index)")
                }
                if index < self.editshoppingDoc.count {
                    let urlFile = URL(fileURLWithPath: AWSConfig.kAWSBaseURL + self.editshoppingDoc[index])
                    self.shoppingAndUtility.updateValue(urlFile, forKey: "\(index)")
                    self.shoppingApiCallingEnable.updateValue("completed", forKey: "\(index)")
                } else {
                    self.shoppingAndUtility.updateValue(URL(fileURLWithPath: ""), forKey: "\(index)")
                }
                if index < self.editothersDoc.count {
                    let urlFile = URL(fileURLWithPath: AWSConfig.kAWSBaseURL + self.editothersDoc[index])
                    self.others.updateValue(urlFile, forKey: "\(index)")
                    self.othersApiCallingEnable.updateValue("completed", forKey: "\(index)")
                }else {
                    self.others.updateValue(URL(fileURLWithPath: ""), forKey: "\(index)")
                }
            }
            self.travelAndHoterlDocumentArray = self.editTravelDoc
            self.foodAndEntertainmentDocumentArray = self.editFoodDoc
            self.shoppingAndUtilityDocumentArray = self.editshoppingDoc
            self.othersDocumentArray = self.editothersDoc
            self.tableView.reloadData()
            setTableviewDynamicHeight()
            self.travelNotesTextview.text = self.travelTextNotes
        }
        self.fromTextfieldView.addShadow()
        self.toTextfieldView.addShadow()
        self.startDateView.addShadow()
        self.endDateView.addShadow()
        self.travelTypeView.addShadow()
        self.definitionView.addShadow()
        self.alertThresholdView.addShadow()
        self.fiscalEndView.addShadow()
        self.fiscalStartView.addShadow()
        self.maximumStayDayView.addShadow()
        self.travelNotesView.addShadow()
    }
    
    internal func setupDefaultValue() {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - setupDefaultValue"))
        fromTextfieldView.isUserInteractionEnabled = true
        createTravelHandler.noWorkDays = "183"
        createTravelHandler.noWorkDays = "\(UserDefaultModule.shared.getMaximumStayCount())"
        taxableDaysTextfield.text = "183"
        self.taxableDaysTextfield.text = "\(UserDefaultModule.shared.getMaximumStayCount())"
        createTravelHandler.definitionDay = UserDefaultModule.shared.getDefinitionOfDay()
        definitionTextfield.text = UserDefaultModule.shared.getDefinitionOfDay()
        createTravelHandler.alertThresholdDays = "\(UserDefaultModule.shared.getThresholdDetails())"
        alertThresholdTextfiled.text = "\(UserDefaultModule.shared.getThresholdDetails())"
        //fiscal start
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let calendar: Calendar = Calendar.current
        let startYearDate = calendar.startOfYear(Date())
        fiscalStartTextfield.text = formatter.string(from: startYearDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
        let newStartTime = dateFormatter.string(from: startYearDate)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
        let startDate = dateFormatter.date(from: newStartTime) ?? Date()
//        self.createTravelHandler.fiscalYearStart = newStartTime
        self.createTravelHandler.fiscalStartDate = startDate
        self.fiscalStartTextfield.text = UserDefaultModule.shared.getSettingsTaxableStartDate().generalDateConversion()
        self.createTravelHandler.fiscalYearStart = UserDefaultModule.shared.getSettingsTaxableStartDate().replacingOccurrences(of: "Z", with: "0")
        //fiscal end
        let formatterend = DateFormatter()
        formatterend.dateFormat = "MMM dd, yyyy"
        let dateFormatterend = DateFormatter()
        dateFormatterend.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
        dateFormatterend.timeZone = TimeZone(abbreviation: "GMT+0:00")//Must used if you get one day less in conversion
        dateFormatterend.locale = Locale(identifier: "en_US_POSIX")
        let interval = calendar.dateInterval(of: .year, for: Date())
        let newStartTimeend = dateFormatterend.string(from: interval?.end ?? Date())
        dateFormatterend.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
        let endDate = dateFormatterend.date(from: newStartTimeend) ?? Date()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
        dateFormatter2.timeZone = TimeZone(abbreviation: "GMT+0:00")//Must used if you get one day less in conversion
        dateFormatter2.dateStyle = .medium
        dateFormatter2.timeStyle = .none
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        let newStartTime2 = dateFormatter2.string(from: endDate)
        fiscalEndTextfield.text = newStartTime2
        self.createTravelHandler.fiscalEndDate = endDate
//        self.createTravelHandler.fiscalYearEnd = newStartTimeend
        self.fiscalEndTextfield.text = UserDefaultModule.shared.getSettingsTaxableEndDate().generalDateConversion()
        self.createTravelHandler.fiscalYearEnd = UserDefaultModule.shared.getSettingsTaxableEndDate().replacingOccurrences(of: "Z", with: "0")
    }
    
    internal func setupTravelEditData() {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - setupTravelEditData"))
        guard let editData = self.createTravelHandler else {
            return
        }
        //From Country
        self.createTravelHandler.fromCountry = editData.fromCountry
        self.fromTextfield.text = editData.fromCountryString
        self.createTravelHandler.fromCountryString = editData.fromCountryString
        //To Country
        self.createTravelHandler.toCountry = editData.toCountry
        self.toTextfield.text = editData.toCountryString
        self.createTravelHandler.toCountryString = editData.toCountryString
       //========
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                
//        guard let startDateValue = dateFormatter.date(from: editData.startDateString ?? ""), let endDateValue = dateFormatter.date(from: editData.endDateString ?? "") else {
//            return
//        }
//        
//        dateFormatter.dateFormat = "MMM d, yyyy"
//        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
//        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
//        let formattedStartDate1 = dateFormatter.string(from: startDateValue)
//        let formattedStartDate2 = dateFormatter.string(from: endDateValue)
        
        let enddate = self.setDateFormatTextfield(date: editData.endDateString ?? "")
        let startdate = self.setDateFormatTextfield(date: editData.startDateString ?? "")
        
        let startDateAPIValue = self.setDateFormatForAPI(date: editData.startDateString ?? "")
        let endDateAPIValue = self.setDateFormatForAPI(date: editData.endDateString ?? "")

        //Start date
        self.createTravelHandler.startDateString = startDateAPIValue
        self.startDateTextfield.text = startdate
        //End date
        self.createTravelHandler.endDateString = endDateAPIValue
        self.endDateTextfield.text = enddate
        
        
        //======
        // Maximum Days
        self.createTravelHandler.noWorkDays = editData.noWorkDays
        taxableDaysTextfield.text = editData.noWorkDays
        // definition Days
        self.createTravelHandler.definitionDay = editData.definitionDay
        self.definitionTextfield.text = editData.definitionDay
        //fiscal start
        self.createTravelHandler.fiscalYearStart = editData.fiscalYearStart?.timeStampWithoutUtcConversion()
        self.fiscalStartTextfield.text = editData.fiscalYearStart?.settingsTimeStampWithoutTimeZoneStringDate()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd 00:00:00"
        let startDate = dateFormatter2.date(from: editData.fiscalYearStart ?? "") ?? Date()
        self.createTravelHandler.fiscalStartDate = startDate
        //fiscal end
        let dateFormatterEnd = DateFormatter()
        dateFormatterEnd.dateFormat = "yyyy-MM-dd 00:00:00"
        let endDate = dateFormatterEnd.date(from: editData.fiscalYearEnd ?? "") ?? Date()
        self.createTravelHandler.fiscalEndDate = endDate
        self.createTravelHandler.fiscalYearEnd = editData.fiscalYearEnd?.timeStampWithoutUtcConversion()
        self.fiscalEndTextfield.text = editData.fiscalYearEnd?.settingsTimeStampWithoutTimeZoneStringDate()
        //Alert threshold
        self.createTravelHandler.alertThresholdDays = editData.alertThresholdDays
        alertThresholdTextfiled.text = editData.alertThresholdDays
        //travel type
        self.createTravelHandler.travelType = editData.travelType
        travelTypeTextfiled.text = editData.travelType
        self.createTravelHandler.travelTypeID = editData.travelTypeID
        //travel notes
        self.createTravelHandler.travelNotes = editData.travelNotes
        //travel type others
        self.createTravelHandler.travelTypeOthers = editData.travelTypeOthers
        //setupCalendarDateRange
        self.createTravelHandler.startDate = editData.startDateString?.timeStampDateFormat()
        self.createTravelHandler.endDate = editData.endDateString?.timeStampDateFormat()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let newDate = formatter.date(from: editData.startDateString ?? "") ?? Date()
        let gregorian = Calendar(identifier: .gregorian)
        let minimumDate = gregorian.date(from: DateComponents(year: gregorian.component(.year, from: newDate), month: 1, day: 1))!
        let maximumDate = gregorian.date(from: DateComponents(year: gregorian.component(.year, from: newDate), month: 12, day: 31))!
        fiscalstartDatePicker.minimumDate = minimumDate
        fiscalstartDatePicker.maximumDate = maximumDate
    }
    
    private func setDateFormatTextfield(date:String) -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        olDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let oldDate = olDateFormatter.date(from: date) ?? Date()
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "MMM dd, yyyy"
        convertDateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        convertDateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        return convertDateFormatter.string(from: oldDate)
    }
    
    private func setDateFormatForAPI(date:String) -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        olDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let oldDate = olDateFormatter.date(from: date) ?? Date()
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
//        convertDateFormatter.timeZone = TimeZone.current
        return convertDateFormatter.string(from: oldDate)
    }
    
    // MARK: - User interactions
   
    @IBAction func closeButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Are you sure, you want to exit the create new travel?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            if let tabBarController = appDelegate?.window!.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 0
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func fromCountryAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - fromCountryAction"))
        self.view.endEditing(true)
        let country = SelectTravelCountryViewController.loadFromNib()
        country.countryType = .fromCountry
        country.delegate = self
        self.present(country, animated: true)
    }
    
    @IBAction func toCountryAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - toCountryAction"))
        self.view.endEditing(true)
        let country = SelectTravelCountryViewController.loadFromNib()
        country.countryType = .toCountry
        country.delegate = self
        self.present(country, animated: true)
    }
    @IBAction func nextButtonAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - nextButtonAction"))
        self.view.endEditing(true)
        
        guard self.createTravelHandler.fromCountry > 0 else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select country from", image: nil,theme: .default)
        }
        
        guard self.createTravelHandler.toCountry > 0 else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select country to", image: nil,theme: .default)
        }
              
        guard (self.createTravelHandler.startDateString != nil) else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select start date", image: nil,theme: .default)
        }
        
        guard (self.createTravelHandler.endDateString != nil) else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select end date", image: nil,theme: .default)
        }

        guard self.createTravelHandler.endDate! > self.createTravelHandler.startDate! else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "End date should be greater than start date", image: nil,theme: .default)
        }
        
        guard self.createTravelHandler.noWorkDays.count > 0 else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select no of work days", image: nil,theme: .default)
        }
        
        guard (self.createTravelHandler.definitionDay != nil) else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select definition of day", image: nil,theme: .default)
        }
        
        guard (self.createTravelHandler.fiscalYearStart != nil) else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select the tax year start", image: nil,theme: .default)
        }
        
        guard (self.createTravelHandler.fiscalYearEnd != nil) else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select the tax year end", image: nil,theme: .default)
        }
        
        guard self.createTravelHandler.alertThresholdDays.count > 0 else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select the alert threshold", image: nil,theme: .default)
        }
        self.createTravelHandler.isOverViewCompleted = self.isOverViewCompleted
        self.overviewView.isHidden = true
    }
    
    @IBAction func uploadDocumentButtonAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - uploadDocumentButtonAction"))
        self.view.endEditing(true)
        openDocumentWithAlert()
    }
    
    @IBAction func createTravelButtonAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - createTravelButtonAction"))
        self.setupValidationCreateTravel()
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - backButtonAction"))
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func swapButtonAction(_ sender: Any) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - swapButtonAction"))
        if fromTextfieldView.tag == 1 && toTextfieldView.tag == 2 {
            fromTextfieldView.tag = 2
            toTextfieldView.tag = 1
            fromTextfield.text = createTravelHandler.toCountryString
            toTextfield.text = createTravelHandler.fromCountryString
            var Numtemp = 0
            var Number1 = createTravelHandler.fromCountry
            var Number2 = createTravelHandler.toCountry
            Numtemp = Number1
            Number1 = Number2
            Number2 = Numtemp
            createTravelHandler.fromCountry = Number1
            createTravelHandler.toCountry = Number2
            
        } else {
            fromTextfieldView.tag = 1
            toTextfieldView.tag = 2
            fromTextfield.text = createTravelHandler.fromCountryString
            toTextfield.text = createTravelHandler.toCountryString
            var Numtemp = 0
            var Number1 = createTravelHandler.toCountry
            var Number2 = createTravelHandler.fromCountry
            Numtemp = Number1
            Number1 = Number2
            Number2 = Numtemp
            createTravelHandler.fromCountry = Number1
            createTravelHandler.toCountry = Number2
        }
    }
}


