//
//  DashboardViewController+NetworkCallExtension.swift
//  TravelPro
//
//  Created by MAC-OBS-48 on 11/09/23.
//

import Foundation
import UIKit


extension DashBoardViewController {
    
    // MARK: - Network Call
    
    func getUpcomingTravelList(date: String){
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - getUpcomingTravelList"))
        self.listViewModel.myTravelList(userID: UserDefaultModule.shared.getUserID() ?? "", type: date, enableLoader: true,controller: self) { response in
            TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - getUpcomingTravelList - success response"))
            self.upcomingtravelList = response.traveList
            if self.upcomingtravelList.count == 0 {
                DispatchQueue.main.async {
                    self.noUpcomingScheduleLabel.isHidden = false
                    self.upcomingAllButton.isHidden = true
                }
            } else {
                DispatchQueue.main.async {
                    self.noUpcomingScheduleLabel.isHidden = true
                }
                if self.upcomingtravelList.count > 5 {
                    DispatchQueue.main.async {
                        self.upcomingAllButton.isHidden = false
                    }
                } else {
                    DispatchQueue.main.async {
                        self.upcomingAllButton.isHidden = true
                    }
                }
            }
        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - getUpcomingTravelList - failure response"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }
    }
    
    func getRecentTravelList(){
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - getRecentTravelList"))
        self.travelListViewModel.myTravelList(userID: UserDefaultModule.shared.getUserID() ?? "", type: self.selectedDate, enableLoader: false) { response in
            TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - getUpcomingTravelList - success response"))
            var travelRecords = response.traveList
            if !travelRecords.isEmpty {
                travelRecords.removeFirst()
            }
            self.recenttravelList.removeAll()
            self.recenttravelList = travelRecords
            self.registerCells()
            if self.recenttravelList.count == 0 {
                DispatchQueue.main.async {
                    self.noRecentVisitLabel.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    self.noRecentVisitLabel.isHidden = true
                }
                if self.recenttravelList.count > 5 {
                    DispatchQueue.main.async {
                        self.recentAllButton.isHidden = false
                    }
                } else {
                    DispatchQueue.main.async {
                        self.recentAllButton.isHidden = true
                    }
                }
            }

        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - getUpcomingTravelList - failure response"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }

    }
    
    func getCurrentListResponse(){
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - getCurrentListResponse"))
        self.travelListViewModel.myTravelList(userID: UserDefaultModule.shared.getUserID() ?? "", type: self.selectedDate, enableLoader: false) { response in
            if response.traveList.count > 0 {
                TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - getCurrentListResponse - success response"))
                self.currentTravelResponse = response.traveList
                if let travel = response.traveList.first {
                    self.setupCurrentTravelDetail(travel)
                }
                DispatchQueue.main.async {
                    self.currentScheduleCustomView.isHidden = false
                    self.noCurrentScheduleLabel.isHidden = true
                }
            } else {
                DispatchQueue.main.async {
                    self.currentScheduleCustomView.isHidden = true
                    self.noCurrentScheduleLabel.isHidden = false
                }
            }

        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - getUpcomingTravelList - failure response"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }

    }

    func getNewUserRecordAPI() {
        
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - getNewUserRecordAPI"))
        self.travelListViewModel.getNewCheckUserAPI(enableLoader: true) { response in
            let responseData = response.status
            if responseData?.status == 200 {
                guard let entity = response.entity else {
                    TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - getNewUserRecordAPI: Entity nil"))
                    return
                }
                switch entity.count {
                case 0:
                    TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - getNewUserRecordAPI entity.count = 0"))
                    UserDefaultModule.shared.set(true, forKey: "noTravelRecordUser")
                    DispatchQueue.main.async {
                        self.locationDetectedView.isHidden = false
                        self.currentLocationTextfield.text = self.locationData.country
                        self.tabBarController?.tabBar.isUserInteractionEnabled = false
                    }
                default:
                    DispatchQueue.main.async {
                        self.tabBarController?.tabBar.isUserInteractionEnabled = true
                    }
                    TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - getNewUserRecordAPI entity.count > 0"))
                    UserDefaultModule.shared.set(false, forKey: "noTravelRecordUser")
                    self.invokeLocationSendApi()
//                    self.getCurrentListResponse()
                    
                }
            }
            
        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - getNewUserRecordAPI - failure response: \(error)"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
            
        }
        
    }
    
    func requestAuthorizeIfNoRecord(){
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - requestAuthorizeIfNoRecord"))
        self.travelListViewModel.getNewCheckUserAPI(enableLoader: true) { response in
            let responseData = response.status
            if responseData?.status == 200 {
                guard let entity = response.entity else {
                    TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - requestAuthorizeIfNoRecord: Entity nil"))
                    return
                }
                switch entity.count {
                case 0:
                    LocationManager.shared.checkLocationService()
                    UserDefaultModule.shared.set(false, forKey: "noTravelRecordUser")
                default:
                    TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - requestAuthorizeIfNoRecord: entity > 0 \(entity))"))
                }
            }
            
        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - getNewUserRecordAPI - failure response: \(error)"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }
    }
    
    func confirmStayAPI() {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - confirmStayAPI"))
        self.createTravelViewModel.confirmStayAPI(existingId: self.confirmStayHandler.existingId,
                                                  origin: self.confirmStayHandler.origin,
                                                  destination: self.confirmStayHandler.destination,
                                                  startDate: self.confirmStayHandler.startDate,
                                                  controller: self,
                                                  enableLoader: true) { response in
            let responseData = response.status
            if responseData?.status == 200 {
                self.tabBarController?.tabBar.isUserInteractionEnabled = true
                DispatchQueue.main.async {
                    self.confirmStayPopupView.isHidden = true
                }
                self.confirmStayHandler = ConfirmStayHandler()
                self.currentCountryFromConfirmStay.text = ""
                self.travelDataArrivedFromConfirmStay.text = ""
                self.countryArrivedFromConfirmStay.text = ""
                self.currentDataFromConfirmStay.text = ""
                self.getCurrentListResponse()
                self.getRecentTravelList()
                self.getUpcomingTravelList(date: self.selectedDate)
                self.selectCurrentYear()
            }
        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - confirmStayAPI - failure response: \(error)"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }
        
    }
    
    func confirmStayClosePopupAPI() {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - confirmStayClosePopupAPI"))
        self.createTravelViewModel.confirmStayAPI(existingId: self.confirmStayHandler.existingId,
                                                  origin: "",
                                                  destination: self.confirmStayHandler.destination,
                                                  startDate: "",
                                                  controller: self,
                                                  enableLoader: true) { response in
            let responseData = response.status
            if responseData?.status == 200 {
                self.tabBarController?.tabBar.isUserInteractionEnabled = true
                DispatchQueue.main.async {
                    self.confirmStayPopupView.isHidden = true
                }
                self.confirmStayHandler = ConfirmStayHandler()
                self.currentCountryFromConfirmStay.text = ""
                self.travelDataArrivedFromConfirmStay.text = ""
                self.countryArrivedFromConfirmStay.text = ""
                self.currentDataFromConfirmStay.text = ""
                self.getCurrentListResponse()
            }
        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - confirmStayClosePopupAPI - failure response: \(error)"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }
    }
    
     func invokeLocationSendApi() {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - invokeLocationSendApi: \(self.locationData)"))
        Loader.startLoading(self.view,userIneration: false)
        LocaitonPushServiceCall.shared.sendLocationPush(userID: UserDefaultModule.shared.getUserID() ?? "", countryName: self.locationData.country ?? "", countryCode: self.locationData.countryCode ?? "" , timestamp: self.locationData.timestamp ?? "",fromCountryName: self.locationData.fromCountryName ?? "",fromCountryCode: self.locationData.fromCountryCode ?? "" ,fromDate: self.locationData.fromDate ?? "") { status,description  in
            DispatchQueue.main.async {
                Loader.stopLoading(self.view)
            }
            switch status {
            case 200:
                DispatchQueue.main.async {
                    self.tabBarController?.tabBar.isUserInteractionEnabled = true
                }
                DispatchQueue.main.async {
                    if self.locationDetectedView.isHidden == false {
                        self.locationDetectedView.isHidden = true
                        self.currentLocationTextfield.text = ""
                        self.startDateTextfield.text = ""
                        self.countryFrom.text = ""
                        self.selectCurrentYear()
                    }
                    self.getCurrentListResponse()
                    self.getRecentTravelList()
                    self.getUpcomingTravelList(date: self.selectedDate)
                }
                TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - invokeLocationSendApi: success: \(status)"))
            default:
                TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - invokeLocationSendApi: not sucess: \(status)"))
                DispatchQueue.main.async {
                    self.tabBarController?.tabBar.isUserInteractionEnabled = true
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "error: \(status) \(description)", image: UIImage(named: "Notification") ?? nil,theme: .custom)
                }
            }
        }
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
    }
    
    @objc func ViewUserSettingsAPICall() {
        
        self.settingsViewModel.ViewSettingsRecord(controller: self, enableLoader: false) { response in
            UserDefaultModule.shared.setThresholdDetails(threshold: "\(response.entity?.minWorkDay ?? "")")
            UserDefaultModule.shared.setNonWorkingDays(days: response.entity?.nonWorkingDays ?? "1,7")
            UserDefaultModule.shared.setSettingsTaxableStartDate(startDate: response.entity?.taxStartYear ?? "")
            UserDefaultModule.shared.setSettingsTaxableEndDate(endDate: response.entity?.taxEndYear ?? "")
            UserDefaultModule.shared.setMaximumStayCount(dayCount: response.entity?.taxableDays ?? 183)
            UserDefaultModule.shared.setDefinitionOfDay(time: response.entity?.definitionOfDays ?? "00:10:00")
        } onFailure: { error in
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }
        
    }
    
    @objc func APICalling() {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - APICalling"))
        notificationAPIViewModel.getNotificationAPI(enableLoader: false ,controller: self) { response in
            if let response = response {
                TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - APICalling - success response"))
                self.notificationResponse = response
                if response.message {
                    self.notificationHighLightView.isHidden = false
                } else {
                    self.notificationHighLightView.isHidden = true
                }
                
            }
        } onFailure: { errorResponse in
            TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - APICalling - failure response"))
            print(errorResponse)
        }
    }
    
    @objc func locationDetectSuccessCallback() {
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.isAppBackground = false
        DispatchQueue.main.async {
            UserLocationSetting.sharedInstance.isLocationAccessDenied = false
            self.getRecentTravelList()
            self.getCurrentListResponse()
            self.getUpcomingTravelList(date: self.selectedDate)
        }

    }
    
}
