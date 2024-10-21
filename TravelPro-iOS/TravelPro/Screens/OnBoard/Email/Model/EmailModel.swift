//
//  EmailModel.swift
//  TravelPro
//
//  Created by Mac-OBS-32 on 26/04/23.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

// MARK: - Welcome
struct EmailCheckModel: Codable {
    let status: EmailCheckModelStatus?
    let entity: String?
}

// MARK: - Status
struct EmailCheckModelStatus: Codable {
    let status: Int?
    let message: String?
}
