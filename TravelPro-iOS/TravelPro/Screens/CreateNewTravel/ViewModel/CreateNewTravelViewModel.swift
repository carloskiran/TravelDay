//
//  CreateNewTravelViewModel.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 10/05/23.
//

import Foundation
import UIKit
import Alamofire

class CreateNewTravelViewModel {
    
    /// CreateTravelRecord
    /// - Parameters:
    ///   - startDate: String
    ///   - endDate: String
    ///   - taxDays: Int
    ///   - definitionDay: String
    ///   - fiscalStart: String
    ///   - fiscalEnd: String
    ///   - thresholdDays: Int
    ///   - travelTypeId: Int
    ///   - travelNotes: String
    ///   - nonWorkDays: [String]
    ///   - controller: UIViewController
    ///   - enableLoader: Bool
    ///   - success: CreateTravelModel
    ///   - failure: String
    func createTravelRecord(userId:String = "",
                            travelId:String = "",
                            origin: Int = 0,
                            destination: Int = 0,
                            startDate: String = "",
                            endDate: String = "",
                            taxDays:Int = 0,
                            definitionDay:String = "",
                            fiscalStart:String = "",
                            fiscalEnd:String = "",
                            thresholdDays:Int = 0,
                            travelTypeId:Int = 4,
                            otherTravelType:String = "",
                            travelNotes:String = "",
                            nonWorkDays:[String] = [],
                            isDefaultSettingsExist:Bool = false ,
                            controller : UIViewController = UIViewController() ,
                            enableLoader:Bool = false ,
                            manageTravel:ManageTravelType = .create,
                            travelHotel:[String] = [""],
                            foodEntertainment:[String] = [""],
                            shoppingUtility:[String] = [""],
                            others:[String] = [""],
                            onSuccess success: @escaping (CreateTravelModel) -> Void,
                            onFailure failure: @escaping (String) -> Void) {
        
        var params:[String : Any] = [
            "userId": userId,
            "origin" : origin,
            "destination" : destination,
            "startDate" : startDate,
            "endDate" : endDate,
            "taxableDays" : taxDays,
            "definitionOfTaxDays" : definitionDay,
            "fiscalStartYear" : fiscalStart,
            "fiscalEndYear" : fiscalEnd,
            "thresholdDays" : thresholdDays,
            "travelType" : travelTypeId,
            "otherTravelType": otherTravelType,
            "checkList" : travelNotes,
            "travelHotel" : travelHotel,
            "foodEntertainment" : foodEntertainment,
            "shoppingUtility" : shoppingUtility,
            "others" : others
        ]

        if isDefaultSettingsExist == true {
            params["skipValidation"] = true
        }
        if manageTravel == .edit {
            params["travelId"] = travelId
        }
        let request = CreateTravelAPIRequest(params)
        if enableLoader {
            Loader.startLoading(controller.view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: CreateTravelModel.self) { responses in
            if enableLoader {
                Loader.stopLoading(controller.view)
            }
            switch responses {
            case .success(let response):
                success(response)
            case .failure(let error):
                failure(error.description)
            }
        }
    }
    
    
    /// CheckTravelParamsAPI
    /// - Parameters:
    ///   - startDate: String
    ///   - endDate: String
    ///   - taxDays: Int
    ///   - definitionDay: String
    ///   - fiscalStart: String
    ///   - fiscalEnd: String
    ///   - thresholdDays: Int
    ///   - travelTypeId: Int
    ///   - travelNotes: String
    ///   - nonWorkDays: [String]
    ///   - controller: UIViewController
    ///   - enableLoader: Bool
    ///   - success: CreateTravelModel
    ///   - failure: String
    func checkTravelParamsAPI(userId:String = "",
                            origin: Int = 0,
                            destination: Int = 0,
                            startDate: String = "",
                            endDate: String = "",
                            taxDays:Int = 0,
                            definitionDay:String = "",
                            fiscalStart:String = "",
                            fiscalEnd:String = "",
                            thresholdDays:Int = 0,
                            travelTypeId:Int = 0,
                            otherTravelType:String = "",
                            travelNotes:String = "",
                            nonWorkDays:[String] = [],
                            controller : UIViewController = UIViewController() ,
                            enableLoader:Bool = false ,
                            manageTravel:ManageTravelType = .create,
                            travelHotel:[String] = [""],
                            foodEntertainment:[String] = [""],
                            shoppingUtility:[String] = [""],
                            others:[String] = [""],
                            onSuccess success: @escaping (CheckTravelParamsResponse) -> Void,
                            onFailure failure: @escaping (String) -> Void) {
        
        let params = ["": ""]
        let request = CheckTravelParamsAPIRequest(params,destination: destination,maximumStayDays: taxDays,definitionOfDays: definitionDay,fiscalStartYear: fiscalStart,fiscalEndYear: fiscalEnd,threshold: thresholdDays)
        if enableLoader {
            Loader.startLoading(controller.view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: CheckTravelParamsResponse.self) { responses in
            if enableLoader {
                Loader.stopLoading(controller.view)
            }
            switch responses {
            case .success(let response):
                success(response)
            case .failure(let error):
                failure(error.description)
            }
        }
    }
    
    
    
    /// OverrideRecordAPI
    /// - Parameters:
    ///   - startDate: String
    ///   - endDate: String
    ///   - taxDays: Int
    ///   - definitionDay: String
    ///   - fiscalStart: String
    ///   - fiscalEnd: String
    ///   - thresholdDays: Int
    ///   - travelTypeId: Int
    ///   - travelNotes: String
    ///   - nonWorkDays: [String]
    ///   - controller: UIViewController
    ///   - enableLoader: Bool
    ///   - success: CreateTravelModel
    ///   - failure: String
    func overrideRecordAPI(userId:String = "",
                           recordID:String = "",
                            origin: Int = 0,
                            destination: Int = 0,
                            startDate: String = "",
                            endDate: String = "",
                            taxDays:Int = 0,
                            definitionDay:String = "",
                            fiscalStart:String = "",
                            fiscalEnd:String = "",
                            thresholdDays:Int = 0,
                            travelTypeId:Int = 0,
                            otherTravelType:String = "",
                            travelNotes:String = "",
                            nonWorkDays:[String] = [],
                            controller : UIViewController = UIViewController() ,
                            enableLoader:Bool = false ,
                            manageTravel:ManageTravelType = .create,
                            travelHotel:[String] = [""],
                            foodEntertainment:[String] = [""],
                            shoppingUtility:[String] = [""],
                            others:[String] = [""],
                            onSuccess success: @escaping (OverrideAPIResponse) -> Void,
                            onFailure failure: @escaping (String) -> Void) {
        
        let params:[String : Any] = [
            "userId": userId,
            "origin" : origin,
            "destination" : destination,
            "startDate" : startDate,
            "endDate" : endDate,
            "taxableDays" : taxDays,
            "definitionOfTaxDays" : definitionDay,
            "fiscalStartYear" : fiscalStart,
            "fiscalEndYear" : fiscalEnd,
            "thresholdDays" : thresholdDays,
            "travelType" : travelTypeId,
            "otherTravelType": otherTravelType,
            "checkList" : travelNotes,
            "travelHotel" : travelHotel,
            "foodEntertainment" : foodEntertainment,
            "shoppingUtility" : shoppingUtility,
            "others" : others
        ]

        let request = OverrideRecordParamsAPIRequest(params, recordID: recordID)
        if enableLoader {
            Loader.startLoading(controller.view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: OverrideAPIResponse.self) { responses in
            if enableLoader {
                Loader.stopLoading(controller.view)
            }
            switch responses {
            case .success(let response):
                success(response)
            case .failure(let error):
                failure(error.description)
            }
        }
    }

    func confirmStayAPI(existingId:String = "",
                        origin: String = "",
                        destination: String = "",
                        startDate:String = "",
                        controller : UIViewController = UIViewController() ,
                        enableLoader:Bool = false,
                        onSuccess success: @escaping (OverrideAPIResponse) -> Void,
                        onFailure failure: @escaping (String) -> Void) {
        
        let request = ConfirmStayAPIRequest(existingId: existingId, origin: "\(origin)", destination: "\(destination)", startDate: startDate)
        if enableLoader {
            Loader.startLoading(controller.view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: OverrideAPIResponse.self) { responses in
            if enableLoader {
                Loader.stopLoading(controller.view)
            }
            switch responses {
            case .success(let response):
                success(response)
            case .failure(let error):
                failure(error.description)
            }
        }
    }
    
    
}

