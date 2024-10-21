//
//  MyTravelDetailModel.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 25/05/23.
//

import Foundation

struct TravelDetailModel: Codable {
    let status: TravelListStatus?
    let entity:  EntityObject?
    enum CodingKeys: String, CodingKey {
        case status
        case entity
    }
}


struct EntityObject: Codable {
    let countryList: [CountryListObject]?
    let currentRecord: TravelListEntity?
    enum CodingKeys: String, CodingKey {
        case countryList
        case currentRecord
    }
}


struct CountryListObject: Codable {
    let origin, destination, startDate, endDate: String
    let travelID: String
    let createdBy: String
    let physicalPresenceDays: Int

    enum CodingKeys: String, CodingKey {
        case origin, destination, startDate, endDate
        case travelID = "travelId"
        case createdBy
        case physicalPresenceDays
    }
}

// MARK: - TravelSummaryResponse
struct TravelSummaryResponse: Codable {
    let status: TravelSummaryStatus?
    let entity: TravelSummaryEntity?
}

// MARK: - Entity
struct TravelSummaryEntity: Codable {
    let travelID: String?
    let userID: UserID?
    let origin, destination: Destination?
    let sameYearAndToCountry: String?
    let startDate, endDate: String?
    let taxableDays, numberOfTaxDaysUsed, numberOfTaxDaysLeft: Int?
    let definitionOfTaxDays, fiscalStartYear, fiscalEndYear: String?
    let thresholdDays: Int?
    let travelType: TravelType?
    let otherTravelType: String?
    let daysAway: Int?
    let createdOn, updatedOn: String?
    let checklist: String?
    let travelHotel, foodEntertainment, shoppingUtility, others: String?
    let physicalPresenceDays: Int?
    let resident: Bool?
    let confirmStay: Bool?
    let checkTravelParameters: CheckParamsEntity?
    
    enum CodingKeys: String, CodingKey {
        case travelID = "travelId"
        case userID = "userId"
        case origin, destination, startDate, endDate, taxableDays, numberOfTaxDaysUsed, numberOfTaxDaysLeft, definitionOfTaxDays, fiscalStartYear, fiscalEndYear, thresholdDays, travelType, otherTravelType, daysAway, createdOn, updatedOn, checklist, travelHotel, foodEntertainment, shoppingUtility, others, physicalPresenceDays, resident,confirmStay,sameYearAndToCountry
        case checkTravelParameters
    }
}


// MARK: - Status
struct TravelSummaryStatus: Codable {
    let status: Int?
    let msg: String?
}



// MARK: - NewUserCheckResponse
struct NewUserCheckResponse: Codable {
    let status: TravelSummaryStatus?
    let entity: [UserCheckEntity]?
}

// MARK: - Entity
struct UserCheckEntity: Codable {
    let travelID: String

    enum CodingKeys: String, CodingKey {
        case travelID = "travelId"
    }
}
