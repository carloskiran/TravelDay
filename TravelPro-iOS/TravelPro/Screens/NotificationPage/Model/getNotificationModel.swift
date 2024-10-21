//
//  getNotificationModel.swift
//  OneSelf
//
//  Created by VIJAY M on 16/04/22.
//

import Foundation

// MARK: - NotificationResponseModel
struct NotificationResponseModel: Codable {
    let status: NotificationStatus
    let entity: [NotificationEntity]
    let message: Bool
}

// MARK: - Entity
struct NotificationEntity: Codable {
    let id, notificationTitle: String
    let active: Bool
    let resident, sendTo, description: String
    let receiverID, status, createdDate: String
    var read: Bool

    enum CodingKeys: String, CodingKey {
        case id, notificationTitle, active, resident, sendTo, description, createdDate
        case receiverID = "receiverId"
        case status, read
    }
}

// MARK: - Status
struct NotificationStatus: Codable {
    let status: Int
    let msg: String
}

// MARK: - ReadNotificationResponseModel
struct ReadNotificationResponseModel: Codable {
    let status: ReadNotificationStatus
    let entity: ReadNotificationEntity
}

// MARK: - Entity
struct ReadNotificationEntity: Codable {
    let id, notificationTitle: String
    let active: Bool
    let resident, sendTo, description, notifilicationDateAndTime: String
    let receiverID, status: String
    let read: Bool

    enum CodingKeys: String, CodingKey {
        case id, notificationTitle, active, resident, sendTo, description, notifilicationDateAndTime
        case receiverID = "receiverId"
        case status, read
    }
}

// MARK: - Status
struct ReadNotificationStatus: Codable {
    let status: Int
    let msg: String
}
