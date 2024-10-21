//
//  ExportModel.swift
//  TravelPro
//
//  Created by MAC-OBS-31 on 12/06/23.
//

import Foundation

struct ExportStatusModel: Codable {
    let status: Int?
    let msg: String?
}

// MARK: - Welcome
struct ExportResponse: Codable {
    let status: ExportStatusModel?
    let entity: [ExportEntity]?
}

        
// MARK: - Entity
struct ExportEntity: Codable {
    let physicalPresenceDay, numberofTaxableDays, workDays: Int?
    let origin, designation, nonWorkDays, definitionofDay, from, to: String?

    enum CodingKeys: String, CodingKey {
        case physicalPresenceDay, numberofTaxableDays, workDays
        case origin, designation, nonWorkDays, definitionofDay, from, to
    }
}
