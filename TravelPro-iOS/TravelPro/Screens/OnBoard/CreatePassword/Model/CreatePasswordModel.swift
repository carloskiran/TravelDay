//
//  CreatePasswordModel.swift
//  TravelPro
//
//  Created by VIJAY M on 26/04/23.
//

import Foundation

// MARK: - Welcome
struct CreatePasswordResponse: Codable {
    let status: PasswordStatus?
    let entity: String?
}

// MARK: - Status
struct PasswordStatus: Codable {
    let status: Int?
    let message: String?
}
