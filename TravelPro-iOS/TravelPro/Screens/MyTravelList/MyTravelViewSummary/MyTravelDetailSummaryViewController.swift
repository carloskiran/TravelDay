//
//  MyTravelDetailSummaryViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 23/06/23.
//

import UIKit
import UniformTypeIdentifiers
import AWSCore
import AWSS3
import CoreLocation

class MyTravelDetailSummaryViewController: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var residentStatusLbl: UILabel!
    @IBOutlet weak var residentStatusView: CustomView!
    @IBOutlet weak var attachmentTableView: UITableView!
    @IBOutlet weak var travelNotesTxtView: UITextView!
    @IBOutlet weak var travelNotesTitleLbl: UILabel!
    @IBOutlet weak var travelNotesViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var physicalPresenceDayCountLbl: UILabel!
    @IBOutlet weak var physicalPresenceDayLbl: UILabel!
    @IBOutlet weak var DepartureCountryName: UILabel!
    @IBOutlet weak var DepartureTiming: UILabel!
    @IBOutlet weak var destinationCountryName: UILabel!
    @IBOutlet weak var destinationTiming: UILabel!
    @IBOutlet weak var travelNoteView: UIView!
    @IBOutlet weak var tableviewHeightConstrain: NSLayoutConstraint!
    
//    var travelHotel = [String]()
//    var foodEntertainment = [String]()
//    var shoppingUtility = [String]()
//    var others = [String]()
    var notesText = String()
    var headerTitleArray = ["Travel and Hotel", "Food and Entertainment", "Shopping and Utility", "Others"]
    var travelDetailViewModel = MyTravelDetailViewModel()
    var entityObject:EntityObject?
    var summaryEntityObject: TravelSummaryEntity?
    var travelList:[CountryListObject]?
    var travelID:String = ""
    var listStatus:ListStatus = .closed
//    var isTravelAndHotelEnable : Bool = false
//    var isFoodAndEntertainmentEnable : Bool = false
//    var isShoppingAndUntilityEnable : Bool = false
//    var isOtherEnable : Bool = false
    var currentDateInFormat: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
            dateFormatter.dateFormat = "MMM dd, yyyy"
            return dateFormatter.string(from: Date())
        }
    }
    let createTravelViewModel = CreateNewTravelViewModel()
    var recordEditable:RecordEditable = .editable
    var createTravelHandler:CreateTravelHelper! = CreateTravelHelper()

    //==
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
    
    var isTravelAndHotelEnable : Bool = true
    var isFoodAndEntertainmentEnable : Bool = true
    var isShoppingAndUntilityEnable : Bool = true
    var isOtherEnable : Bool = true
    var selectedDocumentCategory: documentCategory!
    var createdBy:String = ""
    let locationManager = CLLocationManager()
    var currentCountryCode:String = ""
    var isCurrentDate:Bool = false
    var isCurrentCountry:Bool = false

    //==
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableviewCells()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.APIRefreshCallback), name: Notification.Name("RefreshAppForeground"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
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
        self.attachmentTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.appRefreshDelegate = self
        travelDetailAPI()
        setupLocationManager()
    }
    
    func registerTableviewCells() {
        self.attachmentTableView.register(UINib(nibName: AttachmentProgressTableViewCell.TableReuseIdentifier, bundle: nil),forCellReuseIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier)
    }
  
    @objc func APIRefreshCallback() {
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.isAppBackground = false
        DispatchQueue.main.async {
            self.travelDetailAPI()
        }
    }
    
    func setupLocationManager() {
        TravelTaxMixPanelAnalytics(action: .locationManager, state: .info, data: MixPanelData(message: "LocationManager - setupLocationManager"))
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.distanceFilter = 200.0
        locationManager.startUpdatingLocation()
    }
    
    internal func openDocumentWithAlert() {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - openDocumentWithAlert"))
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let travelAction = UIAlertAction(title: "Travel and Hotel", style: .default) { controller in
                self.selectedDocumentCategory = .TravelAndHotel
                self.openDocument()
            }
            let foodAction = UIAlertAction(title: "Food and Entertainment", style: .default) { controller in
                self.selectedDocumentCategory = .FoodAndEntertainment
                self.openDocument()
            }
            let shoppingAction = UIAlertAction(title: "Shopping and Utility", style: .default) { controller in
                self.selectedDocumentCategory = .ShoppingAndUtility
                self.openDocument()
            }
            let othersAction = UIAlertAction(title: "Others", style: .default) { controller in
                self.selectedDocumentCategory = .Others
                self.openDocument()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { controller in
                
            }
            alert.addAction(travelAction)
            alert.addAction(foodAction)
            alert.addAction(shoppingAction)
            alert.addAction(othersAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
        }
    }
    
    internal func openDocument() {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - openDocument"))
        let supportedTypes = [UTType.jpeg,UTType.pdf,UTType.spreadsheet]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.shouldShowFileExtensions = true
        present(documentPicker, animated: true, completion: nil)
    }
    
    internal func setupTravelEditData() {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - setupTravelEditData"))
        guard let editData = self.createTravelHandler else {
            return
        }
        //From Country
        self.createTravelHandler.fromCountry = editData.fromCountry
        self.createTravelHandler.fromCountryString = editData.fromCountryString
        //To Country
        self.createTravelHandler.toCountry = editData.toCountry
        self.createTravelHandler.toCountryString = editData.toCountryString
        //Start date
        self.createTravelHandler.startDateString = editData.startDateString?.timeStampDateWithMilliseconds()
        //End date
        self.createTravelHandler.endDateString = editData.endDateString?.timeStampDateWithMilliseconds()
        // Maximum Days
        self.createTravelHandler.noWorkDays = editData.noWorkDays
        // definition Days
        self.createTravelHandler.definitionDay = editData.definitionDay
        //fiscal start
        self.createTravelHandler.fiscalYearStart = editData.fiscalYearStart?.timeStampWithoutUtcConversion()
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
        //Alert threshold
        self.createTravelHandler.alertThresholdDays = editData.alertThresholdDays
        //travel type
        self.createTravelHandler.travelType = editData.travelType
        self.createTravelHandler.travelTypeID = editData.travelTypeID
        //travel notes
        self.createTravelHandler.travelNotes = editData.travelNotes
        //travel type others
        self.createTravelHandler.travelTypeOthers = editData.travelTypeOthers
        //setupCalendarDateRange
        self.createTravelHandler.startDate = editData.startDateString?.timeStampDateFormat()
        self.createTravelHandler.endDate = editData.endDateString?.timeStampDateFormat()

    }
    
    
    @objc func removeCellBtnTapped(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - removeCellBtnTapped"))
        print(sender.tag)
        switch sender.accessibilityLabel {
        case "0":
            var duplicateImgDict = self.travelAndHotelArray
            var indexValueForDelete = "\(sender.tag)"
            let sortedArray = duplicateImgDict.sorted { int1, int2 in
                return int1.key < int2.key
            }
            print(duplicateImgDict)
            print(sortedArray)
            let dict = Dictionary(uniqueKeysWithValues: sortedArray.map {($0.key, $0.value)})
            print(dict)
            print(duplicateImgDict)
            let delete = duplicateImgDict.filter { int1 in
                let keys = int1.value
                return keys.absoluteString.range(of: "private/var") != nil
            }
            if delete.count == 1, let keylist = self.travelAndHotelArray.keys.first, keylist != indexValueForDelete {
                indexValueForDelete = keylist
            }
            let urlName = duplicateImgDict[indexValueForDelete]
            duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: indexValueForDelete)
            print(duplicateImgDict)
            self.travelApiCallingEnable.removeValue(forKey: "\(sender.tag)")
            var duplicateDocumentArray = self.travelAndHoterlDocumentArray
            for item in 0..<self.travelAndHoterlDocumentArray.count {
                if travelAndHoterlDocumentArray[item].range(of: urlName?.lastPathComponent ?? "") != nil {
                    let docName = travelAndHoterlDocumentArray[item]
                    duplicateDocumentArray.remove(at: item)
                    AWSManager.shared.deleteUploadDocument(documentName: docName)
                }
            }
            self.travelAndHoterlDocumentArray = duplicateDocumentArray
            if sender.tag < 4 {
                for n in sender.tag..<3 {
                    duplicateImgDict.updateValue(self.travelAndHotelArray["\(n+1)"]!, forKey: "\(n)")
                }
                duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: "3")
            }
            
            let duplicateAPICalling = self.travelApiCallingEnable
            // Sort the dictionary keys in ascending order
            let sortedKeys = duplicateAPICalling.keys.sorted { Int($0)! < Int($1)! }
            // Create a new dictionary with updated sequential index keys
            var updatedDictionary: [String: String] = [:]
            var currentIndex = 0
            for key in sortedKeys {
                updatedDictionary[String(currentIndex)] = duplicateAPICalling[key]
                currentIndex += 1
            }
            travelApiCallingEnable = updatedDictionary
            self.travelAndHotelArray = duplicateImgDict
        case "1":
            var duplicateImgDict = self.foodAndEntertainment
            var indexValueForDelete = "\(sender.tag)"
            let sortedArray = duplicateImgDict.sorted { int1, int2 in
                return int1.key < int2.key
            }
            let delete = duplicateImgDict.filter { int1 in
                let keys = int1.value
                return keys.absoluteString.range(of: "private/var") != nil
            }
            _ = Dictionary(uniqueKeysWithValues: sortedArray.map {($0.key, $0.value)})
            if delete.count == 1, let keylist = self.foodAndEntertainment.keys.first, keylist != indexValueForDelete {
                indexValueForDelete = keylist
            }
            let urlName = duplicateImgDict[indexValueForDelete]
            duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: indexValueForDelete)
            self.foodApiCallingEnable.removeValue(forKey: "\(sender.tag)")
            var duplicateDocumentArray = self.foodAndEntertainmentDocumentArray
            for item in 0..<self.foodAndEntertainmentDocumentArray.count {
                if foodAndEntertainmentDocumentArray[item].range(of: urlName?.lastPathComponent ?? "") != nil {
                    let docName = foodAndEntertainmentDocumentArray[item]
                    duplicateDocumentArray.remove(at: item)
                    print(self.foodAndEntertainmentDocumentArray)
                    AWSManager.shared.deleteUploadDocument(documentName: docName)
                }
            }
            self.foodAndEntertainmentDocumentArray = duplicateDocumentArray
            if sender.tag < 4 {
                for n in sender.tag..<3 {
                    duplicateImgDict.updateValue(self.foodAndEntertainment["\(n+1)"]!, forKey: "\(n)")
                }
                duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: "3")
            }
            let duplicateAPICalling = self.foodApiCallingEnable
            // Sort the dictionary keys in ascending order
            let sortedKeys = duplicateAPICalling.keys.sorted { Int($0)! < Int($1)! }
            // Create a new dictionary with updated sequential index keys
            var updatedDictionary: [String: String] = [:]
            var currentIndex = 0
            for key in sortedKeys {
                updatedDictionary[String(currentIndex)] = duplicateAPICalling[key]
                currentIndex += 1
            }
            self.foodApiCallingEnable = updatedDictionary
            self.foodAndEntertainment = duplicateImgDict
        case "2":
            var duplicateImgDict = self.shoppingAndUtility
            var indexValueForDelete = "\(sender.tag)"
            let sortedArray = duplicateImgDict.sorted { int1, int2 in
                return int1.key < int2.key
            }
            if self.shoppingApiCallingEnable.count == 1 {
                print(self.shoppingApiCallingEnable)
            }
            print(duplicateImgDict)
            print(sortedArray)
            let dict = Dictionary(uniqueKeysWithValues: sortedArray.map {($0.key, $0.value)})
            print(dict)
            print(duplicateImgDict)
            let delete = duplicateImgDict.filter { int1 in
                let keys = int1.value
                return keys.absoluteString.range(of: "private/var") != nil
            }
            if delete.count == 1, let keylist = self.shoppingAndUtility.keys.first, keylist != indexValueForDelete {
                indexValueForDelete = keylist
            }
            let urlName = duplicateImgDict[indexValueForDelete]
            duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: indexValueForDelete)
            print(duplicateImgDict)
            self.shoppingApiCallingEnable.removeValue(forKey: "\(sender.tag)")
            var duplicateDocumentArray = self.shoppingAndUtilityDocumentArray
            for item in 0..<self.shoppingAndUtilityDocumentArray.count {
                if shoppingAndUtilityDocumentArray[item].range(of: urlName?.lastPathComponent ?? "") != nil {
                    let docName = shoppingAndUtilityDocumentArray[item]
                    duplicateDocumentArray.remove(at: item)
                    AWSManager.shared.deleteUploadDocument(documentName: docName)
                }
            }
            self.shoppingAndUtilityDocumentArray = duplicateDocumentArray
            if sender.tag < 4 {
                for n in sender.tag..<3 {
                    duplicateImgDict.updateValue(self.shoppingAndUtility["\(n+1)"]!, forKey: "\(n)")
                }
                duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: "3")
            }
            
            let duplicateAPICalling = self.shoppingApiCallingEnable
            // Sort the dictionary keys in ascending order
            let sortedKeys = duplicateAPICalling.keys.sorted { Int($0)! < Int($1)! }
            // Create a new dictionary with updated sequential index keys
            var updatedDictionary: [String: String] = [:]
            var currentIndex = 0
            for key in sortedKeys {
                updatedDictionary[String(currentIndex)] = duplicateAPICalling[key]
                currentIndex += 1
            }
            self.shoppingApiCallingEnable = updatedDictionary
            self.shoppingAndUtility = duplicateImgDict
        case "3":
            var duplicateImgDict = self.others
            var indexValueForDelete = "\(sender.tag)"
            let sortedArray = duplicateImgDict.sorted { int1, int2 in
                return int1.key < int2.key
            }
            print(duplicateImgDict)
            print(sortedArray)
            let dict = Dictionary(uniqueKeysWithValues: sortedArray.map {($0.key, $0.value)})
            print(dict)
            print(duplicateImgDict)
            let delete = duplicateImgDict.filter { int1 in
                let keys = int1.value
                return keys.absoluteString.range(of: "private/var") != nil
            }
            if delete.count == 1, let keylist = self.others.keys.first, keylist != indexValueForDelete {
                indexValueForDelete = keylist
            }
            let urlName = duplicateImgDict[indexValueForDelete]
            duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: indexValueForDelete)
            print(duplicateImgDict)
            self.othersApiCallingEnable.removeValue(forKey: "\(sender.tag)")
            var duplicateDocumentArray = self.othersDocumentArray
            for item in 0..<self.othersDocumentArray.count {
                if othersDocumentArray[item].range(of: urlName?.lastPathComponent ?? "") != nil {
                    let docName = othersDocumentArray[item]
                    duplicateDocumentArray.remove(at: item)
                    AWSManager.shared.deleteUploadDocument(documentName: docName)
                }
            }
            self.othersDocumentArray = duplicateDocumentArray
            if sender.tag < 4 {
                for n in sender.tag..<3 {
                    duplicateImgDict.updateValue(self.others["\(n+1)"]!, forKey: "\(n)")
                }
                duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: "3")
            }
            
            let duplicateAPICalling = self.othersApiCallingEnable
            // Sort the dictionary keys in ascending order
            let sortedKeys = duplicateAPICalling.keys.sorted { Int($0)! < Int($1)! }
            // Create a new dictionary with updated sequential index keys
            var updatedDictionary: [String: String] = [:]
            var currentIndex = 0
            for key in sortedKeys {
                updatedDictionary[String(currentIndex)] = duplicateAPICalling[key]
                currentIndex += 1
            }
            self.othersApiCallingEnable = updatedDictionary
            self.others = duplicateImgDict
        default:
            var duplicateImgDict = self.pickedImageDictionary
            var indexValueForDelete = "\(sender.tag)"
            let sortedArray = duplicateImgDict.sorted { int1, int2 in
                return int1.key < int2.key
            }
            print(duplicateImgDict)
            print(sortedArray)
            let dict = Dictionary(uniqueKeysWithValues: sortedArray.map {($0.key, $0.value)})
            print(dict)
            print(duplicateImgDict)
            if self.pickedImageDictionary.count == 1, let keylist = self.pickedImageDictionary.keys.first, keylist != indexValueForDelete {
                indexValueForDelete = keylist
            }
            let urlName = duplicateImgDict[indexValueForDelete]
            duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: indexValueForDelete)
            print(duplicateImgDict)
            self.apiCallingEnableOrDisable.removeValue(forKey: "\(sender.tag)")
            var duplicateDocumentArray = self.uploadedDocumentArray
            for item in 0..<self.uploadedDocumentArray.count {
                if uploadedDocumentArray[item].range(of: urlName?.lastPathComponent ?? "") != nil {
                    let docName = uploadedDocumentArray[item]
                    duplicateDocumentArray.remove(at: item)
                    AWSManager.shared.deleteUploadDocument(documentName: docName)
                }
            }
            self.uploadedDocumentArray = duplicateDocumentArray
            if sender.tag < 4 {
                for n in sender.tag..<3 {
                    duplicateImgDict.updateValue(self.pickedImageDictionary["\(n+1)"]!, forKey: "\(n)")
                }
                duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: "3")
            }
            let duplicateAPICalling = self.apiCallingEnableOrDisable
            // Sort the dictionary keys in ascending order
            let sortedKeys = duplicateAPICalling.keys.sorted { Int($0)! < Int($1)! }
            // Create a new dictionary with updated sequential index keys
            var updatedDictionary: [String: String] = [:]
            var currentIndex = 0
            for key in sortedKeys {
                updatedDictionary[String(currentIndex)] = duplicateAPICalling[key]
                currentIndex += 1
            }
            self.apiCallingEnableOrDisable = updatedDictionary
            self.pickedImageDictionary = duplicateImgDict
        }
        self.attachmentTableView.reloadData()
        setTableviewDynamicHeight()
        EditTravelRecordAPI()
    }
    
    func editTravel(travelDoc: [String], foodDoc: [String], shoppingDoc: [String], otherDoc: [String]) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - editTravel"))
        self.editTravelDoc = travelDoc
        self.editFoodDoc = foodDoc
        self.editshoppingDoc = shoppingDoc
        self.editothersDoc = otherDoc
        
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
    }
    
    internal func setTableviewDynamicHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            self.tableviewHeightConstrain.constant = self.attachmentTableView.contentSize.height
            UIView.animate(withDuration: 0.2) {
                self.attachmentTableView.layoutIfNeeded()
            }
        }
    }
    
    
    @IBAction func uploadDocumentButtonAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - uploadDocumentButtonAction"))
        self.view.endEditing(true)
        openDocumentWithAlert()
    }
    
    private func travelDetailAPI() {
        self.travelDetailViewModel.travelInfoAPI(travelID: self.travelID, enableLoader: true) { response in
            switch response.status?.status {
            case 200:
                self.travelAndHoterlDocumentArray.removeAll()
                self.foodAndEntertainmentDocumentArray.removeAll()
                self.shoppingAndUtilityDocumentArray.removeAll()
                self.othersDocumentArray.removeAll()
                self.editTravelDoc.removeAll()
                self.editFoodDoc.removeAll()
                self.editshoppingDoc.removeAll()
                self.editothersDoc.removeAll()
                
                self.summaryEntityObject = response.entity
                self.setupTravelData(response.entity)
               
                if self.currentDateInFormat == response.entity?.endDate?.settingsTimeStampStringDate() {
                    self.recordEditable = .noneditable
                    self.isCurrentDate = true
                } else {
                    self.recordEditable = .editable
                    self.isCurrentDate = false
                }
            default:
                TravelTaxMixPanelAnalytics(action: .mytravel_detail, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - travelDetailViewModel not success: \(response)"))
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: response.status?.msg ?? "", image: UIImage(named: "Notification") ?? nil,theme: .custom)
            }
        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .mytravel_detail, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - travelDetailAPI Error: \(error)"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }
    }
    
    private func setupTravelData(_ data:TravelSummaryEntity?) {
        TravelTaxMixPanelAnalytics(action: .mytravel_detail, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - setupTravelData"))
        guard (data != nil) else {
            return
        }
        if let countryRecord = data {
            TravelTaxMixPanelAnalytics(action: .mytravel_detail, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - setupTravelData current \(countryRecord)"))
            self.physicalPresenceDayCountLbl.text = "\(countryRecord.physicalPresenceDays ?? 0)"
            self.travelNotesTxtView.text = countryRecord.checklist ?? ""
            if countryRecord.checklist ?? "" == "" {
                self.travelNoteView.isHidden = true
                self.travelNotesViewHeightConstraint.constant = 0
            } else {
                self.travelNoteView.isHidden = false
                self.travelNotesViewHeightConstraint.constant = 165
            }
            self.titleLbl.text = countryRecord.destination?.countryName
            updateResident(countryRecord.resident ?? false)
//            let progress = countryRecord.totalDaysCompleted == 0 ? 0.0 : Float((countryRecord.totalDaysCompleted)) / Float((countryRecord.totalDays))
//            var progress = Float((countryRecord.totalDays)) / Float((countryRecord.totalDaysCompleted))
//            if countryRecord.totalDays == 0 || countryRecord.totalDaysCompleted == 0 {
//                progress = 0.0
//            }
            if let countryRecord = countryRecord.origin?.countryName, countryRecord.isEmpty {
                self.DepartureCountryName.text = ""
                self.DepartureCountryName.isHidden = true
            } else {
                self.DepartureCountryName.text = countryRecord.origin?.countryName
                self.DepartureCountryName.isHidden = false
            }
            self.DepartureTiming.text = countryRecord.origin?.countryCode
            
            self.destinationCountryName.text = countryRecord.destination?.countryName
            self.destinationTiming.text = countryRecord.destination?.countryCode
            
            let localTimeZone = NSTimeZone.local
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            
            let startDateString = countryRecord.startDate ?? ""
            let endDateString = countryRecord.endDate ?? ""
            
            guard let startDate = dateFormatter.date(from: startDateString), let endDate = dateFormatter.date(from: endDateString) else {
                // Handle parsing errors if necessary
                return
            }
//            dateFormatter.timeZone = localTimeZone
            
            // Format 1: "Mar 24, 2023"
            dateFormatter.dateFormat = "MMM d, yyyy"
            let formattedStartDate1 = dateFormatter.string(from: startDate)
            let formattedEndDate1 = dateFormatter.string(from: endDate)

            // Format 2: "08:30"
//            dateFormatter.dateFormat = "HH:mm"
//            let formattedStartDate2 = dateFormatter.string(from: startDate)
//            let formattedEndDate2 = dateFormatter.string(from: endDate)
            
            self.DepartureTiming.text = formattedStartDate1
            self.destinationTiming.text = formattedEndDate1
                        
//            self.travelHotel = countryRecord.travelHotel?.components(separatedBy: ",") ?? [""]
//            self.foodEntertainment = countryRecord.foodEntertainment?.components(separatedBy: ",") ?? [""]
//            self.shoppingUtility = countryRecord.shoppingUtility?.components(separatedBy: ",") ?? [""]
//            self.others = countryRecord.others?.components(separatedBy: ",") ?? [""]
            
            // Set attachment Data
            var travelHotel = (self.summaryEntityObject?.travelHotel ?? "").components(separatedBy: ",")
            var foodEntertainment = (self.summaryEntityObject?.foodEntertainment ?? "").components(separatedBy: ",")
            var shoppingUtility = (self.summaryEntityObject?.shoppingUtility ?? "").components(separatedBy: ",")
            var others = (self.summaryEntityObject?.others ?? "").components(separatedBy: ",")
            
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
            
            self.editTravel(travelDoc: travelHotel, foodDoc: foodEntertainment, shoppingDoc: shoppingUtility, otherDoc: others)
            self.attachmentTableView.reloadData()
            setTableviewDynamicHeight()
            
            let editData = self.addEditData(self.summaryEntityObject)
            self.createTravelHandler = editData
            self.setupTravelEditData()
        }
        
//        if let travelList = data?.countryList, travelList.count > 0 {
//            self.travelList = travelList
//            switch self.listStatus {
//            case .closed:
////                self.tripTableHeightConstrain.constant = 86.0
//                self.tripListView.layoutIfNeeded()
//            default:
////                self.tripTableHeightConstrain.constant = CGFloat(travelList.count) * 86.0
//                self.tripListView.layoutIfNeeded()
//            }
//            self.tripListTableView.reloadData()
//        } else {
            //
//        }
    }

    private func updateResident(_ isResident:Bool) {
        switch isResident {
        case false:
            self.residentStatusLbl.text = "Non-Resident"
            self.residentStatusLbl.textColor =  UIColor.nonResidentColor.withAlphaComponent(1.0)
            self.residentStatusView.backgroundColor = UIColor.nonResidentColor
        default:
            self.residentStatusLbl.text = "Resident"
            self.residentStatusLbl.textColor =  UIColor.residentColor.withAlphaComponent(1.0)
            self.residentStatusView.backgroundColor = UIColor.residentColor
        }
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editBtnTapped(_ sender: Any) {
        let actionSheetController = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ -> Void in }
        let editAction = UIAlertAction(title: "Edit", style: .default) { _ -> Void in
            let editData = self.addEditData(self.summaryEntityObject)
            let edit = CreateNewTravelViewController.loadFromNib()
            edit.manageTravel = .edit
            edit.createdBy = self.createdBy
            edit.travelID = self.travelID
            edit.createTravelHandler = editData
            
            if self.currentCountryCode == self.summaryEntityObject?.destination?.countryCode{
                edit.isCurrentCountry = true
            } else {
                edit.isCurrentCountry = false
            }
            edit.isCurrentDate = self.isCurrentDate == true ? true : false
           
            var travelHotel = (self.summaryEntityObject?.travelHotel ?? "").components(separatedBy: ",")
            var foodEntertainment = (self.summaryEntityObject?.foodEntertainment ?? "").components(separatedBy: ",")
            var shoppingUtility = (self.summaryEntityObject?.shoppingUtility ?? "").components(separatedBy: ",")
            var others = (self.summaryEntityObject?.others ?? "").components(separatedBy: ",")
            var travelNotes = self.summaryEntityObject?.checklist ?? ""
            
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
//        if recordEditable == .editable {
            actionSheetController.addAction(editAction)
//        }
        actionSheetController.addAction(deleteAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    private func addEditData(_ entity:TravelSummaryEntity?) -> CreateTravelHelper {
        TravelTaxMixPanelAnalytics(action: .mytravel_detail, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - addEditData:"))
        guard (entity != nil) else {
            return CreateTravelHelper()
        }
        var editTravelHandler = CreateTravelHelper()
        editTravelHandler.fromCountry = entity?.origin?.countryID ?? 0
        editTravelHandler.toCountry = entity?.destination?.countryID ?? 0
        editTravelHandler.fromCountryString = entity?.origin?.countryName ?? ""
        editTravelHandler.toCountryString = entity?.destination?.countryName ?? ""
        editTravelHandler.startDateString = entity?.startDate ?? ""
        editTravelHandler.endDateString = entity?.endDate ?? ""
        editTravelHandler.noWorkDays = "\(entity?.taxableDays ?? 0)"
        editTravelHandler.definitionDay = entity?.definitionOfTaxDays
        editTravelHandler.fiscalYearStart = entity?.fiscalStartYear ?? ""
        editTravelHandler.fiscalYearEnd = entity?.fiscalEndYear ?? ""
        editTravelHandler.alertThresholdDays = "\(entity?.thresholdDays ?? 0)"
        editTravelHandler.travelType = entity?.travelType?.type ?? ""
        editTravelHandler.travelTypeID = entity?.travelType?.id ?? 0
        editTravelHandler.travelTypeOthers = entity?.otherTravelType ?? ""
        editTravelHandler.travelNotes = entity?.checklist ?? ""
        editTravelHandler.nonWorkDays = [""]
        return editTravelHandler
    }
    
    func containsSlash(in string: String) -> Bool {
        return string.contains("/")
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
//            self.delegate?.didTravelDeleted(self.selectedlistType.rawValue)
            TravelTaxMixPanelAnalytics(action: .mytravel_detail, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - deleteTravelAPI success"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Successfully deleted", image: UIImage(named: "Notification") ?? nil,theme: .custom)
            
        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .mytravel_detail, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - deleteTravelAPI Error \(error)"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }
        
    }
    
    //MARK: - UnitTestcase
    
    func UnitTestcase() {
        
        let summary = TravelSummaryEntity(travelID: "test", userID: nil, origin: nil, destination: nil, sameYearAndToCountry: "test", startDate: "2023-12-31 00:00:00", endDate: "2023-12-31 00:00:00", taxableDays: 0, numberOfTaxDaysUsed: 0, numberOfTaxDaysLeft: 0, definitionOfTaxDays: "test", fiscalStartYear: "2023-12-31 00:00:00", fiscalEndYear: "2023-12-31 00:00:00", thresholdDays: 9, travelType: nil, otherTravelType: "test", daysAway: 0, createdOn: "test", updatedOn: "test", checklist: "test", travelHotel: "test", foodEntertainment: "test", shoppingUtility: "test", others: "test", physicalPresenceDays: 9, resident: false, confirmStay: false, checkTravelParameters: nil)
        self.setupTravelData(summary)
        self.editBtnTapped(UIButton())
        let _ = addEditData(summary)
        deleteTravelAlert()
        deleteTravelAPI()
        let _ = setDropImage(imageName: "adding")
        let _ = headerDetailsView(titleStr: headerTitleArray[0])
        let _ = headerDetailsView(titleStr: headerTitleArray[1])
        let _ = headerDetailsView(titleStr: headerTitleArray[2])
        let _ = headerDetailsView(titleStr: headerTitleArray[3])
        self.headerTapped(UITapGestureRecognizer())
    }
}

extension MyTravelDetailSummaryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.headerTitleArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            if self.travelHotel.count > 0, self.travelHotel[0] == "" {
//                return 0
//            }
//            return isTravelAndHotelEnable ? self.travelHotel.count : 0
//
//        case 1:
//            if self.foodEntertainment.count > 0, self.foodEntertainment[0] == "" {
//                return 0
//            }
//            return isFoodAndEntertainmentEnable ? self.foodEntertainment.count  : 0
//        case 2:
//            if self.shoppingUtility.count > 0, self.shoppingUtility[0] == "" {
//                return 0
//            }
//            return isShoppingAndUntilityEnable ? self.shoppingUtility.count : 0
//        case 3:
//            if self.others.count > 0, self.others[0] == "" {
//                return 0
//            }
//            return isOtherEnable ? self.others.count : 0
//        default:
//            return 0
//        }
        switch section {
        case 0:
            return isTravelAndHotelEnable ? self.travelApiCallingEnable.count : 0
        case 1:
            return isFoodAndEntertainmentEnable ? self.foodApiCallingEnable.count  : 0
        case 2:
            return isShoppingAndUntilityEnable ? self.shoppingApiCallingEnable.count : 0
        case 3:
            return isOtherEnable ? self.othersApiCallingEnable.count : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = headerDetailsView(titleStr: headerTitleArray[section])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped(_:)))
        headerView.tag = section
        headerView.addGestureRecognizer(tapGesture)
        return headerView
       // return headerDetailsView(titleStr: headerTitleArray[section])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 0:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
//            var separateName = String()
//            let urlItem = self.travelHotel[indexPath.row]
//            if containsSlash(in: urlItem) {
//                let docName = urlItem.components(separatedBy: "/")[1]
//                if docName.components(separatedBy: "_traveltax_").count > 1 {
//                    separateName = docName.components(separatedBy: "_traveltax_")[1]
//                } else {
//                    separateName = docName
//                }
//            } else {
//                separateName = urlItem
//            }
//            if let fileType = NSURL(fileURLWithPath: urlItem).pathExtension {
//                cell.imgFileType.image = UIImage(named: fileType.uppercased())
//            }
//            cell.documentNameLbl.text = separateName
//            cell.progressView.isHidden = true
//            cell.uploadReadingLbl.isHidden = true
//            cell.documentCloseBtn.isHidden = true
//            cell.contentView.backgroundColor = UIColor(named: "lightBlueAndGray")
//
//            return cell
//        case 1:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
//
//            let urlItem = self.foodEntertainment[indexPath.row]
//
//            var separateName = String()
//            if containsSlash(in: urlItem) {
//                let docName = urlItem.components(separatedBy: "/")[1]
//                if docName.components(separatedBy: "_traveltax_").count > 1 {
//                    separateName = docName.components(separatedBy: "_traveltax_")[1]
//                } else {
//                    separateName = docName
//                }
//            } else {
//                separateName = urlItem
//            }
//            if let fileType = NSURL(fileURLWithPath: urlItem).pathExtension {
//                cell.imgFileType.image = UIImage(named: fileType.uppercased())
//            }
//            let userdefault = UserDefaults.standard
//            let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
//            if isDarkMode {
//                cell.stackView.layer.cornerRadius = 3
//                cell.stackView.layer.borderColor = UIColor.lightGray.cgColor
//                cell.stackView.layer.borderWidth = 0.7
//            }
//            cell.documentNameLbl.text = separateName
//            cell.progressView.isHidden = true
//            cell.uploadReadingLbl.isHidden = true
//            cell.documentCloseBtn.isHidden = true
//            cell.contentView.backgroundColor = UIColor(named: "lightBlueAndGray")
//
//            return cell
//        case 2:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
//
//            let urlItem = self.shoppingUtility[indexPath.row]
//
//            var separateName = String()
//            if containsSlash(in: urlItem) {
//                let docName = urlItem.components(separatedBy: "/")[1]
//                if docName.components(separatedBy: "_traveltax_").count > 1 {
//                    separateName = docName.components(separatedBy: "_traveltax_")[1]
//                } else {
//                    separateName = docName
//                }
//            } else {
//                separateName = urlItem
//            }
//            if let fileType = NSURL(fileURLWithPath: urlItem).pathExtension {
//                cell.imgFileType.image = UIImage(named: fileType.uppercased())
//            }
//            let userdefault = UserDefaults.standard
//            let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
//            if isDarkMode {
//                cell.stackView.layer.cornerRadius = 3
//                cell.stackView.layer.borderColor = UIColor.lightGray.cgColor
//                cell.stackView.layer.borderWidth = 0.7
//            }
//            cell.documentNameLbl.text = separateName
//            cell.progressView.isHidden = true
//            cell.uploadReadingLbl.isHidden = true
//            cell.documentCloseBtn.isHidden = true
//            cell.contentView.backgroundColor = UIColor(named: "lightBlueAndGray")
//
//            return cell
//        case 3:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
//
//            let urlItem = self.others[indexPath.row]
//
//            var separateName = String()
//            if containsSlash(in: urlItem) {
//                let docName = urlItem.components(separatedBy: "/")[1]
//                if docName.components(separatedBy: "_traveltax_").count > 1 {
//                    separateName = docName.components(separatedBy: "_traveltax_")[1]
//                } else {
//                    separateName = docName
//                }
//            } else {
//                separateName = urlItem
//            }
//            if let fileType = NSURL(fileURLWithPath: urlItem).pathExtension {
//                cell.imgFileType.image = UIImage(named: fileType.uppercased())
//            }
//            let userdefault = UserDefaults.standard
//            let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
//            if isDarkMode {
//                cell.stackView.layer.cornerRadius = 3
//                cell.stackView.layer.borderColor = UIColor.lightGray.cgColor
//                cell.stackView.layer.borderWidth = 0.7
//            }
//            cell.documentNameLbl.text = separateName
//            cell.progressView.isHidden = true
//            cell.uploadReadingLbl.isHidden = true
//            cell.documentCloseBtn.isHidden = true
//            cell.contentView.backgroundColor = UIColor(named: "lightBlueAndGray")
//
//            return cell
//        default:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
//
//            let urlItem = self.travelHotel[indexPath.row]
//
//            var separateName = String()
//            if containsSlash(in: urlItem) {
//                let docName = urlItem.components(separatedBy: "/")[1]
//                if docName.components(separatedBy: "_traveltax_").count > 1 {
//                    separateName = docName.components(separatedBy: "_traveltax_")[1]
//                } else {
//                    separateName = docName
//                }
//            } else {
//                separateName = urlItem
//            }
//            if let fileType = NSURL(fileURLWithPath: urlItem).pathExtension {
//                cell.imgFileType.image = UIImage(named: fileType.uppercased())
//            }
//            let userdefault = UserDefaults.standard
//            let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
//            if isDarkMode {
//                cell.stackView.layer.cornerRadius = 3
//                cell.stackView.layer.borderColor = UIColor.lightGray.cgColor
//                cell.stackView.layer.borderWidth = 0.7
//            }
//            cell.documentNameLbl.text = separateName
//            cell.progressView.isHidden = true
//            cell.uploadReadingLbl.isHidden = true
//            cell.documentCloseBtn.isHidden = true
//            cell.contentView.backgroundColor = UIColor(named: "lightBlueAndGray")
//
//            return cell
//        }
        
        switch indexPath.section {
        case 0:
            var indexReading = "\(indexPath.row)"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
            var urlItem = self.travelAndHotelArray[indexReading]
            if urlItem == nil, self.travelAndHotelArray.count == 1, let indexValue = self.travelAndHotelArray.keys.first {
                urlItem = self.travelAndHotelArray[indexValue]
                indexReading = indexValue
            }
            if let urlItem = urlItem, self.travelApiCallingEnable[indexReading] == "start" {
                cell.setupProgressView()
                self.travelApiCallingEnable.updateValue("processing", forKey: "\(indexPath.row)")
                cell.apiConfiguration(fileURL: urlItem, fileType: urlItem.pathExtension, indexValue: indexPath.row, categoryName: self.selectedDocumentCategory)
                cell.documentCloseBtn.isHidden = true
            } else if self.travelApiCallingEnable[indexReading] == "completed" {
                var separateName = String()
                if let docName = urlItem?.lastPathComponent {
                    if docName.components(separatedBy: "_traveltax_").count > 1 {
                        separateName = docName.components(separatedBy: "_traveltax_")[1]
                        cell.uploadReadingLbl.isHidden = true
                    } else {
                        separateName = docName
                    }
                }
                cell.documentNameLbl.text = separateName
                cell.progressView.isHidden = true
                cell.uploadReadingLbl.isHidden = true
                cell.documentCloseBtn.isHidden = false
                if let fileType = urlItem?.pathExtension{
                    cell.imgFileType.image = UIImage(named: fileType.uppercased())
                }
            } else if self.travelApiCallingEnable[indexReading] == "processing" {
                cell.progressView.isHidden = false
                cell.documentCloseBtn.isHidden = true
                cell.uploadReadingLbl.isHidden = false
            }
            cell.uploadedImg = self
            cell.documentCloseBtn.accessibilityLabel = "\(indexPath.section)"
            cell.documentCloseBtn.tag = indexPath.row
            cell.documentCloseBtn.addTarget(self, action: #selector(removeCellBtnTapped(_:)), for: .touchUpInside)
            let userdefault = UserDefaults.standard
            let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
            if isDarkMode {
                cell.stackView.layer.cornerRadius = 3
                cell.stackView.layer.borderColor = UIColor.lightGray.cgColor
                cell.stackView.layer.borderWidth = 0.7
            }
            return cell
        case 1:
            var indexReading = "\(indexPath.row)"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
            var urlItem = self.foodAndEntertainment[indexReading]
            if urlItem == nil, self.foodAndEntertainment.count == 1, let indexValue = self.foodAndEntertainment.keys.first {
                urlItem = self.foodAndEntertainment[indexValue]
                indexReading = indexValue
            }
            if let urlItem = urlItem, self.foodApiCallingEnable[indexReading] == "start" {
                cell.setupProgressView()
                self.foodApiCallingEnable.updateValue("processing", forKey: "\(indexPath.row)")
                cell.apiConfiguration(fileURL: urlItem, fileType: urlItem.pathExtension, indexValue: indexPath.row, categoryName: self.selectedDocumentCategory)
                cell.documentCloseBtn.isHidden = true
            } else if self.foodApiCallingEnable[indexReading] == "completed" {
                var separateName = String()
                if let docName = urlItem?.lastPathComponent {
                    if docName.components(separatedBy: "_traveltax_").count > 1 {
                        separateName = docName.components(separatedBy: "_traveltax_")[1]
                        cell.uploadReadingLbl.isHidden = true
                    } else {
                        separateName = docName
                    }
                }
                cell.documentNameLbl.text = separateName
                cell.progressView.isHidden = true
                cell.uploadReadingLbl.isHidden = true
                cell.documentCloseBtn.isHidden = false
            } else if self.foodApiCallingEnable[indexReading] == "processing" {
                cell.progressView.isHidden = false
                cell.documentCloseBtn.isHidden = true
                cell.uploadReadingLbl.isHidden = false
            }
            cell.uploadedImg = self
            cell.documentCloseBtn.accessibilityLabel = "\(indexPath.section)"
            cell.documentCloseBtn.tag = indexPath.row
            cell.documentCloseBtn.addTarget(self, action: #selector(removeCellBtnTapped(_:)), for: .touchUpInside)
            if let fileType = urlItem?.pathExtension{
                cell.imgFileType.image = UIImage(named: fileType.uppercased())
            }
            let userdefault = UserDefaults.standard
            let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
            if isDarkMode {
                cell.stackView.layer.cornerRadius = 3
                cell.stackView.layer.borderColor = UIColor.lightGray.cgColor
                cell.stackView.layer.borderWidth = 0.7
            }
            return cell
        case 2:
            var indexReading = "\(indexPath.row)"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
            var urlItem = self.shoppingAndUtility[indexReading]
            if urlItem == nil, self.shoppingAndUtility.count == 1, let indexValue = self.shoppingAndUtility.keys.first {
                urlItem = self.shoppingAndUtility[indexValue]
                indexReading = indexValue
            }
            if let urlItem = urlItem, self.shoppingApiCallingEnable[indexReading] == "start" {
                cell.setupProgressView()
                self.shoppingApiCallingEnable.updateValue("processing", forKey: "\(indexPath.row)")
                cell.apiConfiguration(fileURL: urlItem, fileType: urlItem.pathExtension, indexValue: indexPath.row, categoryName: self.selectedDocumentCategory)
                cell.documentCloseBtn.accessibilityLabel = "\(indexPath.section)"
                cell.documentCloseBtn.isHidden = true
            } else if self.shoppingApiCallingEnable[indexReading] == "completed" {
                var separateName = String()
                if let docName = urlItem?.lastPathComponent {
                    if docName.components(separatedBy: "_traveltax_").count > 1 {
                        separateName = docName.components(separatedBy: "_traveltax_")[1]
                        cell.uploadReadingLbl.isHidden = true
                    } else {
                        separateName = docName
                    }
                }
                cell.documentNameLbl.text = separateName
                cell.progressView.isHidden = true
                cell.uploadReadingLbl.isHidden = true
                cell.documentCloseBtn.isHidden = false
            } else if self.shoppingApiCallingEnable[indexReading] == "processing" {
                cell.progressView.isHidden = false
                cell.documentCloseBtn.isHidden = true
                cell.uploadReadingLbl.isHidden = false
            }
            cell.uploadedImg = self
            cell.documentCloseBtn.tag = indexPath.row
            cell.documentCloseBtn.accessibilityLabel = "\(indexPath.section)"
            cell.documentCloseBtn.addTarget(self, action: #selector(removeCellBtnTapped(_:)), for: .touchUpInside)
            if let fileType = urlItem?.pathExtension{
                cell.imgFileType.image = UIImage(named: fileType.uppercased())
            }
            let userdefault = UserDefaults.standard
            let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
            if isDarkMode {
                cell.stackView.layer.cornerRadius = 3
                cell.stackView.layer.borderColor = UIColor.lightGray.cgColor
                cell.stackView.layer.borderWidth = 0.7
            }
            return cell
        case 3:
            var indexReading = "\(indexPath.row)"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
            var urlItem = self.others[indexReading]
            if urlItem == nil, self.others.count == 1, let indexValue = self.others.keys.first {
                urlItem = self.others[indexValue]
                indexReading = indexValue
            }
            if let urlItem = urlItem, self.othersApiCallingEnable[indexReading] == "start" {
                cell.setupProgressView()
                self.othersApiCallingEnable.updateValue("processing", forKey: "\(indexPath.row)")
                cell.apiConfiguration(fileURL: urlItem, fileType: urlItem.pathExtension, indexValue: indexPath.row, categoryName: self.selectedDocumentCategory)
                cell.documentCloseBtn.isHidden = true
            } else if self.othersApiCallingEnable[indexReading] == "completed" {
                var separateName = String()
                if let docName = urlItem?.lastPathComponent {
                    if docName.components(separatedBy: "_traveltax_").count > 1 {
                        separateName = docName.components(separatedBy: "_traveltax_")[1]
                        cell.uploadReadingLbl.isHidden = true
                    } else {
                        separateName = docName
                    }
                }
                cell.documentNameLbl.text = separateName
                cell.progressView.isHidden = true
                cell.uploadReadingLbl.isHidden = true
                cell.documentCloseBtn.isHidden = false
            } else if self.othersApiCallingEnable[indexReading] == "processing" {
                cell.progressView.isHidden = false
                cell.documentCloseBtn.isHidden = true
                cell.uploadReadingLbl.isHidden = false
                
            }
            cell.uploadedImg = self
            cell.documentCloseBtn.tag = indexPath.row
            cell.documentCloseBtn.accessibilityLabel = "\(indexPath.section)"
            cell.documentCloseBtn.addTarget(self, action: #selector(removeCellBtnTapped(_:)), for: .touchUpInside)
            if let fileType = urlItem?.pathExtension{
                cell.imgFileType.image = UIImage(named: fileType.uppercased())
            }
            let userdefault = UserDefaults.standard
            let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
            if isDarkMode {
                cell.stackView.layer.cornerRadius = 3
                cell.stackView.layer.borderColor = UIColor.lightGray.cgColor
                cell.stackView.layer.borderWidth = 0.7
            }
            return cell
        default:
            var indexReading = "\(indexPath.row)"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
            var urlItem = self.pickedImageDictionary[indexReading]
            if urlItem == nil, self.pickedImageDictionary.count == 1, let indexValue = self.pickedImageDictionary.keys.first {
                urlItem = self.pickedImageDictionary[indexValue]
                indexReading = indexValue
            }
            if let urlItem = urlItem, self.apiCallingEnableOrDisable[indexReading] == "start" {
                cell.setupProgressView()
                self.apiCallingEnableOrDisable.updateValue("processing", forKey: "\(indexPath.row)")
                cell.apiConfiguration(fileURL: urlItem, fileType: urlItem.pathExtension, indexValue: indexPath.row, categoryName: self.selectedDocumentCategory)
                cell.documentCloseBtn.isHidden = true
            } else if self.apiCallingEnableOrDisable[indexReading] == "completed" {
                var separateName = String()
                if let docName = urlItem?.lastPathComponent {
                    if docName.components(separatedBy: "_traveltax_").count > 1 {
                        separateName = docName.components(separatedBy: "_traveltax_")[1]
                        cell.uploadReadingLbl.isHidden = true
                    } else {
                        separateName = docName
                    }
                }
                cell.documentNameLbl.text = separateName
                cell.progressView.isHidden = true
                cell.uploadReadingLbl.isHidden = true
                cell.documentCloseBtn.isHidden = false
            } else if self.apiCallingEnableOrDisable[indexReading] == "processing" {
                cell.progressView.isHidden = false
                cell.documentCloseBtn.isHidden = true
                cell.uploadReadingLbl.isHidden = false
            }
            cell.uploadedImg = self
            cell.documentCloseBtn.tag = indexPath.row
            cell.documentCloseBtn.accessibilityLabel = "\(indexPath.section)"
            cell.documentCloseBtn.addTarget(self, action: #selector(removeCellBtnTapped(_:)), for: .touchUpInside)
            if let fileType = urlItem?.pathExtension{
                cell.imgFileType.image = UIImage(named: fileType.uppercased())
            }
            let userdefault = UserDefaults.standard
            let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
            if isDarkMode {
                cell.stackView.layer.cornerRadius = 3
                cell.stackView.layer.borderColor = UIColor.lightGray.cgColor
                cell.stackView.layer.borderWidth = 0.7
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let urlItem = self.travelAndHoterlDocumentArray[indexPath.row]
            let combine = AWSConfig.kAWSBaseURL + urlItem
            guard let url = NSURL(fileURLWithPath: combine).absoluteString else { return }
            let replaced = url.replacingOccurrences(of: "file:///", with: "")
            UIApplication.shared.open(URL(string:replaced) ?? URL(string:"")! , options: [:])

        case 1:
            let urlItem = self.foodAndEntertainmentDocumentArray[indexPath.row]
            let combine = AWSConfig.kAWSBaseURL + urlItem
            guard let url = NSURL(fileURLWithPath: combine).absoluteString else { return }
            let replaced = url.replacingOccurrences(of: "file:///", with: "")
            UIApplication.shared.open(URL(string:replaced) ?? URL(string:"")! , options: [:])

        case 2:
            let urlItem = self.shoppingAndUtilityDocumentArray[indexPath.row]
            let combine = AWSConfig.kAWSBaseURL + urlItem
            guard let url = NSURL(fileURLWithPath: combine).absoluteString else { return }
            let replaced = url.replacingOccurrences(of: "file:///", with: "")
            UIApplication.shared.open(URL(string:replaced) ?? URL(string:"")! , options: [:])

        default:
            let urlItem = self.othersDocumentArray[indexPath.row]
            let combine = AWSConfig.kAWSBaseURL + urlItem
            guard let url = NSURL(fileURLWithPath: combine).absoluteString else { return }
            let replaced = url.replacingOccurrences(of: "file:///", with: "")
            UIApplication.shared.open(URL(string:replaced) ?? URL(string:"")! , options: [:])
        }
    }
    
    func headerDetailsView(titleStr: String) -> UIView {
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 10, width: attachmentTableView.frame.width, height: 55)
        contentView.backgroundColor = UIColor(named: "WhiteAndLightBlue")
        contentView.layer.cornerRadius = 3

        let attachImageView = UIImageView()
        attachImageView.image = UIImage(named: "imageAttach")
        attachImageView.frame = CGRect(x: 10, y: (60-18)/2, width: 20, height: 18)
        contentView.addSubview(attachImageView)
        
        let titleLbl = UILabel()
        titleLbl.frame = CGRect(x: 45, y: 17, width: 150, height: 30)
        titleLbl.text = titleStr
        titleLbl.textColor = UIColor(named: "GrayColor")
        titleLbl.font = .fontR14
        contentView.addSubview(titleLbl)
        
        switch titleStr {
        case "Travel and Hotel":
            switch travelApiCallingEnable.count {
            case 0:
                let dropImage = setDropImage(imageName: "dropGray")
                contentView.addSubview(dropImage)
            default:
                var dropImage = UIImageView()
                if isTravelAndHotelEnable {
                    dropImage = setDropImage(imageName: "upGray")
                } else {
                    dropImage = setDropImage(imageName: "dropGray")
                }
                contentView.addSubview(dropImage)
            }
        case "Food and Entertainment":
            switch foodApiCallingEnable.count {
            case 0:
                let dropImage = setDropImage(imageName: "dropGray")
                contentView.addSubview(dropImage)
            default:
                var dropImage = UIImageView()
                if isFoodAndEntertainmentEnable {
                    dropImage = setDropImage(imageName: "upGray")
                } else {
                    dropImage = setDropImage(imageName: "dropGray")
                }
                contentView.addSubview(dropImage)
            }
        case "Shopping and Utility":
            switch shoppingApiCallingEnable.count {
            case 0:
                let dropImage = setDropImage(imageName: "dropGray")
                contentView.addSubview(dropImage)
            default:
                var dropImage = UIImageView()
                if isShoppingAndUntilityEnable {
                    dropImage = setDropImage(imageName: "upGray")
                } else {
                    dropImage = setDropImage(imageName: "dropGray")
                }
                contentView.addSubview(dropImage)
            }
        default:
            switch othersApiCallingEnable.count {
            case 0:
                let dropImage =  setDropImage(imageName: "dropGray")
                contentView.addSubview(dropImage)
            default:
                var dropImage = UIImageView()
                if isOtherEnable {
                    dropImage = setDropImage(imageName: "upGray")
                } else {
                    dropImage = setDropImage(imageName: "dropGray")
                }
                contentView.addSubview(dropImage)
            }
        }
        
        let mainView = UIView()
        mainView.frame = CGRect(x: 0, y: 10, width: attachmentTableView.frame.width, height: 65)
        mainView.backgroundColor = UIColor(named: "lightBlueAndGray")
        mainView.addSubview(contentView)
        
        // Initialization code
        let userdefault = UserDefaults.standard
        let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
        if isDarkMode {
            contentView.layer.cornerRadius = 3
            contentView.layer.borderColor = UIColor.lightGray.cgColor
            contentView.layer.borderWidth = 0.7
        }
        return mainView
    }
    
    func setDropImage(imageName:String) -> UIImageView {
        let dropdown = UIImageView()
        dropdown.image = UIImage(named: imageName)
        dropdown.frame = CGRect(x: attachmentTableView.frame.width - 28, y: (60-7)/2, width: 14, height: 7)
        return dropdown
    }
    
    @objc func headerTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let section = gestureRecognizer.view?.tag ?? 0
        // Perform any action you want when the header is tapped
        print("Header tapped for section: \(section)")
        if section == 0 {
            if self.travelApiCallingEnable.count > 0 {
                self.isTravelAndHotelEnable = !self.isTravelAndHotelEnable
            }
        }
        if section == 1 {
            if self.foodApiCallingEnable.count > 0 {
                isFoodAndEntertainmentEnable = !isFoodAndEntertainmentEnable
            }
        }
        if section == 2 {
            if self.shoppingApiCallingEnable.count > 0 {
                isShoppingAndUntilityEnable = !isShoppingAndUntilityEnable
            }
        }
        if section == 3 {
            if self.othersApiCallingEnable.count > 0 {
                isOtherEnable = !isOtherEnable
            }
        }
        attachmentTableView.reloadData()
        self.setTableviewDynamicHeight()
    }
    
}

extension MyTravelDetailSummaryViewController: UIDocumentPickerDelegate {
    //MARK: - UIDocumentPickerDelegate

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - UIDocumentPickerDelegate - documentPicker"))
        for urlItem in urls {
            switch selectedDocumentCategory {
            case .TravelAndHotel:
                let details = self.travelAndHotelArray.filter { $0.value != URL(fileURLWithPath: "") }
                print("details count TravelAndHotel: \(details)")
                if details.count < 4 {
                    isTravelAndHotelEnable = true
                    self.travelApiCallingEnable.updateValue("start", forKey: "\(details.count)")
                    self.travelAndHotelArray.updateValue(urlItem, forKey: "\(details.count)")
                } else {
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: "Travel And Hotel", body: "You have already reached the maximum count of upload documents", image: UIImage(named: "Notification") ?? nil,theme: .custom)
                }
            case .FoodAndEntertainment:
                let details = self.foodAndEntertainment.filter { $0.value != URL(fileURLWithPath: "") }
                print("details count FoodAndEntertainment: \(details)")
                if details.count < 4 {
                    isFoodAndEntertainmentEnable = true
                    self.foodApiCallingEnable.updateValue("start", forKey: "\(details.count)")
                    self.foodAndEntertainment.updateValue(urlItem, forKey: "\(details.count)")
                } else {
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: "Food And Entertainment", body: "You've already reached the maximum count of upload documents", image: UIImage(named: "Notification") ?? nil,theme: .custom)
                }
            case .ShoppingAndUtility:
                let details = self.shoppingAndUtility.filter { $0.value != URL(fileURLWithPath: "") }
                print("details count ShoppingAndUtility: \(details)")
                if details.count < 4 {
                    isShoppingAndUntilityEnable = true
                    self.shoppingApiCallingEnable.updateValue("start", forKey: "\(details.count)")
                    self.shoppingAndUtility.updateValue(urlItem, forKey: "\(details.count)")
                } else {
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: "Shopping And Utility", body: "You've already reached the maximum count of upload documents", image: UIImage(named: "Notification") ?? nil,theme: .custom)
                }
            case .Others:
                let details = self.others.filter { $0.value != URL(fileURLWithPath: "") }
                print("details count Others: \(details)")
                if details.count < 4 {
                    isOtherEnable = true
                    self.othersApiCallingEnable.updateValue("start", forKey: "\(details.count)")
                    self.others.updateValue(urlItem, forKey: "\(details.count)")
                } else {
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: "Others", body: "You've already reached the maximum count of upload documents", image: UIImage(named: "Notification") ?? nil,theme: .custom)
                }
            case .none:
                let details = self.pickedImageDictionary.filter { $0.value != URL(fileURLWithPath: "") }
                print("details count none: \(details)")
                if details.count < 4 {
                    self.apiCallingEnableOrDisable.updateValue("start", forKey: "\(details.count)")
                    self.pickedImageDictionary.updateValue(urlItem, forKey: "\(details.count)")
                } else {
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: "Others", body: "You've already reached the maximum count of upload documents", image: UIImage(named: "Notification") ?? nil,theme: .custom)
                }
            }
            self.attachmentTableView.reloadData()
            setTableviewDynamicHeight()
            //            }
        }
        self.dismiss(animated: true)
    }
    
    
    
    func uploadFile(with resource: String, type: String, documentURL: String) {   //1
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - uploadFile"))
        let key = "\(resource).\(type)"
        
        //6
        let transferFile = AWSS3TransferUtility.default()
        let fileURL = URL(fileURLWithPath: documentURL)
        let bucketName = AWSConfig.kIMAGEBUCKET  //3
        
        var contentType = "" // default content type
        
        switch type {
        case "xlsx":
            contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        case "xls":
            contentType = "application/vnd.ms-excel"
        case "numbers":
            contentType = "application/vnd.apple.numbers"
        case "docx":
            contentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case "doc":
            contentType = "application/msword"
        case "pdf":
            contentType = "application/pdf"
        default:
            break
        }
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = { (task, progress) in
            DispatchQueue.main.async {
                let percent = Int(progress.fractionCompleted * 100)
                print("Upload progress: \(percent)%")
            }
        }
        let uploadTask = transferFile.uploadFile(fileURL, bucket: bucketName, key: key, contentType: contentType, expression: expression, completionHandler: { task, error in
            if let error = error {
                TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - uploadFile - failure response"))
                print("Error uploading file: \(error.localizedDescription)")
            } else {
                TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - uploadFile - success response"))
                print("File uploaded successfully.")
            }
        })
        print(uploadTask.description)
        
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
}

extension MyTravelDetailSummaryViewController: AWSFileUploadingDelegate {
    func returningFileName(fileName: String, indexValue: Int, categoryName: documentCategory) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - returningFileName"))
        switch categoryName {
        case .TravelAndHotel:
            if self.travelAndHoterlDocumentArray.count == 0 {
                self.travelAndHoterlDocumentArray = [fileName]
            } else {
                self.travelAndHoterlDocumentArray.append(fileName)
            }
            self.travelApiCallingEnable.updateValue("completed", forKey: "\(indexValue)")
        case .FoodAndEntertainment:
            print("returning fileName \(fileName)")
            if self.foodAndEntertainmentDocumentArray.count == 0 {
                self.foodAndEntertainmentDocumentArray = [fileName]
            } else {
                self.foodAndEntertainmentDocumentArray.append(fileName)
            }
            self.foodApiCallingEnable.updateValue("completed", forKey: "\(indexValue)")
            
        case .ShoppingAndUtility:
            if self.shoppingAndUtilityDocumentArray.count == 0 {
                self.shoppingAndUtilityDocumentArray = [fileName]
            } else {
                self.shoppingAndUtilityDocumentArray.append(fileName)
            }
            self.shoppingApiCallingEnable.updateValue("completed", forKey: "\(indexValue)")
        case .Others:
            if self.othersDocumentArray.count == 0 {
                self.othersDocumentArray = [fileName]
            } else {
                self.othersDocumentArray.append(fileName)
            }
            self.othersApiCallingEnable.updateValue("completed", forKey: "\(indexValue)")
        }
        self.attachmentTableView.reloadData()
        setTableviewDynamicHeight()
        EditTravelRecordAPI()
    }
}


extension MyTravelDetailSummaryViewController{
   
    // MARK: - Network requests

    /// CreateTravelRecordAPI
    func EditTravelRecordAPI() {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - createTravelRecordAPI"))
        self.createTravelViewModel.createTravelRecord(userId:UserDefaultModule.shared.getUserID() ?? "",
                                                      travelId: self.travelID,
                                                      origin:createTravelHandler.fromCountry,
                                                      destination: createTravelHandler.toCountry,
                                                      startDate: createTravelHandler.startDateString ?? "",
                                                      endDate: createTravelHandler.endDateString ?? "",
                                                      taxDays: Int(createTravelHandler.noWorkDays) ?? 0,
                                                      definitionDay: createTravelHandler.definitionDay ?? "",
                                                      fiscalStart: createTravelHandler.fiscalYearStart ?? "",
                                                      fiscalEnd: createTravelHandler.fiscalYearEnd ?? "",
                                                      thresholdDays: Int(createTravelHandler.alertThresholdDays) ?? 0,
                                                      travelTypeId: createTravelHandler.travelTypeID,
                                                      otherTravelType: createTravelHandler.travelTypeOthers,
                                                      travelNotes: createTravelHandler.travelNotes,
                                                      nonWorkDays: createTravelHandler.nonWorkDays,
                                                      isDefaultSettingsExist: false,
                                                      controller: self,
                                                      enableLoader: true,
                                                      manageTravel: .edit, travelHotel: self.travelAndHoterlDocumentArray, foodEntertainment: self.foodAndEntertainmentDocumentArray, shoppingUtility: self.shoppingAndUtilityDocumentArray, others: self.othersDocumentArray)
        { response in
            print("RES",response)
            
            let status = response.status?.status
            guard status != nil else {
                TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - EditTravelRecordAPI - status nil"))
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "status response nil", image: UIImage(named: "Notification") ?? nil,theme: .custom)
                return
            }
            
            switch status {
            case 302, 303, 200 :
                TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "MyTravelDetailSummaryViewController - EditTravelRecordAPI - success - Status:\(status ?? 0)"))
//                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: self.manageTravel == .create ? "Successfully created" : "Successfully updated", image: UIImage(named: "Notification") ?? nil,theme: .custom)
                //            LandingTabBarController.loadFromNib().selectedIndex = 2
                self.travelDetailAPI()
                
            default:
                TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - createTravelRecordAPI - not succeed"))
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: response.status?.msg ?? "", image: UIImage(named: "Notification") ?? nil,theme: .custom)
            }
            
        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - createTravelRecordAPI - failure response"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }
        
    }
}

extension MyTravelDetailSummaryViewController:RefreshAppDelegate {
    func didAppRefreshBegin() {
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.isAppBackground = false
            DispatchQueue.main.async {
                self.travelDetailAPI()
            }
    }
}

enum RecordEditable: String {
    case editable
    case noneditable
}


extension MyTravelDetailSummaryViewController: CLLocationManagerDelegate {
    
    //MARK: - CLLocationManagerDelegate
      
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let coordinates = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        self.fetchCityAndCountry(location: coordinates) { city, country, code, error in
            guard let _ = country,let code = code, error == nil else { return }
            self.currentCountryCode = code
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    func fetchCityAndCountry(location:CLLocation,completion: @escaping (_ city: String?, _ country:  String?,_ code:String?  ,_ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { completion($0?.first?.locality, $0?.first?.country,$0?.first?.isoCountryCode, $1) }
    }
    
}
