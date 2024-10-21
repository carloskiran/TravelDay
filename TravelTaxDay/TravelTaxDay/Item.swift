//
//  Item.swift
//  TravelTaxDay
//
//  Created by Carlos Kiran Subramanian Vidal on 1/7/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
