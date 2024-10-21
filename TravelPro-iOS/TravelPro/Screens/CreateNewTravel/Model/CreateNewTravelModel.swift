//
//  CreateNewTravelModel.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 10/05/23.
//

import Foundation

// MARK: - CreateTravelModel

struct CreateTravelModel: Codable {
    let status: CreateTravelStatus?
    let entity: TravelSummaryEntity?
}

// MARK: - CreateTravelStatus
struct CreateTravelStatus: Codable {
    let status: Int?
    let msg: String?
}


// MARK: - Check Travel Params

struct CheckTravelParamsResponse: Codable {
    let status: ParamsStatus?
    let entity: CheckParamsEntity?
}

// MARK: - CreateTravelStatus
struct ParamsStatus: Codable {
    let status: Int?
    let msg: String?
}


// MARK: - Entity
struct CheckParamsEntity: Codable {
    let maximumStayDays: Bool?
    let definitionOfDays: Bool?
    let fiscalYear : Bool?
    let threshold : Bool?

    enum CodingKeys: String, CodingKey {
        case maximumStayDays
        case definitionOfDays
        case fiscalYear
        case threshold
    }
}


// MARK: - Override response

struct OverrideAPIResponse: Codable {
    let status: CreateTravelStatus?
}
