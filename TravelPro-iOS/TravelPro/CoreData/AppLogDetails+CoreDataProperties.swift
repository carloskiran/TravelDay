//
//  AppLogDetails+CoreDataProperties.swift
//  TravelPro
//
//  Created by Mac-OBS-32 on 08/05/23.
//
//

import Foundation
import CoreData


extension AppLogDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppLogDetails> {
        return NSFetchRequest<AppLogDetails>(entityName: "AppLogDetails")
    }

    @NSManaged public var appleEmail: String?
    @NSManaged public var appleFname: String?
    @NSManaged public var appleId: String?
    @NSManaged public var appleLname: String?

}

extension AppLogDetails : Identifiable {

}
