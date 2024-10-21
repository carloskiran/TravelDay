//
//  GeneralSupport.swift
//  TravelPro
//
//  Created by VIJAY M on 08/06/23.
//

import Foundation

// MARK: - RegisterTokenModel
struct RegisterTokenModel: Codable {
    let status: TokenStatus
    let entity: TokenEntity?
}

// MARK: - Entity
struct TokenEntity: Codable {
    let id, type : String?
    let userID: String?
    let locationToken, token: String?

    enum CodingKeys: String, CodingKey {
        case id, type, token
        case userID = "userId"
        case locationToken
    }
}

// MARK: - Status
struct TokenStatus: Codable {
    let status: Int?
    let message: String?
}
