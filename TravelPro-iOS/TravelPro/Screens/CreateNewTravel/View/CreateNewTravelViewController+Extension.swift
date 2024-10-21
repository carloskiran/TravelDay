//
//  CreateNewTravelViewController+Extension.swift
//  TravelPro
//
//  Created by MAC-OBS-48 on 11/09/23.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import UniformTypeIdentifiers
import FSCalendar
import AWSCore
import AWSS3
import SwiftMessages

extension CreateNewTravelViewController {
    
    @objc
    internal func respondToChanges(picker: UIDatePicker) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - respondToChanges"))
        if (picker.countDownDuration <= 540) {
            var components = DateComponents()
            components.minute = 10
            let date = Calendar.current.date(from: components)!
            picker.setDate(date, animated: true)
        }
    }
    
    @objc internal func cancelDatePicker(){
       self.view.endEditing(true)
     }

    @objc internal func thresholdDone() {
        self.view.endEditing(true)
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - thresholdDone"))
        guard (selectedThreshold != nil) else {
            self.createTravelHandler.alertThresholdDays = thresholdDays.first ?? ""
            return alertThresholdTextfiled.text = thresholdDays.first
        }
        self.createTravelHandler.alertThresholdDays = selectedThreshold ?? ""
        alertThresholdTextfiled.text = selectedThreshold
    }
    
    @objc internal func taxableDonePicker() {
        self.view.endEditing(true)
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - taxableDonePicker"))
        guard (selectedTaxableDay != nil) else {
            self.createTravelHandler.noWorkDays = taxableDays.first ?? "183"
            return taxableDaysTextfield.text = taxableDays.first
        }
        self.createTravelHandler.noWorkDays = selectedTaxableDay ?? ""
        taxableDaysTextfield.text = selectedTaxableDay
    }
    
    @objc internal func travelTypeDone() {
        self.view.endEditing(true)
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - travelTypeDone"))
        guard (selectedTravelType != nil) else {
            self.createTravelHandler.travelTypeID = 1
            self.createTravelHandler.travelType = travelTypeList.first ?? ""
            return travelTypeTextfiled.text = travelTypeList.first
        }
        if selectedTravelType == "Others" {
            othersView.isHidden = false
            othersTextfield.text = ""
            travelTypeTextfiled.text = selectedTravelType
        } else {
            othersTextfield.text = ""
            othersView.isHidden = true
            self.createTravelHandler.travelType = selectedTravelType ?? ""
            travelTypeTextfiled.text = selectedTravelType
        }
        self.createTravelHandler.travelTypeID = selectedTravelTypeId
    }
    
    @objc func doneDefinitiondatePicker(){
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - doneDefinitiondatePicker"))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        definitionTextfield.text = formatter.string(from: definitionDayDatePicker.date)
        self.createTravelHandler.definitionDay = formatter.string(from: definitionDayDatePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func doneStartDatePicker() {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - doneStartDatePicker"))
        if self.createTravelHandler.endDateString != nil {
            if self.manageTravel == .edit || self.manageTravel == .create {
                if self.createdBy == "User" || self.createdBy == "" {
                    endDateTextfield.text  = ""
                    self.createTravelHandler.endDate = nil
                    self.createTravelHandler.endDateString = ""
                }
            }
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        startDateTextfield.text = formatter.string(from: startDatePicker.date)
        
        let gregorians = Calendar.current
        
        let month = gregorians.component(.month, from: startDatePicker.date)
        print(month)
        
        let date = gregorians.component(.day, from: startDatePicker.date)
        print(date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
        let newStartTime = dateFormatter.string(from: startDatePicker.date)
        
        self.createTravelHandler.startDateString = newStartTime
        self.createTravelHandler.startDate = startDatePicker.date
        
        // Set min and max date based on start date year
        let gregorian = Calendar(identifier: .gregorian)
        let minimumDate = gregorian.date(from: DateComponents(year: gregorian.component(.year, from: createTravelHandler.startDate ?? Date()), month: 1, day: 1))!
        let maximumDate = gregorian.date(from: DateComponents(year: gregorian.component(.year, from: createTravelHandler.startDate ?? Date()), month: 12, day: 31))!
        var dateComponent = gregorians.dateComponents([.year, .month, .day], from: createTravelHandler.startDate ?? Date())
        dateComponent.month! += (12 - month)
        dateComponent.day! += (31 - date)
        endDatePicker.minimumDate = minimumDate
        endDatePicker.maximumDate = gregorians.date(from: dateComponent)
        fiscalstartDatePicker.minimumDate = minimumDate
        fiscalstartDatePicker.maximumDate = maximumDate
        self.setupEndDateDatePicker()
        self.view.endEditing(true)
    }
    
    @objc func doneEndDatePicker() {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - doneEndDatePicker"))
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        guard (self.createTravelHandler.startDateString != nil) else {
            self.view.endEditing(true)
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select arrival date", image: nil,theme: .default)
        }
        guard formatter.string(from: endDatePicker.date).toDate() ?? Date() > (self.startDateTextfield.text?.toDate() ?? Date()) || self.startDateTextfield.text == formatter.string(from: endDatePicker.date) else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "departure date should be greater than arrival date", image: nil,theme: .default)
        }

        endDateTextfield.text = formatter.string(from: endDatePicker.date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
        let newStartTime = dateFormatter.string(from: endDatePicker.date)
        self.createTravelHandler.endDateString = newStartTime
        self.createTravelHandler.endDate = endDatePicker.date
        endDatePicker.reloadInputViews()
        self.view.endEditing(true)
    }

    @objc func donefiscalStartDatePicker(){
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - donefiscalStartDatePicker"))
        if createTravelHandler.startDate == nil || createTravelHandler.endDate == nil {
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select the start date and end date first", image: nil,theme: .default)
            return
        }
        let selectedDate = fiscalstartDatePicker.date
        // Get the current calendar and time zone
        let calendar = Calendar.current
        let timeZone = calendar.timeZone
        // Convert the date from UTC to local time zone
        _ = calendar.date(byAdding: .second, value: timeZone.secondsFromGMT(), to: selectedDate) ?? selectedDate
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        formatter.timeZone = TimeZone.current
        if self.createTravelHandler.fiscalYearEnd != nil {
            self.createTravelHandler.fiscalEndDate = nil
            self.createTravelHandler.fiscalYearEnd = ""
            fiscalEndTextfield.text = ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
        let dateString = dateFormatter.string(from: selectedDate)
        fiscalStartTextfield.text = formatter.string(from: selectedDate)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
        let startDate = dateFormatter2.date(from: dateString) ?? Date()
        self.createTravelHandler.fiscalYearStart = dateString
        self.createTravelHandler.fiscalStartDate = startDate
        // Set min and max date based on start date year
        let gregorian = Calendar(identifier: .gregorian)
        var dateComponent = gregorian.dateComponents([.year, .month, .day], from: createTravelHandler.fiscalStartDate ?? Date())
        dateComponent.year! += 1
        dateComponent.day! -= 1
        self.fiscalEndDatePicker.minimumDate = gregorian.date(from: dateComponent)
        self.fiscalEndDatePicker.maximumDate = gregorian.date(from: dateComponent)
        self.view.endEditing(true)
    }
    
    @objc func donefiscalEndDatePicker() {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - donefiscalEndDatePicker"))
        if createTravelHandler.startDate == nil || createTravelHandler.endDate == nil {
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select the start date and end date first", image: nil,theme: .default)
            return
        }
        
        guard self.createTravelHandler.fiscalYearStart != nil else {
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select the tax year start", image: nil,theme: .default)
            self.view.endEditing(true)
            return
        }
        
        let selectedDate = fiscalEndDatePicker.date
        // Get the current calendar and time zone
        let calendar = Calendar.current
        let timeZone = calendar.timeZone
        // Convert the date from UTC to local time zone
        let localDate = calendar.date(byAdding: .second, value: timeZone.secondsFromGMT(), to: selectedDate) ?? selectedDate
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        guard fiscalStartTextfield.text != formatter.string(from: localDate) else {
            self.view.endEditing(true)
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Fiscal End date should be greater than fiscal start date", image: nil,theme: .default)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
        let newStartTime = dateFormatter.string(from: localDate)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
        let newStartTime2 = formatter.string(from: localDate)
        fiscalEndTextfield.text = newStartTime2
        self.createTravelHandler.fiscalEndDate = localDate
        self.createTravelHandler.fiscalYearEnd = newStartTime
        self.view.endEditing(true)
    }
}
extension CreateNewTravelViewController: AWSFileUploadingDelegate {
    func returningFileName(fileName: String, indexValue: Int, categoryName: documentCategory) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - returningFileName"))
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
        self.tableView.reloadData()
        setTableviewDynamicHeight()
    }
}

extension CreateNewTravelViewController:UIPickerViewDelegate, UIPickerViewDataSource , UITextFieldDelegate {
    
    // MARK: - UIPickerViewDelegate & UIPickerViewDataSource & UITextFieldDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return thresholdDays.count
        case 2:
            return travelTypeList.count
        default:
            return taxableDays.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return thresholdDays[row]
        case 2:
            return travelTypeList[row]
        default:
            return taxableDays[row]
        }
       
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            selectedThreshold = thresholdDays[row]
        case 2:
            selectedTravelType = travelTypeList[row]
            selectedTravelTypeId = row + 1
        default:
            selectedTaxableDay = taxableDays[row]
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == othersTextfield {
            if let text = textField.text,text.count > 0 {
                self.createTravelHandler.travelTypeOthers = text
            }
        }
    }
}

extension CreateNewTravelViewController: UITextViewDelegate {
    
    //MARK: - UITextViewDelegate

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == travelNotesTextview {
            if let text = travelNotesTextview.text {
                self.createTravelHandler.travelNotes = text
            }
        }
    }
}


extension CreateNewTravelViewController:SelectTravelCountryDelegate {
    
    //MARK: - SelectTravelCountryDelegate
    func didSelectedCountry(country: CountryListModel?, type: CountryType) {
        if let data = country {
            scrollView.setContentOffset(.zero, animated: true)
            switch type {
            case .toCountry:

                if self.createTravelHandler.fromCountry == data.countryId {
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Selected countries should not be the same", image: nil,theme: .default)
                } else {
                     createTravelHandler.toCountry = data.countryId
                     createTravelHandler.toCountryString = data.countryName
                     toTextfield.text = data.countryName
                }

            default:
                if self.createTravelHandler.toCountry > 0 {
                    if self.createTravelHandler.toCountry == data.countryId {
                        utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Selected countries should not be the same", image: nil,theme: .default)
                        return
                    }
                }
               
                createTravelHandler.fromCountry = data.countryId
                fromTextfield.text = data.countryName
                createTravelHandler.fromCountryString = data.countryName
            }
        }
    }
    
}

//MARK: - Enum

enum CountryType:String {
    case fromCountry
    case toCountry
}

enum ManageTravelType:String {
    case create
    case edit
}


//MARK: - Create Travel Handler

struct CreateTravelHelper {
    var fromCountry:Int
    var toCountry:Int
    var fromCountryString:String
    var toCountryString:String
    var startDateString:String?
    var endDateString:String?
    var startDate:Date?
    var endDate:Date?
    var noWorkDays:String
    var definitionDay:String?
    var fiscalYearStart:String?
    var fiscalYearEnd:String?
    var fiscalStartDate:Date?
    var fiscalEndDate:Date?
    var alertThresholdDays:String
    var travelType:String
    var travelTypeID:Int
    var travelTypeOthers:String
    var travelNotes:String
    var nonWorkDays:[String]
    var isOverViewCompleted:Bool?
    var isWorkViewCompleted:Bool?
    
    init() {
        self.fromCountry = 0
        self.toCountry = 0
        self.fromCountryString = ""
        self.toCountryString = ""
        self.noWorkDays = ""
        self.alertThresholdDays = ""
        self.travelType = ""
        self.travelTypeID = 4
        self.travelTypeOthers = ""
        self.travelNotes = ""
        self.nonWorkDays = []
    }
}

extension Calendar {
    func startOfYear(_ date: Date) -> Date {
        return self.date(from: DateComponents(year: self.component(.year, from: date), month: 1, day: 1))!
    }

    func endOfYear(_ date: Date) -> Date {
        return self.date(from: DateComponents(year: self.component(.year, from: date), month: 12, day: 31))!
    }
}


extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day!  // <1>
    }
}

extension Date {
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    func endOfDay() -> Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self) ?? self
    }
    
    func startOfMonth() -> Date? {
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month, .hour], from: Calendar.current.startOfDay(for: self))
        return Calendar.current.date(from: comp)!
    }
    
    func endOfMonth() -> Date? {
        var comp: DateComponents = Calendar.current.dateComponents([.year,.month, .day, .hour], from: Calendar.current.startOfDay(for: self))
        comp.month = 1
        comp.day = -1
        return Calendar.current.date(byAdding: comp, to: self.startOfMonth()!)
    }
    
}
protocol AWSFileUploadingDelegate {
    func returningFileName(fileName: String, indexValue: Int, categoryName: documentCategory)
}

protocol TableViewCellAPICallControllingDelegate {
    func ApiCallStatus(status: String, indexValue: Int)
}

enum documentCategory {
    case TravelAndHotel
    case FoodAndEntertainment
    case ShoppingAndUtility
    case Others
}
