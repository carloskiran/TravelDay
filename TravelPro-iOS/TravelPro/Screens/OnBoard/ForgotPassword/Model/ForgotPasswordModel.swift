//
//  ForgotPasswordModel.swift
//  TravelPro
//
//  Created by VIJAY M on 26/04/23.
//

import Foundation
// MARK: - Welcome
struct GenerateOTPModel: Codable {
    let status: OTPStatus?
    let entity: OTPEntity?
}

// MARK: - Entity
struct OTPEntity: Codable {
    let emailOtp, mobileOtp: String?
}

// MARK: - Status
struct OTPStatus: Codable {
    let status: Int?
    let message: String?
}

// MARK: - Welcome
struct ValidateOTPModel: Codable {
    let status: ValidateOTPStatus?
    let entity: String?
}

// MARK: - Status
struct ValidateOTPStatus: Codable {
    let status: Int?
    let message: String?
}

// MARK: - New User OTP Model
struct NewUserOTPModel: Codable {
    let status: OTPStatus?
    let entity: NewOTPEntity?
}

struct NewOTPEntity: Codable {
    let verifiedStatus: Bool?
}
