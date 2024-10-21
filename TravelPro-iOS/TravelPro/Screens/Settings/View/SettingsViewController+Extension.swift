//
//  SettingsViewController+Extension.swift
//  TravelPro
//
//  Created by MAC-OBS-48 on 11/09/23.
//

import Foundation
import UIKit

extension SettingsViewController {
    
    // MARK: - UIPickerViewDelegate & UIPickerViewDataSource & UITextFieldDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return thresholdDays.count
        case 8:
            return taxableDays.count
        default:
            return locationCheck.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        switch pickerView.tag {
        case 1:
            return thresholdDays[row]
        case 8:
            return taxableDays[row]
        default:
            return locationCheck[row]
        }

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            selectedThreshold = thresholdDays[row]
        case 8:
            selectedTaxableDay = taxableDays[row]
        default:
            selectedLocationType = locationCheck[row]

        }
    }
    
    //MARK: Delete Account API Call

    func DeleteAccountAPICall() {
        TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - DeleteAccountAPICall"))
            self.settingsViewModel.DeleteAccountRecord(controller: self, enableLoader: true) { response in
                TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - DeleteAccountAPICall - success response"))
                DispatchQueue.main.async {
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Account deleted successfully", image: UIImage(named: "Notification") ?? nil,theme: .custom)
                    UserDefaults.standard.removeObject(forKey: "selectedUser")
                    UserDefaults.standard.removeObject(forKey: "usertype")
                    UserDefaults.standard.removeObject(forKey: "userTypeid")
                    let appdelegate = UIApplication.shared.delegate as? AppDelegate
                    appdelegate?.logoutSession()
                    appdelegate?.welcomeLandingpage()
                }

             } onFailure: { error in
                 TravelTaxMixPanelAnalytics(action: .settings, state: .info, data: MixPanelData(message: "SettingsViewController - DeleteAccountAPICall - failure response"))
                 utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
             }
    }

    //MARK: View Settings API Call

    func ViewUserSettingsAPICall() {
        self.settingsViewModel.ViewSettingsRecord(controller: self, enableLoader: true) { response in
            self.viewSettingsResponseDetails = response.entity
            DispatchQueue.main.async {
                self.SetViewSettingsData()
            }
        } onFailure: { error in
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }
    }

    func SetViewSettingsData(){
        
        self.selectedThreshold = "\(viewSettingsResponseDetails?.minWorkDay ?? "") days"
        self.alertThresholdlbl.text = "\(selectedThreshold ?? "")"
        let fullName: String = viewSettingsResponseDetails?.locationCheckHours ?? ""
        let fullNameArr = fullName.components(separatedBy:":")
        let location = Int(fullNameArr[0])
        self.selectedLocationType = "\(location ?? 0) hours"
        self.alertLocationlbl.text = "\(selectedLocationType ?? "")"
        let stringRepresentation = viewSettingsResponseDetails?.nonWorkingDays ?? ""
        let array = stringRepresentation.components(separatedBy: ",")
        let intArray = array.compactMap { Int($0) }
         daysList = NSMutableArray(array: intArray)
        self.fisicalStartDateTxtFld.text = viewSettingsResponseDetails?.taxStartYear.generalDateConversion()
        self.startedTaxDay = viewSettingsResponseDetails?.taxStartYear ?? ""
        //End date
        self.fisicalEndDateTxtFld.text = viewSettingsResponseDetails?.taxEndYear.generalDateConversion()
        self.endTaxDay = viewSettingsResponseDetails?.taxEndYear ?? ""
        let dateString = viewSettingsResponseDetails?.taxEndYear ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateString)
        // Assuming you have a UIDatePicker instance named "datePicker"
        fiscalEndDatePicker.minimumDate = date
        fiscalEndDatePicker.maximumDate = date
        // Maximum Days
        self.selectedTaxableDay = "\(viewSettingsResponseDetails?.taxableDays ?? 0)"
        self.minimumStayDateLbl.text = "\(viewSettingsResponseDetails?.taxableDays ?? 0)"
        if let tempDateSetting = viewSettingsResponseDetails?.definitionOfDays {
            if let datedefinitionOfDays  = self.stringToDate(dateString: tempDateSetting, format: "HH:mm:ss") {
                self.settingDefinitionLabelData(dateDefiniton: datedefinitionOfDays)
                self.definitionTextfield.text = viewSettingsResponseDetails?.definitionOfDays
                self.definitionTextfield.textColor = .clear
            }
        }
    }

    func stringToDate(dateString: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString)
    }

    //MARK: Update Settings API Call

    func UpdateSettingsAPI() {
        
        let stringRepresentation = daysList.componentsJoined(by: ",")
        let str = " hours"
        var location = selectedLocationType?.replacingOccurrences(of: str, with: "")
        location = location?.count ?? 0 == 2 ? "\(location ?? "0"):00" : "0\(location ?? "0"):00"
        let str1 = " days"
        let threshold = selectedThreshold?.replacingOccurrences(of: str1, with: "")
        let inputDateString = self.startedTaxDay
        let inputEndDateString = self.endTaxDay
        var outputStartDateString = String()
        var outputEndDateString = String()
        // Create a DateFormatter instance with the input date format
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // Create another DateFormatter instance with the desired output format
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
        if inputDateString.range(of: "T") != nil, inputDateString.range(of: "Z") != nil {
            // Create a DateFormatter instance with the input date format
            let inputDateFormatter = DateFormatter()
            inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
            // Parse the input date string into a Date object
            guard let date = inputDateFormatter.date(from: inputDateString) else {
                print("Failed to parse date")
                return
            }
            // Create another DateFormatter instance with the desired output format
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
            // Convert the Date object to the desired output format
            let outputDateString = outputDateFormatter.string(from: date)
            print(outputDateString) // Output: "2023-01-01T00:00:00.0000"
            outputStartDateString = outputDateString
        } else if inputDateString.range(of: " ") == nil {
            outputStartDateString = inputDateString
        } else {
            // Parse the input date string into a Date object
            guard let date = inputDateFormatter.date(from: inputDateString) else {
                print("Failed to parse date")
                return
            }
            // Convert the Date object to the desired output format
            outputStartDateString = outputDateFormatter.string(from: date)
            print(outputStartDateString) // Output: "2023-12-31T00:00:00.0000"
        }
        
        if inputEndDateString.range(of: "T") != nil, inputEndDateString.range(of: "Z") != nil {
            // Create a DateFormatter instance with the input date format
            let inputDateFormatter = DateFormatter()
            inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
            // Parse the input date string into a Date object
            guard let date = inputDateFormatter.date(from: inputEndDateString) else {
                print("Failed to parse date")
                return
            }
            // Create another DateFormatter instance with the desired output format
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
            // Convert the Date object to the desired output format
            let outputDateString = outputDateFormatter.string(from: date)
            print(outputDateString) // Output: "2023-01-01T00:00:00.0000"
            outputEndDateString = outputDateString
        } else if inputEndDateString.range(of: " ") == nil {
            outputEndDateString = inputEndDateString
        } else {
            // Parse the input date string into a Date object
            guard let endDate = inputDateFormatter.date(from: inputEndDateString) else {
                print("Failed to parse date")
                return
            }
            // Convert the Date object to the desired output format
            outputEndDateString = outputDateFormatter.string(from: endDate)
            print(outputEndDateString) // Output: "2023-12-31T00:00:00.0000"
        }
        
        self.settingsViewModel.updateSettingsRecord(userId: UserDefaultModule.shared.getUserID() ?? "", hours: location ?? "", days: threshold ?? "", workDayInput: stringRepresentation, taxStartYear: outputStartDateString, taxEndYear: outputEndDateString, taxableDays: self.selectedTaxableDay ?? "", definitionOfDays : self.definitionTextfield.text ?? "",controller: self, enableLoader: true) { response in
            DispatchQueue.main.async {
                UserDefaultModule.shared.setThresholdDetails(threshold: "\(response.entity?.minWorkDay ?? "")")
                UserDefaultModule.shared.setSettingsTaxableStartDate(startDate: response.entity?.taxStartYear ?? "")
                UserDefaultModule.shared.setSettingsTaxableEndDate(endDate: response.entity?.taxEndYear ?? "")
                UserDefaultModule.shared.setMaximumStayCount(dayCount: response.entity?.taxableDays ?? 0)
                UserDefaultModule.shared.setDefinitionOfDay(time: response.entity?.definitionOfDays ?? "")
            }
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Successfully updated", image: UIImage(named: "Notification") ?? nil,theme: .custom)
            
        } onFailure: { error in
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case alertLocationTextfiled:
            LocationPickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(LocationPickerView, didSelectRow: 0, inComponent: 0)

        case alertThresholdTextfiled:
            thresholdPickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(thresholdPickerView, didSelectRow: 0, inComponent: 0)
            
        case minimumStayAlertTextfield:
            taxableDaysPickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(taxableDaysPickerView, didSelectRow: 0, inComponent: 0)

        default:
            break
        }
    }
    
}
