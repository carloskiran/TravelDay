//
//  LoginModel.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 18/04/23.
//

import Foundation
 

struct LoginDetailsResponse: Codable {
    let accessToken, refreshToken: String?
    let userType: Int?
    let scope: String?
    let profile: Profile?
    let tokenType, userID: String?
    let expiresIn: Int?
    let status: Status?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case userType = "user_type"
        case scope, profile
        case tokenType = "token_type"
        case userID = "user_id"
        case expiresIn = "expires_in"
        case status
    }
}

// MARK: - Profile
struct Profile: Codable {
    let id: String?
    let userID: UserID?
    let currrentCountry, taxableDays, definitionOfDay: String?
    let profileImage: String?
    let document, resident: String?
    let createdOn, updatedOn: String?
    let dob: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case currrentCountry, taxableDays, definitionOfDay, profileImage, document, resident, createdOn, updatedOn, dob
    }
}

// MARK: - UserID
struct UserID: Codable {
    let userID, firstName, lastName: String?
    let userName: String?
    let dob, emailID: String?
    let mobileVerification, emailVerification: Bool?
    let countryCode: String?
    let accountStatus: AccountStatus?
    let accountType: AccountType?
    let profession: String?
    let createdOn, updatedOn: String?
    let active: Bool?
    let country: String?
    let inValidAttempts: Int?
    let mobileNo: String?
    let registerType: String?
    let resident:String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case firstName, lastName, userName, dob
        case emailID = "emailId"
        case mobileVerification, emailVerification, countryCode, accountStatus, accountType, profession, createdOn, updatedOn, active, country, inValidAttempts, mobileNo, registerType
        case resident
    }
}

// MARK: - AccountStatus
struct AccountStatus: Codable {
    let id: Int?
    let accountStatus: String?
}

// MARK: - AccountType
struct AccountType: Codable {
    let id: Int?
    let userType: String?
}

// MARK: - Status
struct Status: Codable {
    let status: String?
    let message: String?
}


// MARK: - Welcome
struct SocialLoginResponse: Codable {
    let status: SocialLoginStatus?
   let entity: SocalEntity?
}

// MARK: - Entity
struct SocalEntity: Codable {
    let accessToken, refreshToken: String?
    let userType: Int?
    let userID, scope, tokenType: String?
    let expiresIn: Int?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case userType = "user_type"
        case userID = "user_id"
        case scope
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
// MARK: - Status
struct SocialLoginStatus: Codable {
    let status: Int?
    let message: String?
}


// MARK: - Common response

struct CommonResponse: Codable {
    let status: Int?
    let msg: String?
}
