//
//  CreateNewTravel+NetworkCallExtension.swift
//  TravelPro
//
//  Created by MAC-OBS-48 on 11/09/23.
//

import Foundation
import UIKit


extension CreateNewTravelViewController {
    
    // MARK: - Network requests
    
    /// CreateTravelRecordAPI
    func createTravelRecordAPI(defaultSettingsExist:Bool) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - createTravelRecordAPI"))
        self.createTravelViewModel.createTravelRecord(userId:UserDefaultModule.shared.getUserID() ?? "",
                                                      travelId: self.manageTravel == .edit ? self.travelID : "",
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
                                                      isDefaultSettingsExist: defaultSettingsExist,
                                                      controller: self,
                                                      enableLoader: true,
                                                      manageTravel: self.manageTravel, travelHotel: self.travelAndHoterlDocumentArray, foodEntertainment: self.foodAndEntertainmentDocumentArray, shoppingUtility: self.shoppingAndUtilityDocumentArray, others: self.othersDocumentArray)
        { response in
            print("RES",response)
            
            let status = response.status?.status
            guard status != nil else {
                TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - createTravelRecordAPI - status nil"))
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "status response nil", image: UIImage(named: "Notification") ?? nil,theme: .custom)
                return
            }
            
            switch status {
            case 302: /// Record already exist
                TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - createTravelRecordAPI - status == 302, TravelID: \(response.entity?.travelID ?? "")"))
                self.existingRecordEntity = response.entity
                DispatchQueue.main.async {
                    self.showRecordExistAlert(response.entity?.sameYearAndToCountry ?? "", response.entity?.travelID ?? "")
                }
                
            case 303: /// If Default settings values exist in record
                TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - createTravelRecordAPI - status == 303, TravelID: \(response.entity?.travelID ?? "")"))
//                self.existingRecordEntity = .entity
                self.configDefaultSettingsValueRecordExistPopup(response.entity?.checkTravelParameters)
                
            case 200: /// New Record created
                TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - createTravelRecordAPI - success response"))
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: self.manageTravel == .create ? "Successfully created" : "Successfully updated", image: UIImage(named: "Notification") ?? nil,theme: .custom)
                //            LandingTabBarController.loadFromNib().selectedIndex = 2
                self.createTravelHandler = CreateTravelHelper()
                self.selectedDatesRange = []
                switch self.manageTravel {
                case .edit:
                    self.navigationController?.popViewController(animated: true)
                default:
                    self.navigationController?.popViewController(animated: false)
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    if let tabBarController = appDelegate?.window!.rootViewController as? UITabBarController {
                        tabBarController.selectedIndex = 1
                    }
                }
                
            default:
                TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - createTravelRecordAPI - not succeed"))
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: response.status?.msg ?? "", image: UIImage(named: "Notification") ?? nil,theme: .custom)
            }
            
        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - createTravelRecordAPI - failure response"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }
        
    }
    
    func checkTravelParamsAPI(_ recordId:String) {
       
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - checkTravelParamsAPI"))
        self.createTravelViewModel.checkTravelParamsAPI(
                                                        userId:UserDefaultModule.shared.getUserID() ?? "",
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
                                                        controller: self,
                                                        enableLoader: true,
                                                        manageTravel: self.manageTravel, travelHotel: self.travelAndHoterlDocumentArray, foodEntertainment: self.foodAndEntertainmentDocumentArray, shoppingUtility: self.shoppingAndUtilityDocumentArray, others: self.othersDocumentArray)
        { response in
       
        let status = response.status?.status
            switch status {
            case 200:
                TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - checkTravelParamsAPI - success response"))
                guard let entityData = response.entity else {
                    TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - checkTravelParamsAPI - response.entity is nil"))
                    return
                }
                self.configCheckTravelParamsPopup(entityData, recordId)
            default:
                TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - checkTravelParamsAPI - not success: \(response.status?.status ?? 0)"))
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: response.status?.msg ?? "", image: UIImage(named: "Notification") ?? nil,theme: .custom)
            }
            
        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - checkTravelParamsAPI - failure response"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)

        }

    }
    
    func overrideRecordAPI(_ recordId:String) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - overrideRecordAPI"))
        self.createTravelViewModel.overrideRecordAPI(
            userId:UserDefaultModule.shared.getUserID() ?? "",
            recordID: recordId,
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
            controller: self,
            enableLoader: true,
            manageTravel: self.manageTravel, travelHotel: self.travelAndHoterlDocumentArray, foodEntertainment: self.foodAndEntertainmentDocumentArray, shoppingUtility: self.shoppingAndUtilityDocumentArray, others: self.othersDocumentArray)
        { response in
            let status = response.status?.status
            switch status {
            case 200:
                TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - overrideRecordAPI - success response"))
                self.createTravelHandler = CreateTravelHelper()
                self.selectedDatesRange = []
                switch self.manageTravel {
                case .edit:
                    self.navigationController?.popViewController(animated: true)
                default:
                    self.navigationController?.popViewController(animated: false)
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    if let tabBarController = appDelegate?.window!.rootViewController as? UITabBarController {
                        tabBarController.selectedIndex = 1
                    }
                }
            default:
                TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - overrideRecordAPI - not success: \(response.status?.status ?? 0)"))
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "\(response.status?.status ?? 0) \(response.status?.msg ?? "")"  , image: UIImage(named: "Notification") ?? nil,theme: .custom)
            }
        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - overrideRecordAPI - failure response"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }

    }
}
