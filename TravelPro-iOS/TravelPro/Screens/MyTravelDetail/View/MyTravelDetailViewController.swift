//
//  MyTravelDetailViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 17/05/23.
//

import UIKit
import FSCalendar

@objc protocol MyTravelDetailViewControllerDelegate: AnyObject {
    func didTravelDeleted(_ selectedTYpe:String)
    func didPressBack()
}

class MyTravelDetailViewController: UIViewController {

    // MARK: - Properties
    var listStatus:ListStatus = .closed
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var selectedDatesRange:[Date]?
    var travelDetailViewModel = MyTravelDetailViewModel()
    var travelID:String = ""
    var travelList:[CountryListObject]?
    var delegate:MyTravelDetailViewControllerDelegate?
    var addAttachmentFiles:[String] = []
    
    var entityObject:EntityObject?
    var selectedlistType:TravelListType = .all
    
    var travelHotel = [String]()
    var foodEntertainment = [String]()
    var shoppingUtility = [String]()
    var others = [String]()
    var headerTitleArray = ["Travel and Hotel", "Food and Entertainment", "Shopping and Utility", "Others"]
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tripListTableView: UITableView!
    @IBOutlet weak var attachmentListTableView: UITableView!
    @IBOutlet weak var tripTableHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var tripListView: CustomViewShadow!
    @IBOutlet weak var expandCloseButton: UIButton!
    @IBOutlet weak var countryTitleLabel: UILabel!
    @IBOutlet weak var totalDaysLabel: UILabel!
    @IBOutlet weak var physicalPresenceLabel: UILabel!
    @IBOutlet weak var residentView: CustomView!
    @IBOutlet weak var residentLabel: UILabel!
    @IBOutlet weak var attachmentNoDataLabel: UILabel!

    
    // MARK: - View life cycle
   
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        NotificationCenter.default.addObserver(self, selector: #selector(APIRefreshCallback), name: Notification.Name("RefreshAppForeground"), object: nil)
//        setupCalendar()
    }
    // MARK: - ViewDidAppear

    override func viewDidAppear(_ animated: Bool) {
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.appRefreshDelegate = self
        self.travelDetailAPI()
    }
    
    // MARK: - Private methods
    
    /// SetupUI
    private func setupUI() {
        self.tripListTableView.contentInset = UIEdgeInsets.zero
        self.tripListTableView.register(UINib(nibName: TripDetailListTableViewCell.TableReuseIdentifier, bundle: nil),forCellReuseIdentifier: TripDetailListTableViewCell.TableReuseIdentifier)
//        self.attachmentListTableView.register(UINib(nibName: AttachmentProgressTableViewCell.TableReuseIdentifier, bundle: nil),forCellReuseIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier)
    }
    
//    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
//        TravelTaxMixPanelAnalytics(action: .mytravel_detail, state: .info, data: MixPanelData(message: "MyTravelDetailViewController - configure cell"))
//
//        let diyCell = (cell as! DIYCalendarCell)
//        if position == .current {
//
//            var selectionType = SelectionType.none
//
//            if self.fscalendar.selectedDates.contains(date) {
//                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
//                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
//                if self.fscalendar.selectedDates.contains(date) {
//                    if self.fscalendar.selectedDates.contains(previousDate) && self.fscalendar.selectedDates.contains(nextDate) {
//                        selectionType = .middle
//                    }
//                    else if self.fscalendar.selectedDates.contains(previousDate) && self.fscalendar.selectedDates.contains(date) {
//                        selectionType = .rightBorder
//                    }
//                    else if self.fscalendar.selectedDates.contains(nextDate) {
//                        selectionType = .leftBorder
//                    }
//                    else {
//                        selectionType = .single
//                    }
//                }
//            }
//            else {
//                selectionType = .none
//            }
//            if selectionType == .none {
//                diyCell.selectionLayer.isHidden = true
//                return
//            }
//            diyCell.selectionLayer.isHidden = false
//            diyCell.selectionType = selectionType
//
//        } else {
//            diyCell.selectionLayer.isHidden = true
//        }
//    }
    
//    private func setupCalendarDateRange(_ startDate:Date, _ endDate:Date) {
//        let dates = utilsClass.sharedInstance.datesRange(from: startDate, to: endDate)
//        selectedDatesRange = dates
//        selectedDatesRange?.forEach { (date) in
//            self.fscalendar.select(date, scrollToDate: false)
//        }
//        // For UITest
//        self.fscalendar.accessibilityIdentifier = "calendar"
//        self.configureVisibleCells()
//    }
    
//    private func configureVisibleCells() {
//        self.fscalendar.visibleCells().forEach { (cell) in
//            let date = self.fscalendar.date(for: cell)
//            let position = self.fscalendar.monthPosition(for: cell)
//            self.configure(cell: cell, for: date!, at: position)
//        }
//    }
    
    private func travelDetailAPI() {
        self.travelDetailViewModel.travelDetail(userID:  UserDefaultModule.shared.getUserID() ?? "", travelID: self.travelID, enableLoader: true,controller: self) { response in
            switch response.status?.status {
            case 200:
                TravelTaxMixPanelAnalytics(action: .mytravel_detail, state: .info, data: MixPanelData(message: "MyTravelDetailViewController - travelDetailAPI success: \(response)"))
                self.entityObject = response.entity
                self.setupTravelData(response.entity)

            default:
                TravelTaxMixPanelAnalytics(action: .mytravel_detail, state: .info, data: MixPanelData(message: "MyTravelDetailViewController - travelDetailAPI not success: \(response)"))
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: response.status?.msg ?? "Unsuccess", image: UIImage(named: "Notification") ?? nil,theme: .custom)
            }
            
        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .mytravel_detail, state: .info, data: MixPanelData(message: "MyTravelDetailViewController - travelDetailAPI Error: \(error)"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }

    }
    private func setupTravelData(_ data:EntityObject?) {
        TravelTaxMixPanelAnalytics(action: .mytravel_detail, state: .info, data: MixPanelData(message: "MyTravelDetailViewController - setupTravelData"))
        guard (data != nil) else {
            return
        }
        if let countryRecord = data?.currentRecord {
            TravelTaxMixPanelAnalytics(action: .mytravel_detail, state: .info, data: MixPanelData(message: "MyTravelDetailViewController - setupTravelData current \(countryRecord)"))
            
            self.physicalPresenceLabel.text = "\(countryRecord.totalPhysicalPresenceDays ?? 0)"
            
            self.countryTitleLabel.text = countryRecord.destination?.countryName
            updateResident(countryRecord.resident ?? false)
            self.totalDaysLabel.text = "\(countryRecord.taxableDays ?? 0)"
//            let progress = Float((countryRecord.numberOfTaxDaysLeft ?? 0)) / Float((countryRecord.totalDays ?? 0))
//            var progress = Float((countryRecord.totalDays ?? 0)) / Float((countryRecord.totalDaysCompleted ?? 0))
//            if countryRecord.totalDays ?? 0 == 0 || countryRecord.totalDaysCompleted ?? 0 == 0 {
//                progress = 0.0
//            }
//            setupCalendarDateRange(countryRecord.startDate?.timeStampDateFormat() ?? Date(), countryRecord.endDate?.timeStampDateFormat() ?? Date())
            self.travelHotel = data?.currentRecord?.travelHotel?.components(separatedBy: ",") ?? [""]
            self.foodEntertainment = data?.currentRecord?.foodEntertainment?.components(separatedBy: ",") ?? [""]
            self.shoppingUtility = data?.currentRecord?.shoppingUtility?.components(separatedBy: ",") ?? [""]
            self.others = data?.currentRecord?.others?.components(separatedBy: ",") ?? [""]
            
            // set attachment
//            for value in 0...3 {
//                if value == 0 {
//                    if let one = countryRecord.attachment1, one.count > 0 {
//                        self.addAttachmentFiles.append(one)
//                    }
//                }
//                else if value == 1 {
//                    if let two = countryRecord.attachment2, two.count > 0 {
//                        self.addAttachmentFiles.append(two)
//                    }
//                }
//                else if value == 2 {
//                    if let three = countryRecord.attachment3, three.count > 0 {
//                        self.addAttachmentFiles.append(three)
//                    }
//                }
//                else if value == 3 {
//                    if let four = countryRecord.attachment4, four.count > 0 {
//                        self.addAttachmentFiles.append(four)
//                    }
//                }
//            }
//            let dataValue = max(max(self.travelHotel.count, self.foodEntertainment.count), max(self.shoppingUtility.count, self.others.count))
//            switch dataValue {
//            case 0:
//                self.attachmentNoDataLabel.isHidden = false
//                self.attachmentNoDataLabel.text = "No data found"
//            default:
//                self.attachmentNoDataLabel.isHidden = true
//                self.attachmentNoDataLabel.text = ""
//            }
//            self.attachmentListTableView.reloadData()
        }
        
        if let travelList = data?.countryList, travelList.count > 0 {
            self.travelList = travelList
            switch self.listStatus {
            case .closed:
//                self.tripTableHeightConstrain.constant = 86.0
                self.tripListView.layoutIfNeeded()
            default:
//                self.tripTableHeightConstrain.constant = CGFloat(travelList.count) * 86.0
                self.tripListView.layoutIfNeeded()
            }
            self.tripListTableView.reloadData()
        } else {
            //
        }
        
        
    }
    
    private func addEditData(_ entity:EntityObject?) -> CreateTravelHelper {
        TravelTaxMixPanelAnalytics(action: .mytravel_detail, state: .info, data: MixPanelData(message: "MyTravelDetailViewController - addEditData:"))
        guard (entity != nil) else {
            return CreateTravelHelper()
        }
        var editTravelHandler = CreateTravelHelper()
        editTravelHandler.fromCountry = entity?.currentRecord?.origin?.countryId ?? 0
        editTravelHandler.toCountry = entity?.currentRecord?.destination?.countryId ?? 0
        editTravelHandler.fromCountryString = entity?.currentRecord?.origin?.countryName ?? ""
        editTravelHandler.toCountryString = entity?.currentRecord?.destination?.countryName ?? ""
        editTravelHandler.startDateString = entity?.currentRecord?.startDate ?? ""
        editTravelHandler.endDateString = entity?.currentRecord?.endDate ?? ""
        editTravelHandler.noWorkDays = "\(entity?.currentRecord?.taxableDays ?? 0)"
        editTravelHandler.definitionDay = entity?.currentRecord?.definitionOfTaxDays
        editTravelHandler.fiscalYearStart = entity?.currentRecord?.fiscalStartYear ?? ""
        editTravelHandler.fiscalYearEnd = entity?.currentRecord?.fiscalEndYear ?? ""
        editTravelHandler.alertThresholdDays = "\(entity?.currentRecord?.thresholdDays ?? 0)"
        editTravelHandler.travelType = entity?.currentRecord?.travelType?.type ?? ""
        editTravelHandler.travelTypeID = entity?.currentRecord?.travelType?.id ?? 0
        editTravelHandler.travelTypeOthers = entity?.currentRecord?.otherTravelType ?? ""
        editTravelHandler.travelNotes = entity?.currentRecord?.checklist ?? ""
        editTravelHandler.nonWorkDays = [""]
        return editTravelHandler
    }

    private func updateResident(_ isResident:Bool) {
        switch isResident {
        case false:
            self.residentLabel.text = "Non-Resident"
            self.residentLabel.textColor =  UIColor.nonResidentColor.withAlphaComponent(1.0)
            self.residentView.backgroundColor = UIColor.nonResidentColor
        default:
            self.residentLabel.text = "Resident"
            self.residentLabel.textColor =  UIColor.residentColor.withAlphaComponent(1.0)
            self.residentView.backgroundColor = UIColor.residentColor
        }
    }
    
    @objc func APIRefreshCallback() {
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.isAppBackground = false
        DispatchQueue.main.async {
            self.travelDetailAPI()
        }
    }
  
    // MARK: - Network requests
    private func deleteTravelAPI() {
        self.travelDetailViewModel.deleteTravel(userID: UserDefaultModule.shared.getUserID() ?? "", travelID: self.travelID, enableLoader: true,controller: self) { response in
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            if let tabBarController = appDelegate?.window!.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 1
            }
            
            if let navigation = self.navigationController {
                navigation.popToRootViewController(animated: true)
            }
            self.delegate?.didTravelDeleted(self.selectedlistType.rawValue)
            TravelTaxMixPanelAnalytics(action: .mytravel_detail, state: .info, data: MixPanelData(message: "MyTravelDetailViewController - deleteTravelAPI success"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Successfully deleted", image: UIImage(named: "Notification") ?? nil,theme: .custom)
            
        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .mytravel_detail, state: .info, data: MixPanelData(message: "MyTravelDetailViewController - deleteTravelAPI Error \(error)"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }
        
    }
    
    private func deleteTravelAlert() {
        
        let alert = UIAlertController(title: "TravelTaxDay", message: "Are you sure you want to delete this travel record?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            self.deleteTravelAPI()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in})
        alert.addAction(yes)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - User interactions

    @IBAction func expandCloseButtonAction(_ sender: UIButton) {
        switch self.listStatus {
        case .closed:
            self.listStatus = .expanded
            self.expandCloseButton.setImage(UIImage(named: "circleArrowUp"), for: .normal)
            if let travelList = self.travelList, travelList.count > 0 {
//                self.tripTableHeightConstrain.constant = CGFloat(travelList.count) * 86.0
                self.tripListView.layoutIfNeeded()
            }
        default:
            self.expandCloseButton.setImage(UIImage(named: "circleArrowDown"), for: .normal)
//            self.tripTableHeightConstrain.constant = 86.0
            self.tripListView.layoutIfNeeded()
            self.listStatus = .closed
        }
        self.tripListTableView.reloadData()
    }
    
    @IBAction func menuOptionButtonAction(_ sender: UIButton) {
        let actionSheetController = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ -> Void in }
        let editAction = UIAlertAction(title: "Edit", style: .default) { _ -> Void in
            let editData = self.addEditData(self.entityObject)
            let edit = CreateNewTravelViewController.loadFromNib()
            edit.manageTravel = .edit
            edit.travelID = self.travelID
            edit.createTravelHandler = editData
            var travelHotel = (self.entityObject?.currentRecord?.travelHotel ?? "").components(separatedBy: ",")
            var foodEntertainment = (self.entityObject?.currentRecord?.foodEntertainment ?? "").components(separatedBy: ",")
            var shoppingUtility = (self.entityObject?.currentRecord?.shoppingUtility ?? "").components(separatedBy: ",")
            var others = (self.entityObject?.currentRecord?.others ?? "").components(separatedBy: ",")
            let travelNotes = self.entityObject?.currentRecord?.checklist ?? ""
            
            if travelHotel.count > 0 {
                if travelHotel[0] == "" {
                    travelHotel = []
                }
            }
            
            if foodEntertainment.count > 0 {
                if foodEntertainment[0] == "" {
                    foodEntertainment = []
                }
            }
            
            if shoppingUtility.count > 0 {
                if shoppingUtility[0] == "" {
                    shoppingUtility = []
                }
            }
            
            if others.count > 0 {
                if others[0] == "" {
                    others = []
                }
            }
            
            edit.editTravel(travelDoc: travelHotel, foodDoc: foodEntertainment, shoppingDoc: shoppingUtility, otherDoc: others, travelNotes: travelNotes)
            self.navigationController?.pushViewController(edit, animated: true)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ -> Void in
            self.deleteTravelAlert()
        }
        actionSheetController.addAction(cancelAction)
        actionSheetController.addAction(editAction)
        actionSheetController.addAction(deleteAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.delegate?.didPressBack()
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UniteTestcase
    
    func uniteTestcase() {
        
        let conuntryList = CountryListObject(origin: "test", destination: "test", startDate: "test", endDate: "test", travelID: "test", createdBy: "test", physicalPresenceDays: 0)
        let origin = Origin(countryId: 0, countryCode: "test", countryCodeThreeLetter: "test", countryDialCode: "test", countryName: "test")
        let currentRecord = TravelListEntity(travelId: "", userID: nil, origin: origin, destination: origin, startDate: "test", endDate: "test", taxableDays: 0, numberOfTaxDaysLeft: 0, numberOfTaxDaysUsed: 0, definitionOfTaxDays: "test", fiscalStartYear: "test", fiscalEndYear: "test", thresholdDays: 0, travelType: nil, workDays: 0, otherTravelType: "test", nonWorkingDays: "test", totalDays: 0, daysAway: 0, createdOn: "test", updatedOn: "test", checklist: "test", travelHotel: "test", foodEntertainment: "test", shoppingUtility: "test", others: "test", totalDaysRemaining: 0, workDaysRemaining: 0, nonWorkDaysRemaining: 0, totalDaysCompleted: 0, workDaysCompleted: 0, nonWorkDaysCompleted: 0, totalNonWorkDays: 0, totalWorkDays: 0, resident: true, confirmStay: true, totalPhysicalPresenceDays: 0)
        let entity = EntityObject(countryList: [conuntryList], currentRecord:currentRecord )
        self.setupTravelData(entity)
        let _ = addEditData(entity)
        updateResident(true)
        updateResident(false)
        self.deleteTravelAPI()
        self.deleteTravelAlert()
        menuOptionButtonAction(UIButton())
        
    }
}


// MARK: - Extension

extension MyTravelDetailViewController: UITableViewDataSource, UITableViewDelegate {
   
    // MARK: - UITableViewDataSource & UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
        case attachmentListTableView:
            return 4
        
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case attachmentListTableView:
            switch section {
            case 0:
                if self.travelHotel.count > 0, self.travelHotel[0] == "" {
                    return 0
                }
                return self.travelHotel.count
            case 1:
                if self.foodEntertainment.count > 0, self.foodEntertainment[0] == "" {
                    return 0
                }
                return self.foodEntertainment.count
            case 2:
                if self.shoppingUtility.count > 0, self.shoppingUtility[0] == "" {
                    return 0
                }
                return self.shoppingUtility.count
            case 3:
                if self.others.count > 0, self.others[0] == "" {
                    return 0
                }
                return self.others.count
            default:
                return 0
            }
        
        default:
            return self.travelList?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
        case attachmentListTableView:
            return 60
        default:
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView {
        case attachmentListTableView:
            return headerDetailsView(titleStr: headerTitleArray[section])
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case attachmentListTableView:
            switch indexPath.section {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
                
                let urlItem = self.travelHotel[indexPath.row]
                
                var separateName = String()
                let docName = urlItem.components(separatedBy: "/")[1]
                if docName.components(separatedBy: "_traveltax_").count > 1 {
                    separateName = docName.components(separatedBy: "_traveltax_")[1]
                } else {
                    separateName = docName
                }
                
                cell.documentNameLbl.text = separateName
                cell.progressView.isHidden = true
                cell.uploadReadingLbl.isHidden = true
                cell.documentCloseBtn.isHidden = true
                cell.contentView.backgroundColor = UIColor(named: "lightBlueAndGray")
                
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
                
                let urlItem = self.foodEntertainment[indexPath.row]
                
                var separateName = String()
                let docName = urlItem.components(separatedBy: "/")[1]
                if docName.components(separatedBy: "_traveltax_").count > 1 {
                    separateName = docName.components(separatedBy: "_traveltax_")[1]
                } else {
                    separateName = docName
                }
                cell.documentNameLbl.text = separateName
                cell.progressView.isHidden = true
                cell.uploadReadingLbl.isHidden = true
                cell.documentCloseBtn.isHidden = true
                cell.contentView.backgroundColor = UIColor(named: "lightBlueAndGray")
                
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
                
                let urlItem = self.shoppingUtility[indexPath.row]
                
                var separateName = String()
                let docName = urlItem.components(separatedBy: "/")[1]
                if docName.components(separatedBy: "_traveltax_").count > 1 {
                    separateName = docName.components(separatedBy: "_traveltax_")[1]
                } else {
                    separateName = docName
                }
                cell.documentNameLbl.text = separateName
                cell.progressView.isHidden = true
                cell.uploadReadingLbl.isHidden = true
                cell.documentCloseBtn.isHidden = true
                cell.contentView.backgroundColor = UIColor(named: "lightBlueAndGray")
                
                return cell
            case 3:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
                
                let urlItem = self.others[indexPath.row]
                
                var separateName = String()
                let docName = urlItem.components(separatedBy: "/")[1]
                if docName.components(separatedBy: "_traveltax_").count > 1 {
                    separateName = docName.components(separatedBy: "_traveltax_")[1]
                } else {
                    separateName = docName
                }
                cell.documentNameLbl.text = separateName
                cell.progressView.isHidden = true
                cell.uploadReadingLbl.isHidden = true
                cell.documentCloseBtn.isHidden = true
                cell.contentView.backgroundColor = UIColor(named: "lightBlueAndGray")
                
                return cell
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
                
                let urlItem = self.travelHotel[indexPath.row]
                
                var separateName = String()
                let docName = urlItem.components(separatedBy: "/")[1]
                if docName.components(separatedBy: "_traveltax_").count > 1 {
                    separateName = docName.components(separatedBy: "_traveltax_")[1]
                } else {
                    separateName = docName
                }
                cell.documentNameLbl.text = separateName
                cell.progressView.isHidden = true
                cell.uploadReadingLbl.isHidden = true
                cell.documentCloseBtn.isHidden = true
                cell.contentView.backgroundColor = UIColor(named: "lightBlueAndGray")
                
                return cell
            }
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TripDetailListTableViewCell.TableReuseIdentifier, for: indexPath) as? TripDetailListTableViewCell else { return UITableViewCell() }
            cell.updateUIData(self.travelList?[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case attachmentListTableView:
            return 55.0
        default:
            return 118.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = MyTravelDetailSummaryViewController.loadFromNib()
        guard let travelId = self.travelList?[indexPath.row].travelID else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Travel Id is missing for this travel", image: UIImage(named: "Notification") ?? nil, theme: .custom)
        }
        detail.travelID = travelId
        detail.createdBy = self.travelList?[indexPath.row].createdBy ?? ""
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func headerDetailsView(titleStr: String) -> UIView {
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: attachmentListTableView.frame.width, height: 60)
        contentView.backgroundColor = UIColor(named: "lightBlueAndGray")
        
        let attachImageView = UIImageView()
        attachImageView.image = UIImage(named: "imageAttach")
        attachImageView.frame = CGRect(x: 15, y: (60-25)/2, width: 25, height: 25)
        contentView.addSubview(attachImageView)
        
        let titleLbl = UILabel()
        titleLbl.frame = CGRect(x: 50, y: 15, width: 150, height: 30)
        titleLbl.text = titleStr
        titleLbl.textColor = UIColor(named: "GrayColor")
        titleLbl.font = .fontR14
        contentView.addSubview(titleLbl)
        
        return contentView
    }
}

//extension MyTravelDetailViewController:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
//
//    //MARK: - FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance
//    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
//        cell.isUserInteractionEnabled = false
//        return cell
//    }
//
//    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
//        self.configure(cell: cell, for: date, at: position)
//    }
//
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return nil
//    }
//
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        return 0
//    }
//
//    // MARK:- FSCalendarDelegate
//
//    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        self.fscalendar.frame.size.height = bounds.height
//    }
//
//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
//        return monthPosition == .current
//    }
//
//    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//        return monthPosition == .current
//    }
//
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
////        print("did select date \(self.formatter.string(from: date))")
////
////        guard let range = self.selectedDatesRange,range.count == 0 else {
////            return
////        }
//        if let range = self.selectedDatesRange,range.count > 0 {
//            return
//        }
//        self.configureVisibleCells()
//    }
//
//    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        print("did deselect date \(self.formatter.string(from: date))")
//        if let range = self.selectedDatesRange,range.count > 0 {
//            return
//        }
//        self.configureVisibleCells()
//
////        let contains = self.selectedDatesRange?.filter({ val in
////            let dateConvert = self.formatter.string(from: val)
////            let inputDate = self.formatter.string(from: date)
////            return dateConvert == inputDate
////        })
////        if let object = contains,object.count > 0{
////            self.selectedDatesRange?.removeAll(where: { value in
////                value == object.first
////            })
////            self.nonWorkDayDates?.append(object.first ?? Date())
////            self.nonWorkDayCountLabel.text = "\(self.nonWorkDayDates?.count ?? 0)"
////             let workDay = Int(self.workDayCountLabel.text ?? "0") ?? 0 - (self.nonWorkDayDates?.count ?? 0)
////             self.workDayCountLabel.text = "\(workDay)"
////            self.configureVisibleCells()
////        }
//
//    }
//
//    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
//        print("did deselect date \(self.formatter.string(from: date))")
//        self.configureVisibleCells()
//    }
//
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
//        if self.gregorian.isDateInToday(date) {
//            return [UIColor.orange]
//        }
//        return [appearance.eventDefaultColor]
//    }
//
//
//}

extension MyTravelDetailViewController:RefreshAppDelegate {
    func didAppRefreshBegin() {
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.isAppBackground = false
        DispatchQueue.main.async {
            self.travelDetailAPI()
        }
    }
}

//MARK: - Enum

enum ListStatus:String {
    case expanded
    case closed
}
