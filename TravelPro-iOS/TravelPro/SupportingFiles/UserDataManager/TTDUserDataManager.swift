//
//  TTDUserDataManager.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 19/04/23.
//

import Foundation
import CoreData
import UIKit

public class TTDUserDataManager {
    
    // MARK: - Properties
    static var shared = TTDUserDataManager()
    var connectedUser: TTDUser?
    
    // MARK: - Init
    init() {
        self.connectedUser = TTDUser.fetchConnectedUser()
    }
    
    /// UpdateUserLoginDetails
    /// - Parameter userData: loginDetailsResponse
    func updateUserLoginDetails(userData: LoginDetailsResponse) {
        guard let phoneNumber = userData.profile?.userID?.mobileNo else {
            return
        }
        
        let TTDUser = TTDUser.fetchRequest(for: phoneNumber)
        TTDUser.isConnected = true
        TTDUser.access_token = userData.accessToken
//        TTDUser.active = userData.profile?.userId?.active ?? false
//        TTDUser.country = userData.profile?.userId?.country
//        TTDUser.currrentCountry = userData.profile?.currrentCountry
//        TTDUser.dob = userData.profile?.userId?.dob
//        TTDUser.emailId = userData.profile?.userId?.emailId
//        TTDUser.emailVerification = userData.profile?.userId?.emailVerification
//        TTDUser.expires_in =  Int16(userData.expires_in ?? 0)
//        TTDUser.firstName = userData.profile?.userId?.firstName
//        TTDUser.id = userData.profile?.id
//        TTDUser.lastName = userData.profile?.userId?.lastName
//        TTDUser.mobileNo = userData.profile?.userId?.mobileNo
//        TTDUser.mobileVerification = userData.profile?.userId?.mobileVerification
//        TTDUser.refresh_token = userData.refresh_token
//        TTDUser.registerType = userData.profile?.userId?.registerType
//        TTDUser.resident = userData.profile?.userId?.resident
//        TTDUser.scope = userData.scope
//        TTDUser.taxableDays = userData.profile?.taxableDays
//        TTDUser.token_type = userData.token_type
//        TTDUser.userId = userData.user_id
//        TTDUser.user_type = Int16(userData.user_type ?? 0)
//        TTDUser.userId = userData.profile?.userId?.userId
        
        
        if let profileImageURL = userData.profile?.profileImage {
//            let finalURL = String(format: "%@%@", ServerAPIURL.profileImageURL, profileImageURL)
            TTDUser.profileImage = profileImageURL
        }
        self.connectedUser = TTDUser
        CoreDataStack.shared.saveContexts()
    }
    
    /// Logout
    func logout() {
        if let connectedUser = TTDUserDataManager.shared.connectedUser  {
            connectedUser.isConnected = false
            connectedUser.access_token = nil
            let viewContext = CoreDataStack.shared.viewContext
            viewContext.delete(connectedUser)
            CoreDataStack.shared.saveContexts()
        }
        self.connectedUser = nil
        CoreDataStack.shared.saveContexts()
    }
}

extension TTDUser {
    
    /// FetchRequest
    /// - Parameter itemID: itemID
    /// - Returns: TTDUser
    class func fetchRequest(for itemID: String) -> TTDUser {
        let viewContext = CoreDataStack.shared.viewContext
        let request = TTDUser.fetchRequest() as NSFetchRequest
        let predicate = NSPredicate(format: "%K = %@", "mobileNo", itemID)
        request.predicate = predicate
        request.fetchLimit = 1
        if let fetchResults = try? viewContext.fetch(request) {
            if fetchResults.isEmpty {
                guard let user = NSEntityDescription.insertNewObject(forEntityName: TTDUser.entityName(), into: viewContext) as? TTDUser else {
                    return TTDUser()
                }
                user.mobileNo = itemID
                return user
            } else {
                return fetchResults.first!
            }
        } else {
            return TTDUser()
        }
    }
    
    /// FetchConnectedUser
    /// - Returns: TTDUser
    class func fetchConnectedUser() -> TTDUser? {
        let viewContext = CoreDataStack.shared.viewContext
        let request = TTDUser.fetchRequest() as NSFetchRequest
        let itemIDPredicate = NSPredicate(format: "%K == 1", NSStringFromSelector(#selector(getter: self.isConnected)))
        request.predicate = itemIDPredicate
        request.fetchLimit = 1
        guard let fetchResults = try? viewContext.fetch(request) else {
            return nil
        }
        if fetchResults.isEmpty {
            return nil
        } else {
            return fetchResults.first!
        }
    }
    
}
