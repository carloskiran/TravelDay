//
//  CreateNewTravel+HelperExtension.swift
//  TravelPro
//
//  Created by MAC-OBS-48 on 11/09/23.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

extension CreateNewTravelViewController {
    
  
    /// SetupLocalizeTexts
    internal func setupLocalizeTexts() {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - setupLocalizeTexts"))
        switch self.manageTravel {
        case .edit:
            createTravelLabel.text = "Edit Travel Record"
            
        default:
            createTravelLabel.text = "Create New Travel Record"
        }
    }
    
    internal func setupDismissThresholdPickerView() {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - setupDismissThresholdPickerView"))
        let toolbar = createPickerToolbar(1)
        alertThresholdTextfiled.inputAccessoryView = toolbar
    }
    
    internal func setupDismissTravelTypePickerView() {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - setupDismissTravelTypePickerView"))
        let toolbar = createPickerToolbar(2)
        travelTypeTextfiled.inputAccessoryView = toolbar
    }
    
    internal func setupDismissTaxableDaysPickerView() {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - setupDismissTaxableDaysPickerView"))
        let toolbar = createPickerToolbar(8)
        taxableDaysTextfield.inputAccessoryView = toolbar
    }
    
    internal func createPickerToolbar(_ tag:Int) -> UIToolbar {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - createPickerToolbar"))
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        var doneButton = UIBarButtonItem()
        switch tag {
        case 1: // threshold
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.thresholdDone))
        case 2: // travel type
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.travelTypeDone))
        case 3: //definition day
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneDefinitiondatePicker))
        case 4: //start date
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneStartDatePicker))
        case 5: //end date
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneEndDatePicker))
        case 6: //fiscal start
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donefiscalStartDatePicker))
        case 7: //fiscal end
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donefiscalEndDatePicker))
        default: //taxable days
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.taxableDonePicker))
        }
         let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
       let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        return toolbar
    }
    
    internal func setupDefinitionDatePicker(){
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - setupDefinitionDatePicker"))
        definitionDayDatePicker.datePickerMode = .countDownTimer
        definitionDayDatePicker.addTarget(self, action: #selector(respondToChanges(picker:)), for: .valueChanged)
        definitionDayDatePicker.minuteInterval = 1
        var components = DateComponents()
        components.minute = 10
        let date = Calendar.current.date(from: components)!
        definitionDayDatePicker.setDate(date, animated: true)
        
        let toolbar = createPickerToolbar(3)
        definitionTextfield.inputAccessoryView = toolbar
        definitionTextfield.inputView = definitionDayDatePicker
        if #available(iOS 14, *) {
            definitionDayDatePicker.preferredDatePickerStyle = .wheels
            definitionDayDatePicker.sizeToFit()
        }
     }
    
    internal func setupStartDateDatePicker(){
        
        // Arrival Date
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - setupStartDateDatePicker"))
        let gregorian = Calendar(identifier: .gregorian)
        startDatePicker.datePickerMode = .date
        let yesterday = gregorian.date(byAdding: .day, value: -1, to: Date())!
        
        // Get the current year
        let currentYear = gregorian.component(.year, from: Date())
        // Calculate the start date based on the current year
        var startDateComponents = DateComponents()
        startDateComponents.year = currentYear - 2
        startDateComponents.month = 1
        startDateComponents.day = 1
        let startDate = Calendar.current.date(from: startDateComponents)!
        startDatePicker.minimumDate = startDate
        if self.manageTravel == .edit {
            if self.createdBy == "App" {
                startDatePicker.maximumDate = Date()
            } else {
                startDatePicker.maximumDate = yesterday
            }
        } else {
            startDatePicker.maximumDate = yesterday
        }
        
        let toolbar = createPickerToolbar(4)
        startDateTextfield.inputAccessoryView = toolbar
        startDateTextfield.inputView = startDatePicker
        if #available(iOS 14, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
            startDatePicker.sizeToFit()
        }
     }
    
    internal func setupfiscalStartDatePicker(){
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - setupfiscalStartDatePicker"))
        fiscalstartDatePicker.datePickerMode = .date
        let calendar: Calendar = Calendar.current
        let startDate = calendar.startOfYear(Date())
        fiscalstartDatePicker.minimumDate = startDate
        let toolbar = createPickerToolbar(6)
        fiscalStartTextfield.inputAccessoryView = toolbar
        fiscalStartTextfield.inputView = fiscalstartDatePicker
        fiscalstartDatePicker.timeZone = Calendar.current.timeZone
        if #available(iOS 14, *) {
            fiscalstartDatePicker.preferredDatePickerStyle = .wheels
            fiscalstartDatePicker.sizeToFit()
        }
     }
    
    internal func setupfiscalEndDatePicker(){
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - setupfiscalEndDatePicker"))
        fiscalEndDatePicker.datePickerMode = .date
        fiscalEndDatePicker.minimumDate = Date()
        let toolbar = createPickerToolbar(7)
        fiscalEndTextfield.inputAccessoryView = toolbar
        fiscalEndTextfield.inputView = fiscalEndDatePicker
        if #available(iOS 14, *) {
            fiscalEndDatePicker.preferredDatePickerStyle = .wheels
            fiscalEndDatePicker.sizeToFit()
        }
     }
    
    internal func getIntervalDays(_ startDate:Date,_ endDate:Date) -> Int {
        let diffInDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        return diffInDays
    }
    
    internal func setupValidationCreateTravel() {
        self.view.endEditing(true)

        guard self.createTravelHandler.toCountry > 0 else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select country name", image: nil,theme: .default)
        }
        guard (self.createTravelHandler.startDateString != nil) else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select arrival date", image: nil,theme: .default)
        }
        guard (self.createTravelHandler.endDateString != nil || self.createTravelHandler.endDateString == "") else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select departure date", image: nil,theme: .default)
        }
        guard self.createTravelHandler.noWorkDays.count > 0 else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select maximum stay day", image: nil,theme: .default)
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
        self.createTravelRecordAPI(defaultSettingsExist: false)
    }
    
    
    internal func openDocumentWithAlert() {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - openDocumentWithAlert"))
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
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - openDocument"))
        let supportedTypes = [UTType.jpeg,UTType.pdf,UTType.spreadsheet]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.shouldShowFileExtensions = true
        present(documentPicker, animated: true, completion: nil)
    }
    
    internal func showDefaultSettingsValuesExistAlert(_ value: String) {
        
        let alert = UIAlertController(title: "Travel Tax Day",
                                      message: value,
                                      preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true) {
                self.createTravelRecordAPI(defaultSettingsExist: true)
            }
        })
        let no = UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true) {
            }
        })
        alert.addAction(yes)
        alert.addAction(no)

        self.present(alert, animated: true, completion: nil)
    }
    
    internal func showCheckTravelParamsAlert(_ message: String,_ recordId:String) {
        
        let alert = UIAlertController(title: "Travel Tax Day",
                                      message: message,
                                      preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true) {
                self.overrideRecordAPI(recordId)
            }
        })
        let no = UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true) {
                self.setOverrideDefaultSettingsValues()
                self.overrideRecordAPI(recordId)
            }
        })
        
        alert.addAction(yes)
        alert.addAction(no)

        self.present(alert, animated: true, completion: nil)
    }
    
    internal func createOverrideAlertDescription(_ entity: CheckParamsEntity) -> String {
        
        var fields:String = ""
        let bulletPoint = "•"
        if entity.maximumStayDays == false {
            fields.append(bulletPoint + " Maximum stay days \n")
        }
        if entity.definitionOfDays == false {
            fields.append(bulletPoint + " Definition of day \n")
        }
        if entity.fiscalYear == false {
            fields.append(bulletPoint + " Fiscal year \n")
        }
        if entity.threshold == false {
            fields.append(bulletPoint + " Alert threshold \n")
        }
        let content = "\(fields) values in the existing record do not match. Do you wish to overwrite the existing record?"
        return content
    }
    
    /// Set default settings input fields  if user select NO set existing record values (existingRecordEntity) except Destination country, Arrival and departure date.
    internal func setOverrideDefaultSettingsValues() {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - setOverrideDefaultSettingsValues"))
        if let entity = self.existingRecordEntity {
            self.createTravelHandler.noWorkDays = "\(entity.taxableDays ?? 0)"
            self.createTravelHandler.definitionDay = entity.definitionOfTaxDays
            self.createTravelHandler.fiscalYearStart = entity.fiscalStartYear?.timeStampDateWithMilliseconds()
            self.createTravelHandler.fiscalYearEnd = entity.fiscalEndYear?.timeStampDateWithMilliseconds()
            self.createTravelHandler.alertThresholdDays = "\(entity.thresholdDays ?? 0)"
        }
    }
    
    //MARK: - Internal
    internal func setupEndDateDatePicker(){
        // Departure Date
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - setupEndDateDatePicker"))
        let gregorian = Calendar(identifier: .gregorian)
        endDatePicker.datePickerMode = .date
        let yesterday = gregorian.date(byAdding: .day, value: -1, to: Date())!
        // Get the current year
        let currentYear = Calendar.current.component(.year, from: Date())
        // Calculate the start date based on the current year
        var startDateComponents = DateComponents()
        startDateComponents.year = currentYear - 2
        startDateComponents.month = 1
        startDateComponents.day = 1
        let startDate = Calendar.current.date(from: startDateComponents)!
        endDatePicker.minimumDate = startDate
        endDatePicker.maximumDate = yesterday
        let toolbar = createPickerToolbar(5)
        endDateTextfield.inputAccessoryView = toolbar
        endDateTextfield.inputView = endDatePicker
        if #available(iOS 14, *) {
            endDatePicker.preferredDatePickerStyle = .wheels
            endDatePicker.sizeToFit()
        }
     }
    
    internal func configCheckTravelParamsPopup(_ entity: CheckParamsEntity?,_ recordId:String) {
        if let data = entity {
            if data.maximumStayDays == false || data.definitionOfDays == false || data.fiscalYear == false || data.threshold == false {
                let alertMessage = self.createOverrideAlertDescription(data)
                DispatchQueue.main.async {
                    self.showCheckTravelParamsAlert(alertMessage, recordId)
                }
            } else {
                self.overrideRecordAPI(recordId)
            }
        }
    }
    
    internal func configDefaultSettingsValueRecordExistPopup(_ entity: CheckParamsEntity?) {
        if let data = entity {
            if data.maximumStayDays == false || data.definitionOfDays == false || data.fiscalYear == false || data.threshold == false {
                let alertMessage = self.createOverrideAlertDescription(data)
                DispatchQueue.main.async {
                    self.showDefaultSettingsValuesExistAlert(alertMessage)
                }
            }
        }
    }

    internal func setTableviewDynamicHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            self.tableviewHeightConstrain.constant = self.tableView.contentSize.height
            UIView.animate(withDuration: 0.2) {
                self.tableView.layoutIfNeeded()
            }
        }
    }
    
    
    internal func showRecordExistAlert(_ country: String,_ recordId:String) {
        
        let alert = UIAlertController(title: "Travel Tax Day",
                                      message: "The inserted dates have already been used for a different \(country) stay. Are you sure you want to proceed? ",
                                      preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true) {
                self.checkTravelParamsAPI(recordId)
            }
        })
        let no = UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true) {
            }
        })
        
        alert.addAction(yes)
        alert.addAction(no)

        self.present(alert, animated: true, completion: nil)
    }
    
    func editTravel(travelDoc: [String], foodDoc: [String], shoppingDoc: [String], otherDoc: [String], travelNotes: String) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - editTravel"))
        self.editTravelDoc = travelDoc
        self.editFoodDoc = foodDoc
        self.editshoppingDoc = shoppingDoc
        self.editothersDoc = otherDoc
        self.travelTextNotes = travelNotes
    }
    
    //MARK: - UnitTestcase
    
    func UnitTestCoverage() {
        
        self.manageTravel = .edit
        self.editTravelDoc = ["TravelAndHotel/1686118005._.kjhgfds.pdf", "TravelAndHotel/1686118005._.kjhgfds.pdf", "TravelAndHotel/1686118005._.kjhgfds.pdf", "TravelAndHotel/1686118005._.kjhgfds.pdf"]
        self.editFoodDoc = ["TravelAndHotel/1686118005._.kjhgfds.pdf", "TravelAndHotel/1686118005._.kjhgfds.pdf"]
        self.editshoppingDoc = ["TravelAndHotel/1686118005._.kjhgfds.pdf", "TravelAndHotel/1686118005._.kjhgfds.pdf", "TravelAndHotel/1686118005._.kjhgfds.pdf", "TravelAndHotel/1686118005._.kjhgfds.pdf"]
        self.editothersDoc = ["TravelAndHotel/1686118005._.kjhgfds.pdf", "TravelAndHotel/1686118005._.kjhgfds.pdf", "TravelAndHotel/1686118005._.kjhgfds.pdf"]
        self.setupUI()
        self.setupDefaultValue()
        self.setupTravelEditData()
        self.setupValidationCreateTravel()
        self.thresholdDone()
        self.taxableDonePicker()
        self.travelTypeDone()
        self.doneDefinitiondatePicker()
        self.doneStartDatePicker()
        self.doneEndDatePicker()
        self.donefiscalStartDatePicker()
        self.donefiscalEndDatePicker()
        self.openDocumentWithAlert()
        self.openDocument()
        self.showRecordExistAlert("test", "test")
        self.showDefaultSettingsValuesExistAlert("test")
        self.showCheckTravelParamsAlert("test", "test")
        let check = CheckParamsEntity(maximumStayDays: false, definitionOfDays: false, fiscalYear: false, threshold: false)
        let _ =  createOverrideAlertDescription(check)
        setTableviewDynamicHeight()
        
//        let button1 = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        button1.tag = 0
//        button1.setTitle("0", for: .normal)
//        removeCellBtnTapped(button1)
        
//        let button2 = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        button2.tag = 1
//        button2.setTitle("1", for: .normal)
//
//        removeCellBtnTapped(button2)
//
//        let button3 = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        button3.tag = 2
//        button3.setTitle("2", for: .normal)
//        removeCellBtnTapped(button3)
//
//        let button4 = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        button4.tag = 3
//        button4.setTitle("3", for: .normal)
//        removeCellBtnTapped(button4)
        
        let _ = isOverViewCompleted
        self.configCheckTravelParamsPopup(CheckParamsEntity(maximumStayDays: false, definitionOfDays: false, fiscalYear: false, threshold: false), "test")
        self.configDefaultSettingsValueRecordExistPopup(CheckParamsEntity(maximumStayDays: false, definitionOfDays: false, fiscalYear: false, threshold: false))
        self.fromCountryAction(UIButton())
        self.toCountryAction(UIButton())
        self.nextButtonAction(UIButton())
        self.uploadDocumentButtonAction(UIButton())
        self.createTravelButtonAction(UIButton())
        self.backButtonAction(UIButton())
        let _ = self.setDropImage(imageName: "")
        
        let picker = UIDatePicker()
        picker.countDownDuration = TimeInterval(10)
        respondToChanges(picker: picker)
        createTravelRecordAPI(defaultSettingsExist: false)
        editTravel(travelDoc: ["test"], foodDoc: ["test"], shoppingDoc: ["test"], otherDoc: ["test"], travelNotes: "test")
        checkTravelParamsAPI("")
        overrideRecordAPI("")
        let _ = tableView(self.tableView, viewForHeaderInSection: 0)
        headerTapped(UITapGestureRecognizer())
        viewDidDisappear(false)
        returningFileName(fileName: "test", indexValue: 0, categoryName: .TravelAndHotel)
        returningFileName(fileName: "test", indexValue: 0, categoryName: .FoodAndEntertainment)
        returningFileName(fileName: "test", indexValue: 0, categoryName: .ShoppingAndUtility)
        returningFileName(fileName: "test", indexValue: 0, categoryName: .Others)
        let textfield = self.othersTextfield ?? UITextField()
        textFieldDidEndEditing(textfield)
        let textview = self.travelNotesTextview ?? UITextView()
        textViewDidEndEditing(textview)
        didSelectedCountry(country: CountryListModel(phoneCode: "", isoCode: "", countryId: 0, countryName: "", dnTotalNumber: 0), type: .fromCountry)
        didSelectedCountry(country: CountryListModel(phoneCode: "", isoCode: "", countryId: 0, countryName: "", dnTotalNumber: 0), type: .toCountry)
        
        //AWS
        AWSManager.AWSInitialize()
        _ = AWSManager.shared.baseS3BucketURL
        AWSManager.shared.deleteUploadDocument(documentName: "testcase")
        _ = AWSManager.shared.getUniqueFileName()
        _ = AWSManager.getCloundFrontURL("testcase.jpeg")
        _ = AWSManager.getCloundFrontURL("")
        AWSManager.getThumbnailImage(keyName: "test") { url in }
        
    }
}
