//
//  PhoneModel.swift
//  TravelPro
//
//  Created by Mac-OBS-32 on 25/04/23.
//

import Foundation

// MARK: - Welcome
struct CountryModel: Codable {
    let status: CountryModelStatus
    let entity: [CountryModelEntity]
}

// MARK: - Entity
struct CountryModelEntity: Codable {
    let id: Int
    let countryCode, countryCodeThreeLetter, countryDialCode, countryName: String
    let active: Bool
    let nationality, countryCurrency: String
}

// MARK: - Status
struct CountryModelStatus: Codable {
    let status: Int
    let message: String
}

struct registerData  {
    var firstName  = ""
    var lastName = ""
    var email = ""
    var countryCode = ""
    var mobileNumber = ""
}
 
struct RegisterResponse: Codable {
    let status: RegisterStatus?
    let entity: RegisterStatusEntity?
}

// MARK: - Entity
struct RegisterStatusEntity: Codable {
    let userID, firstName, lastName, userName: String?
    let dob, emailID: String?
    let mobileVerification, emailVerification: Bool?
    let accountStatus:  RegisterAccountStatus?
    let accountType:  RegisterAccountType?
    let profession, createdOn, updatedOn: String?
    let active: Bool?
    let country: String?
    let inValidAttempts: Int?
    let mobileNo, registerType: String?
    let resident:String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case firstName, lastName, userName, dob
        case emailID = "emailId"
        case mobileVerification, emailVerification, accountStatus, accountType, profession, createdOn, updatedOn, active, country, inValidAttempts, mobileNo, registerType
        case resident
    }
}

// MARK: - AccountStatus
struct  RegisterAccountStatus: Codable {
    let id: Int?
    let accountStatus: String?
}

// MARK: - AccountType
struct RegisterAccountType: Codable {
    let id: Int?
    let userType: String?
}

// MARK: - Status
struct RegisterStatus: Codable {
    let status: Int?
    let message: String?
}
