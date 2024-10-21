//
//  SettingsModel.swift
//  TravelPro
//
//  Created by MAC-OBS-31 on 08/06/23.
//


import Foundation
import UIKit

class SettingsViewModel {


    func updateSettingsRecord(userId:String = "",
                            hours:String = "",
                            days: String = "",
                              workDayInput: String = "", taxStartYear: String = "", taxEndYear: String = "", taxableDays: String = "", definitionOfDays: String = "",
                            controller : UIViewController = UIViewController() ,
                            enableLoader:Bool = false ,
                            onSuccess success: @escaping (UpdateSettingsResponse) -> Void,
                            onFailure failure: @escaping (String) -> Void) {

        let request = updateSettingsAPIRequest(userID: userId, hours: hours, days: days, workDayInput: workDayInput, taxStartYear: taxStartYear, taxEndYear: taxEndYear, taxableDays: taxableDays, definitionOfDays: definitionOfDays)

        
        if enableLoader {
            Loader.startLoading(controller.view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: UpdateSettingsResponse.self) { responses in
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


    func ViewSettingsRecord(controller : UIViewController = UIViewController() ,
                            enableLoader:Bool = false ,
                            onSuccess success: @escaping (ShowSettingsResponse) -> Void,
                            onFailure failure: @escaping (String) -> Void) {


        let params = ["": ""]

        let request = ViewSettingsAPIRequest(params)

        if enableLoader {
            Loader.startLoading(controller.view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: ShowSettingsResponse.self) { responses in
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
    
    
    func ViewTermsAndCondition(controller : UIViewController = UIViewController() ,
                            enableLoader:Bool = false ,
                            onSuccess success: @escaping (TermsAndConditionResponse) -> Void,
                            onFailure failure: @escaping (String) -> Void) {

        let params = ["": ""]

        let request = TermsAndConditionAPIRequest(params)

        if enableLoader {
            Loader.startLoading(controller.view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: TermsAndConditionResponse.self) { responses in
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


    func DeleteAccountRecord(controller : UIViewController = UIViewController() ,
                            enableLoader:Bool = false ,
                            onSuccess success: @escaping (CommonStatusModel) -> Void,
                            onFailure failure: @escaping (String) -> Void) {


        let params = ["": ""]

        let request = DeleteAccountAPIRequest(params)

        if enableLoader {
            Loader.startLoading(controller.view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: CommonStatusModel.self) { responses in
            if enableLoader {
                Loader.stopLoading(controller.view)
            }
            switch responses {
            case .success(let response):
                success(response)
                return
            case .failure(let error):
                failure(error.description)
            }
        }
    }


}


// MARK: - Common response

struct CommonStatusResponse: Codable {
    let status: CommonStatusModel?
    let entity: ViewSettingsEntity?
}

struct CommonStatusModel: Codable {
    let status: Int?
    let message: String?
}

// MARK: - UpdateSettingsResponse
struct UpdateSettingsResponse: Codable {
    let status: SettingsStatus?
    let entity: SettingsEntity?
}

// MARK: - Status
struct SettingsStatus: Codable {
    let status: Int?
    let message: String?
}

// MARK: - Entity
struct SettingsEntity: Codable {
    let id: Int
    let userID: UserID
    let createdOn, updatedOn, locationCheckHours: String
    let minWorkDay: String
    let locationCheck: Int
    let taxStartYear, taxEndYear: String
    let taxableDays: Int
    let definitionOfDays: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case createdOn, updatedOn, locationCheckHours, minWorkDay, locationCheck, taxStartYear, taxEndYear, taxableDays
        case definitionOfDays
    }
}



// MARK: - Welcome
struct ViewSettingsResponse: Codable {
    let status: CommonStatusModel?
    let entity: ViewSettingsEntity?
}


// MARK: - Entity
struct ViewSettingsEntity: Codable {
    let id: Int?
    let userID: ViewSettingsUserID?
    let nonWorkingDays, createdOn, locationCheckHours,minWorkDay,updatedOn: String?
    let taxStartYear, taxEndYear: String
    let taxableDays: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case nonWorkingDays, createdOn, locationCheckHours,minWorkDay,updatedOn, taxStartYear, taxEndYear, taxableDays
    }
}

// MARK: - UserID
struct ViewSettingsUserID: Codable {
    let userID, firstName, lastName, userName: String?
    let dob, emailID: String?
    let mobileVerification, emailVerification: Bool?
    let countryCode: String?
    let accountStatus: ViewSettingsAccountStatus?
    let accountType: ViewSettingsAccountType?
    let profession, createdOn, updatedOn: String?
    let active,socialAccount: Bool?
    let country: String?
    let inValidAttempts: Int?
    let mobileNo,gender, registerType: String?
    let facebookId,googleId, appleId,socialLoginType,SettingsImage,resident,profileImage: String?


    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case firstName, lastName, userName, dob
        case emailID = "emailId"
        case mobileVerification, emailVerification, countryCode, accountStatus, accountType, profession, createdOn, updatedOn, active, country, inValidAttempts, mobileNo, registerType,gender,socialAccount
        case facebookId,googleId, appleId,socialLoginType,SettingsImage,resident,profileImage
    }
}


// MARK: - AccountStatus
struct ViewSettingsAccountStatus: Codable {
    let id: Int?
    let accountStatus: String?
}

// MARK: - AccountType
struct ViewSettingsAccountType: Codable {
    let id: Int?
    let userType: String?
}


// MARK: - Show Settings Response
struct ShowSettingsResponse: Codable {
    let status: CommonStatusModel?
    let entity: ShowSettingsEntity?
}


// MARK: - Entity
struct ShowSettingsEntity: Codable {
    let id: Int?
    let userID: ShowSettingsUserID?
    let nonWorkingDays, createdOn, locationCheckHours,minWorkDay,definitionOfDays,updatedOn: String?
    let taxStartYear, taxEndYear: String
    let taxableDays: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case nonWorkingDays, createdOn, locationCheckHours,minWorkDay,updatedOn, taxStartYear, taxEndYear, taxableDays,definitionOfDays
    }
}

// MARK: - UserID
struct ShowSettingsUserID: Codable {
    let userID, firstName, lastName, userName: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case firstName, lastName, userName
    }
}


// MARK: - View Terms&Condition Response

struct TermsAndConditionResponse: Codable {
    let status: CommonStatusModel?
    let entity: TermsAndConditionEntity?
}


struct TermsAndConditionEntity: Codable {
    let id: Int?
    let type: String?
    let content:String?

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case content
    }
}
