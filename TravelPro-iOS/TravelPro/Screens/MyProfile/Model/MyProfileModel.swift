//
//  MyProfileModel.swift
//  TravelPro
//
//  Created by Mac-OBS-32 on 28/04/23.
//


import Foundation
// MARK: - Welcome
struct ViewProfileModel: Codable {
    let status: ViewProfileStatus?
    let entity: ViewProfileEntity?
}

// MARK: - Entity
struct ViewProfileEntity: Codable {
    let id: String?
    let userID: ViewProfileUserID?
    let currrentCountry, taxableDays, definitionOfDay, profileImage: String?
    let document, createdOn, resident,dob,updatedOn: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case currrentCountry, taxableDays, definitionOfDay, profileImage, document, createdOn, updatedOn,resident,dob
    }
}

// MARK: - UserID
struct ViewProfileUserID: Codable {
    let userID, firstName, lastName, userName: String?
    let dob, emailID: String?
    let mobileVerification, emailVerification: Bool?
    let countryCode: String?
    let accountStatus: ViewProfileAccountStatus?
    let accountType: ViewProfileAccountType?
    let profession, createdOn, updatedOn: String?
    let active,socialAccount: Bool?
    let country: String?
    let inValidAttempts: Int?
    let mobileNo,gender, registerType: String?
    let resident:String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case firstName, lastName, userName, dob
        case emailID = "emailId"
        case mobileVerification, emailVerification, countryCode, accountStatus, accountType, profession, createdOn, updatedOn, active, country, inValidAttempts, mobileNo, registerType,gender,socialAccount
        case resident
    }
}

// MARK: - AccountStatus
struct ViewProfileAccountStatus: Codable {
    let id: Int?
    let accountStatus: String?
}

// MARK: - AccountType
struct ViewProfileAccountType: Codable {
    let id: Int?
    let userType: String?
}

// MARK: - Status
struct ViewProfileStatus: Codable {
    let status: Int?
    let message: String?
}
