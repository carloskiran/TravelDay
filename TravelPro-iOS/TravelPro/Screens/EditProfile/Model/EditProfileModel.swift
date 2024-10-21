//
//  EditProfileModel.swift
//  TravelPro
//
//  Created by VIJAY M on 29/04/23.
//

import Foundation

// MARK: - Welcome
struct EditProfileResponseDetails: Codable {
    let status: EditProfileStatus?
    let entity: EditProfileEntity?
}

// MARK: - Entity
struct EditProfileEntity: Codable {
    let id: String?
    let userID: EditProfileUserID?
    let currrentCountry, taxableDays, definitionOfDay, profileImage: String?
    let document, resident, createdOn, updatedOn: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case currrentCountry, taxableDays, definitionOfDay, profileImage, document, resident, createdOn, updatedOn
    }
}

// MARK: - UserID
struct EditProfileUserID: Codable {
    let userID, firstName, lastName, userName: String?
    let dob, emailID: String?
    let mobileVerification, emailVerification: Bool?
    let countryCode: String?
    let accountStatus: EditProfileAccountStatus?
    let accountType: EditProfileAccountType?
    let profession, createdOn, updatedOn: String?
    let active: Bool?
    let country: String?
    let inValidAttempts: Int?
    let mobileNo, registerType: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case firstName, lastName, userName, dob
        case emailID = "emailId"
        case mobileVerification, emailVerification, countryCode, accountStatus, accountType, profession, createdOn, updatedOn, active, country, inValidAttempts, mobileNo, registerType
    }
}

// MARK: - AccountStatus
struct EditProfileAccountStatus: Codable {
    let id: Int?
    let accountStatus: String?
}

// MARK: - AccountType
struct EditProfileAccountType: Codable {
    let id: Int?
    let userType: String?
}

// MARK: - Status
struct EditProfileStatus: Codable {
    let status: Int?
    let message: String?
}
