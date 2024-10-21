//
//  MyTravelListModel.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 19/05/23.
//

import Foundation


struct MyTravelListModel: Codable {
    let status: TravelListStatus?
    let traveList: [TravelListEntity?]
    enum CodingKeys: String, CodingKey {
        case status
        case traveList = "entity"
    }
}

// MARK: - CreateTravelStatus
struct TravelListStatus: Codable {
    let status: Int?
    let msg: String?
}

// MARK: - Entity
struct TravelListEntity: Codable
{
    let travelId: String?
    let userID: ViewProfileUserID?
    let origin:Origin?
    let destination:Origin?
    let startDate: String?
    let endDate: String?
    let taxableDays: Int?
    let numberOfTaxDaysLeft:Int?
    let numberOfTaxDaysUsed:Int?
    let definitionOfTaxDays: String?
    let fiscalStartYear: String?
    let fiscalEndYear: String?
    let thresholdDays: Int?
    let travelType:TravelType?
    let workDays: Int?
    let otherTravelType: String?
    let nonWorkingDays: String?
    let totalDays: Int?
    let daysAway: Int?
    let createdOn: String?
    let updatedOn: String?
    let checklist: String?
    let travelHotel: String?
    let foodEntertainment: String?
    let shoppingUtility: String?
    let others: String?
    let totalDaysRemaining: Int?
    let workDaysRemaining: Int?
    let nonWorkDaysRemaining: Int?
    let totalDaysCompleted: Int?
    let workDaysCompleted: Int?
    let nonWorkDaysCompleted: Int?
    let totalNonWorkDays: Int?
    let totalWorkDays: Int?
    let resident: Bool?
    let confirmStay: Bool?
    let totalPhysicalPresenceDays:Int?

    enum CodingKeys: String, CodingKey {
        case travelId
        case userID = "userId"
        case origin
        case destination
        case startDate
        case endDate
        case taxableDays
        case numberOfTaxDaysLeft
        case numberOfTaxDaysUsed
        case definitionOfTaxDays
        case fiscalStartYear
        case fiscalEndYear
        case thresholdDays
        case travelType
        case workDays
        case otherTravelType
        case nonWorkingDays
        case totalDays
        case daysAway
        case createdOn
        case updatedOn
        case checklist
        case travelHotel
        case foodEntertainment
        case shoppingUtility
        case others
        case totalDaysRemaining
        case workDaysRemaining
        case nonWorkDaysRemaining
        case totalDaysCompleted
        case workDaysCompleted
        case nonWorkDaysCompleted
        case totalNonWorkDays
        case totalWorkDays
        case resident
        case confirmStay
        case totalPhysicalPresenceDays
    }
}


struct Origin: Codable {
    let countryId:Int?
    let countryCode:String?
    let countryCodeThreeLetter:String?
    let countryDialCode:String?
    let countryName:String?

    enum CodingKeys: String, CodingKey {
        case countryId
        case countryCode
        case countryCodeThreeLetter
        case countryDialCode
        case countryName
    }
}


struct TravelType: Codable {
    let id:Int?
    let type:String?

    enum CodingKeys: String, CodingKey {
        case id
        case type
    }
}


// MARK: - FilterResponseModel
struct FilterResponseModel: Codable {
    let status: TravelListStatus
    let entity: [TravelListEntity]
}

// MARK: - Entity
struct FilterResponseEntity: Codable {
    let travelID: String
    let userID: UserID
    let origin, destination: Destination
    let startDate, endDate: String
    let taxableDays, numberOfTaxDaysUsed, numberOfTaxDaysLeft: Int
    let definitionOfTaxDays, fiscalStartYear, fiscalEndYear: String
    let thresholdDays: Int
    let travelType: TravelType
    let otherTravelType: String?
    let daysAway: Int
    let createdOn, updatedOn: String
    let checklist: String?
    let travelHotel, foodEntertainment, shoppingUtility, others: String?
    let physicalPresenceDays: Int
    let resident: Bool

    enum CodingKeys: String, CodingKey {
        case travelID = "travelId"
        case userID = "userId"
        case origin, destination, startDate, endDate, taxableDays, numberOfTaxDaysUsed, numberOfTaxDaysLeft, definitionOfTaxDays, fiscalStartYear, fiscalEndYear, thresholdDays, travelType, otherTravelType, daysAway, createdOn, updatedOn, checklist, travelHotel, foodEntertainment, shoppingUtility, others, physicalPresenceDays, resident
    }
}

// MARK: - Destination
struct Destination: Codable {
    let countryID: Int
    let countryCode, countryCodeThreeLetter, countryDialCode, countryName: String

    enum CodingKeys: String, CodingKey {
        case countryID = "countryId"
        case countryCode, countryCodeThreeLetter, countryDialCode, countryName
    }
}

// MARK: - UserID
struct FilterResponseUserID: Codable {
    let userID, fistName, lastName, userName: String
    let dob, emailID, resident: String
    let mobileVerification, emailVerification: Bool
    let accountStatus: AccountStatus
    let accountType: FilterResponseAccountType
    let createdOn, updatedOn: String
    let active: Bool
    let country: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case fistName, lastName, userName, dob
        case emailID = "emailId"
        case resident, mobileVerification, emailVerification, accountStatus, accountType, createdOn, updatedOn, active, country
    }
}

// MARK: - AccountType
struct FilterResponseAccountType: Codable {
    let id: Int
    let accountType: String
}
