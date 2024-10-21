//
//  DashBoardViewController.swift
//  TravelPro
//
//  Created by Mac-OBS-32 on 12/04/23.
//

import UIKit

class DashBoardViewController: RootViewController , UITextFieldDelegate , UIPickerViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var recentAllButton: UIButton!
    @IBOutlet weak var upcomingAllButton: UIButton!
    @IBOutlet weak var totalDaysLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var presenceDayLabel: UILabel!
    @IBOutlet weak var residentView: CustomView!
    @IBOutlet weak var residentLabel: UILabel!
    @IBOutlet weak var presentCountryLabel: UILabel!
    @IBOutlet weak var noRecentVisitLabel: UILabel!
    @IBOutlet weak var noUpcomingScheduleLabel: UILabel!
    @IBOutlet weak var noCurrentScheduleLabel: UILabel!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var notificationHighLightView: UIView!
    @IBOutlet weak var updateNowViewHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var updateNowProfileView: CustomViewShadow!
    @IBOutlet weak var currentScheduleCustomView: CustomViewShadow!
    @IBOutlet weak var currentDateStack: UIStackView!
    @IBOutlet weak var pastDateStack: UIStackView!
    @IBOutlet weak var lastDateStack: UIStackView!
    @IBOutlet weak var currentDateLbl: UILabel!
    @IBOutlet weak var currentDateSelectorView: UIView!
    @IBOutlet weak var pastDateLbl: UILabel!
    @IBOutlet weak var pastDateSelectorView: UIView!
    @IBOutlet weak var lastDateLbl: UILabel!
    @IBOutlet weak var lastDateSelectorView: UIView!
    @IBOutlet weak var locationContentView: UIView!
    @IBOutlet weak var locationDetectedView: UIView!
    @IBOutlet weak var confirmStayPopupView: UIView!
    @IBOutlet weak var countryFrom: FloatingTF!
    @IBOutlet weak var currentLocationTextfield: FloatingTF!
    @IBOutlet weak var startDateTextfield: FloatingTF!
    @IBOutlet weak var confirmContentView: UIView!
    @IBOutlet weak var confirmStayCurrentLocationView: UIView!
    @IBOutlet weak var confirmStayWhenDidyouArriveView: UIView!
    @IBOutlet weak var confirmStayWhichCountryView: UIView!
    @IBOutlet weak var confirmCurrentDateView: UIView!
    @IBOutlet weak var countryNameView: UIView!
    @IBOutlet weak var whenDidYouArriveView: UIView!
    @IBOutlet weak var fromWhichCountryView: UIView!
    @IBOutlet weak var currentDataFromConfirmStay: FloatingTF!
    @IBOutlet weak var currentCountryFromConfirmStay: FloatingTF!
    @IBOutlet weak var travelDataArrivedFromConfirmStay: FloatingTF!
    @IBOutlet weak var countryArrivedFromConfirmStay: FloatingTF!
    
    // MARK: - Properties
    var startDatePicker = UIDatePicker()
    var travelListViewModel = MyTravelListViewModel()
    var listViewModel = MyTravelListViewModel()
    var createTravelViewModel = CreateNewTravelViewModel()
    var upcomingtravelList: [TravelListEntity?] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var recenttravelList: [TravelListEntity?] = [] 
       
    var currentTravelResponse:[TravelListEntity?] = []
    var notificationAPIViewModel = NotificationViewModel()
    var notificationResponse: NotificationResponseModel?
    var settingsViewModel = SettingsViewModel()
    var selectedDate = String()
    var registerAPIToken = updateToken()
    var locationData = LocationData()
    var confirmStayHandler = ConfirmStayHandler()
    var summaryListType:TravelListType = .current
    var dispatchGroup = DispatchGroup()

    // MARK: - View life cycle

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - viewDidLoad"))
        collectionView.register(UINib(nibName: RecentlyVisitedCollectionViewCell.CollectionReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: "recentVisitCell")
        tableView.register(UINib(nibName: UpdatedSummaryCells.TableReuseIdentifier, bundle: nil),forCellReuseIdentifier: UpdatedSummaryCells.TableReuseIdentifier)
            NotificationCenter.default.addObserver(self, selector: #selector(APICalling), name: Notification.Name("PushNotificationReceived"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(locationDetectSuccessCallback), name: Notification.Name("RefreshAppForeground"), object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(locationDetectSuccessCallback), name: Notification.Name("LocationDetectApiSuccess"), object: nil)

        let toolbar = createPickerToolbar(1)
        startDateTextfield.inputAccessoryView = toolbar
        startDatePicker.tag = 1
        startDateTextfield.delegate = self
        startDateTextfield.tintColor = .clear
        startDateTextfield.inputView = startDatePicker
        self.setupStartDateDatePicker()
        self.confirmStayInputs()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    
    @IBAction func arrivedCountryAction(_ sender: UIButton) {
        let country = SelectTravelCountryViewController.loadFromNib()
        country.countryType = .fromCountry
        country.delegate = self
        self.present(country, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func doneStartDatePicker(){
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - donefiscalStartDatePicker"))
        let selectedDate = startDatePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newStartTime = dateFormatter.string(from: selectedDate)
        let combine = newStartTime+"T00:00:00.0000"
        self.locationData.fromDate = combine
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMM dd, yyyy"
        dateFormatter2.timeZone = TimeZone.current
        self.startDateTextfield.text = dateFormatter2.string(from: selectedDate)
        self.view.endEditing(true)
    }
    
    func registerCells() {
        //        DispatchQueue.main.async {
//        self.collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        self.collectionView.register(UINib(nibName: RecentlyVisitedCollectionViewCell.CollectionReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: "recentVisitCell")
        DispatchQueue.main.async {
            print("Recent list >>>>",self.recenttravelList)
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.reloadData()
        }
    }
    
    @objc func doneTravelArrrivedFrom(){
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - donefiscalStartDatePicker"))
        let selectedDate = startDatePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newStartTime = dateFormatter.string(from: selectedDate)
        let combine = newStartTime+"T00:00:00.0000"
        self.confirmStayHandler.startDate = combine
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMM dd, yyyy"
        dateFormatter2.timeZone = TimeZone.current
        self.travelDataArrivedFromConfirmStay.text = dateFormatter2.string(from: selectedDate)
        self.view.endEditing(true)
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - viewWillAppear"))
        setupUI()
        networkCallSetup()
        utilsClass.sharedInstance.setTheme()
        let userdefault = UserDefaults.standard
        let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
        if isDarkMode {
            DispatchQueue.main.async {
                self.updateNowProfileView.shadowColor = UIColor(named: "grayText")
                self.currentScheduleCustomView.shadowColor = UIColor(named: "grayText")
                self.collectionView.reloadData()
                self.tableView.reloadData()
            }
        }
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.appRefreshDelegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        LocationManager.shared.delegate = nil
        LocationManager.shared.updateDelegate = nil
    }
    
    func configurations() {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - configurations"))
    }
    
    // MARK: - Private methods
    
    /// SetupUI
    private func setupUI() {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - setupUI"))
        self.profileImageView.roundCorner()
        self.locationContentView.layer.cornerRadius = 10
        self.userNameLabel.text = "Hello, \(UserDefaultModule.shared.getUserName() ?? "Hello")"
        self.profileImageView.sd_setImage(with: URL(string: utilsClass.sharedInstance.checkNullvalue(passedValue: UserDefaultModule.shared.getProfilePic())), placeholderImage: UIImage.init(named: "profile-default-icon"), completed: nil)
        currentCountryFromConfirmStay.tintColor = .clear
        travelDataArrivedFromConfirmStay.tintColor = .clear
        countryArrivedFromConfirmStay.tintColor = .clear
        self.notificationHighLightView.isHidden = true
        self.notificationHighLightView.layer.cornerRadius = self.notificationHighLightView.frame.height/2
        self.notificationHighLightView.layer.masksToBounds = true
        self.confirmContentView.layer.cornerRadius = 10
        performSelector(inBackground: #selector(APICalling), with: nil)
        performSelector(inBackground: #selector(ViewUserSettingsAPICall), with: nil)
        if let resident = UserDefaultModule.shared.getUserResident(), resident.count > 0 {
            self.updateNowProfileView.isHidden = true
            self.updateNowViewHeightConstrain.constant = 0
        } else {
            self.updateNowProfileView.isHidden = false
            self.updateNowViewHeightConstrain.constant = 120
        }
        if let firstTime = UserDefaultModule.shared.value(forKey: "firstTimeDownload") as? String, firstTime == "true" {
            UserDefaultModule.shared.set("false", forKey: "firstTimeDownload")
            LocationManager.shared.setupLocationManager()
        }
        LocationManager.shared.delegate = self
        LocationManager.shared.updateDelegate = self
        if let firstTime = UserDefaultModule.shared.value(forKey: "loginNewAccount") as? String, firstTime == "true" {
            UserDefaultModule.shared.set("false", forKey: "loginNewAccount")
            LocationManager.shared.setupLocationManager()
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
                if let appdelegate = UIApplication.shared.delegate as? AppDelegate, let userId = UserDefaultModule.shared.getUserID() {
                    self.registerAPIToken.RegisterTokenAPICall(userId: userId, token: appdelegate.deviceToken, loctionToken: appdelegate.locationToken, isLocationToken: true) { response in
                        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - loctionToken:\(appdelegate.locationToken) - devicetoken:\(appdelegate.deviceToken) - success response"))
                        print(response)
                    } onFailure: { error in
                        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - loctionToken:\(appdelegate.locationToken) - devicetoken:\(appdelegate.deviceToken) - failure response"))
                        print(error)
                    }
                }
            }
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let current = calendar.component(.year, from: Date())
        let lastYear = current - 1
        let beforeLastYear = current - 2
        self.currentDateLbl.text = "\(current)"
        self.pastDateLbl.text = "\(lastYear)"
        self.lastDateLbl.text = "\(beforeLastYear)"
        self.currentDateStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dateViewTapAction(_:))))
        self.currentDateStack.tag = 1
        self.pastDateStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dateViewTapAction(_:))))
        self.pastDateStack.tag = 2
        self.lastDateStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dateViewTapAction(_:))))
        self.lastDateStack.tag = 3
        self.currentDateLbl.textColor = UIColor(named: "headingText")
        self.pastDateLbl.textColor = UIColor(named: "GrayColor")
        self.lastDateLbl.textColor = UIColor(named: "GrayColor")
        self.currentDateSelectorView.backgroundColor = UIColor(named: "btnLoginColor")
        self.pastDateSelectorView.backgroundColor = UIColor(named: "GrayColor")
        self.lastDateSelectorView.backgroundColor = UIColor(named: "GrayColor")
        self.selectedDate = "\(current)"
        self.countryNameView.addShadow()
        self.whenDidYouArriveView.addShadow()
        self.fromWhichCountryView.addShadow()
        self.confirmStayCurrentLocationView.addShadow(shadowOpacity:0.1)
        self.confirmStayWhenDidyouArriveView.addShadow()
        self.confirmStayWhichCountryView.addShadow()
        self.confirmCurrentDateView.addShadow(shadowOpacity:0.1)

    }
    
    @objc func dateViewTapAction(_ sender: UITapGestureRecognizer) {
        guard let gestureView = sender.view else {
            return
        }
        switch gestureView.tag {
        case 1:
            summaryListType = .current
            self.selectCurrentYear()
        case 2:
            summaryListType = .upcoming
            self.selectCurrentMinusOneYear()
        default:
            summaryListType = .past
            self.selectCurrentMinusTwoYear()
        }
    }
    
    private func selectCurrentMinusOneYear() {
        self.currentDateLbl.textColor = UIColor(named: "GrayColor")
        self.pastDateLbl.textColor = UIColor(named: "headingText")
        self.lastDateLbl.textColor = UIColor(named: "GrayColor")
        self.currentDateSelectorView.backgroundColor = UIColor(named: "GrayColor")
        self.pastDateSelectorView.backgroundColor = UIColor(named: "btnLoginColor")
        self.lastDateSelectorView.backgroundColor = UIColor(named: "GrayColor")
        self.selectedDate = self.pastDateLbl.text ?? ""
        self.getUpcomingTravelList(date: self.selectedDate)
    }
    
    private func selectCurrentMinusTwoYear() {
        self.currentDateLbl.textColor = UIColor(named: "GrayColor")
        self.pastDateLbl.textColor = UIColor(named: "GrayColor")
        self.lastDateLbl.textColor = UIColor(named: "headingText")
        self.currentDateSelectorView.backgroundColor = UIColor(named: "GrayColor")
        self.pastDateSelectorView.backgroundColor = UIColor(named: "GrayColor")
        self.lastDateSelectorView.backgroundColor = UIColor(named: "btnLoginColor")
        self.selectedDate = self.lastDateLbl.text ?? ""
        self.getUpcomingTravelList(date: self.selectedDate)
    }
    
    private func networkCallSetup() {
        getCurrentListResponse()
        getRecentTravelList()
        getUpcomingTravelList(date: self.selectedDate)
        requestAuthorizeIfNoRecord()
    }

    // MARK: - User interactions

    @IBAction func createTravel(_ sender: Any) {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - createTravel"))
        let travel = MyTravelDetailViewController.loadFromNib()
        self.navigationController?.pushViewController(travel, animated: true)
        
    }
    
    @IBAction func recentViewallAciton(_ sender: Any) {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - recentViewallAciton"))
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let tabBarController = appDelegate?.window!.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 1
        }
    }
    
    @IBAction func notificationBtnTapped(_ sender: Any) {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - notificationBtnTapped"))
        let pageObj = NotificationViewController.loadFromNib()
        pageObj.notificationResponse = self.notificationResponse
        if let entity = self.notificationResponse?.entity {
            pageObj.resultTodayDetails = entity
        }
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    
    @IBAction func summaryAllButtonAciton(_ sender: Any) {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - recentViewallAciton"))
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let tabBarController = appDelegate?.window!.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 1
            if let navigationTwo = self.tabBarController?.viewControllers?[1] {
                if let nav = navigationTwo as? UINavigationController {
                    if let myList = nav.visibleViewController as? MyTravelListViewController {
                        switch self.summaryListType {
                        case .current:
                            myList.listType = .current
                        case .upcoming:
                            myList.listType = .upcoming
                        default:
                            myList.listType = .past
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func getStartedButtonAction(_ sender: Any) {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - getStartedButtonAction"))
        self.invokeLocationSendApi()
    }

    @IBAction func countryBtnTapped(_ sender: Any) {
        let country = SelectTravelCountryViewController.loadFromNib()
        country.countryType = .fromCountry
        country.delegate = self
        self.present(country, animated: true)
    }
    
    @IBAction func currentLocationButtonAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - currentLocationButtonAction"))
        if let travel = self.currentTravelResponse.first {
            switch travel?.confirmStay {
            case true:
                let detail = MyTravelDetailViewController.loadFromNib()
                detail.hidesBottomBarWhenPushed = true
                detail.delegate = self
                detail.viewDidAppear(true)
                detail.travelID = travel?.travelId ?? ""
                self.navigationController?.pushViewController(detail, animated: true)
            default:
                let selectedDate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                dateFormatter.timeZone = TimeZone.current
                self.currentDataFromConfirmStay.text = dateFormatter.string(from: selectedDate)
                DispatchQueue.main.async {
                    self.confirmStayPopupView.isHidden = false
                    self.currentCountryFromConfirmStay.text = travel?.destination?.countryName ?? ""
                    self.confirmStayHandler.destination = travel?.destination?.countryCode ?? ""
                    self.confirmStayHandler.existingId = travel?.travelId ?? ""
                    self.tabBarController?.tabBar.isUserInteractionEnabled = false
                }
            }
        }

    }
    
    @IBAction func submitConfirmStayButtonAction(_ sender: UIButton) {
        guard !self.confirmStayHandler.startDate.isEmpty else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select from when you have been in this country?", image: nil,theme: .default)
        }
        self.confirmStayAPI()
    }
    
    @IBAction func updateNowButtonAction(_ sender: Any) {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - updateNowButtonAction"))
        let profile = MyProfileViewController.loadFromNib()
        profile.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(profile, animated: true)
    }
    
    @IBAction func closeConfirmStayButtonAction(_ sender: Any) {
        confirmStayClosePopupAPI()
    }
        
    //MARK: - UnitTest case
    
    func uniTestcase() {
        self.doneStartDatePicker()
        self.doneTravelArrrivedFrom()
        self.configurations()
        self.selectCurrentYear()
        self.selectCurrentMinusOneYear()
        self.selectCurrentMinusTwoYear()
        _ = self.setupCircularProgressView()
        self.invokeLocationSendApi()
        self.locationDetectSuccessCallback()
        self.getNewUserRecordAPI()
        self.arrivedCountryAction(UIButton())
        
        let origin = Origin(countryId: 0, countryCode: "test", countryCodeThreeLetter: "test", countryDialCode: "test", countryName: "test")
        
        let entity = TravelListEntity(travelId: "", userID: nil, origin: origin, destination: origin, startDate: "test", endDate: "test", taxableDays: 0, numberOfTaxDaysLeft: 0, numberOfTaxDaysUsed: 0, definitionOfTaxDays: "test", fiscalStartYear: "test", fiscalEndYear: "test", thresholdDays: 0, travelType: nil, workDays: 0, otherTravelType: "test", nonWorkingDays: "test", totalDays: 0, daysAway: 0, createdOn: "test", updatedOn: "test", checklist: "test", travelHotel: "test", foodEntertainment: "test", shoppingUtility: "test", others: "test", totalDaysRemaining: 0, workDaysRemaining: 0, nonWorkDaysRemaining: 0, totalDaysCompleted: 0, workDaysCompleted: 0, nonWorkDaysCompleted: 0, totalNonWorkDays: 0, totalWorkDays: 0, resident: true, confirmStay: true, totalPhysicalPresenceDays: 0)
        setupCurrentTravelDetail(entity)
        
        
        let entity2 = TravelListEntity(travelId: "", userID: nil, origin: origin, destination: origin, startDate: "test", endDate: "test", taxableDays: 0, numberOfTaxDaysLeft: 0, numberOfTaxDaysUsed: 0, definitionOfTaxDays: "test", fiscalStartYear: "test", fiscalEndYear: "test", thresholdDays: 0, travelType: nil, workDays: 0, otherTravelType: "test", nonWorkingDays: "test", totalDays: 0, daysAway: 0, createdOn: "test", updatedOn: "test", checklist: "test", travelHotel: "test", foodEntertainment: "test", shoppingUtility: "test", others: "test", totalDaysRemaining: 0, workDaysRemaining: 0, nonWorkDaysRemaining: 0, totalDaysCompleted: 0, workDaysCompleted: 0, nonWorkDaysCompleted: 0, totalNonWorkDays: 0, totalWorkDays: 0, resident: false, confirmStay: true, totalPhysicalPresenceDays: 0)
        setupCurrentTravelDetail(entity2)
        self.createTravel(UIButton())
        self.recentViewallAciton(UIButton())
        self.notificationBtnTapped(UIButton())
        self.summaryAllButtonAciton(UIButton())
        self.countryBtnTapped(UIButton())
        
        let currentRecord = TravelListEntity(travelId: "", userID: nil, origin: origin, destination: origin, startDate: "test", endDate: "test", taxableDays: 0, numberOfTaxDaysLeft: 0, numberOfTaxDaysUsed: 0, definitionOfTaxDays: "test", fiscalStartYear: "test", fiscalEndYear: "test", thresholdDays: 0, travelType: nil, workDays: 0, otherTravelType: "test", nonWorkingDays: "test", totalDays: 0, daysAway: 0, createdOn: "test", updatedOn: "test", checklist: "test", travelHotel: "test", foodEntertainment: "test", shoppingUtility: "test", others: "test", totalDaysRemaining: 0, workDaysRemaining: 0, nonWorkDaysRemaining: 0, totalDaysCompleted: 0, workDaysCompleted: 0, nonWorkDaysCompleted: 0, totalNonWorkDays: 0, totalWorkDays: 0, resident: true, confirmStay: true, totalPhysicalPresenceDays: 0)
        self.currentTravelResponse = [currentRecord]
        self.currentLocationButtonAction(UIButton())

        let currentRecord2 = TravelListEntity(travelId: "", userID: nil, origin: origin, destination: origin, startDate: "test", endDate: "test", taxableDays: 0, numberOfTaxDaysLeft: 0, numberOfTaxDaysUsed: 0, definitionOfTaxDays: "test", fiscalStartYear: "test", fiscalEndYear: "test", thresholdDays: 0, travelType: nil, workDays: 0, otherTravelType: "test", nonWorkingDays: "test", totalDays: 0, daysAway: 0, createdOn: "test", updatedOn: "test", checklist: "test", travelHotel: "test", foodEntertainment: "test", shoppingUtility: "test", others: "test", totalDaysRemaining: 0, workDaysRemaining: 0, nonWorkDaysRemaining: 0, totalDaysCompleted: 0, workDaysCompleted: 0, nonWorkDaysCompleted: 0, totalNonWorkDays: 0, totalWorkDays: 0, resident: true, confirmStay: false, totalPhysicalPresenceDays: 0)
        self.currentTravelResponse = [currentRecord2]
        self.currentLocationButtonAction(UIButton())
        submitConfirmStayButtonAction(UIButton())
        updateNowButtonAction(UIButton())
        confirmStayAPI()
        confirmStayClosePopupAPI()
    }

}

extension DashBoardViewController:RefreshAppDelegate {
    func didAppRefreshBegin() {
        locationDetectSuccessCallback()
    }
}
