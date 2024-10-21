//
//  MixPanelSupportFile.swift
//  TravelPro
//
//  Created by VIJAY M on 11/06/23.
//

import Foundation
import Mixpanel

/// FTVAnalytics
/// - Parameters:
///   - pageName: String
///   - eventName: String
public func TravelTaxMixPanelAnalytics(action: mixpanel_action, state: MixPanelState, data: MixPanelData?) {
    
    let localZone = "L-\(TravelTaxDayManager.shared.getLocalZoneDate())"
    let utcZone = "U-\(TravelTaxDayManager.shared.getUTCZoneDate())"
    let userConnectionAddress = getConnectionAddress() ?? "-"
    let mixpan = Mixpanel.mainInstance()
    switch action {
    case .live:
        mixpan.track(event: action.rawValue, properties: [
            "Source": "TravelTaxDay",
            
            ///Log state information
            "State": state.rawValue,
            "Address": userConnectionAddress,
            
            ///Live information
            "Message": data?.message ?? "",
            "Username": "UserName: \( UserDefaultModule.shared.getUserName() ?? "") UserID: \(UserDefaultModule.shared.getUserID() ?? "")",  
            
            ///Time zone information
            "Local": localZone,
            "UTC": utcZone
        ])
    case .fanBeTheHost:
        
        mixpan.track(event: action.rawValue, properties: [
            "Source": "TravelTaxDay",
            
            ///Log state information
            "State": state.rawValue,
            "Address": userConnectionAddress,
            
            ///Fan be the Host information

            
            "Message": data?.message ?? "",
            "Username": UserDefaultModule.shared.getUserID() ?? "",
            
            ///Time zone information
            "Local": localZone,
            "UTC": utcZone
        ])
        
    default:
        mixpan.track(event: action.rawValue, properties: [
            
            "Source": "TravelTaxDay",
            
            ///Log state information
            "State": state.rawValue,
            "Address": userConnectionAddress,
            
            "Message": data?.message ?? "",
            "Username": UserDefaultModule.shared.getUserID() ?? "",
            
            ///Time zone information
            "Local": localZone,
            "UTC": utcZone
        ])
        
    }
    
}

/// Get User IP Address Value
/// - Returns: String
public func getConnectionAddress() -> String? {
    
    var address: String?
    var ifaddr: UnsafeMutablePointer<ifaddrs>?
    if getifaddrs(&ifaddr) == 0 {
        var ptr = ifaddr
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }
            let interface = ptr?.pointee
            let addrFamily = interface?.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6),
                 let cString = interface?.ifa_name,
                 String(cString: cString) == "en0",
                 let saLen = (interface?.ifa_addr.pointee.sa_len) {
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                let ifaAddr = interface?.ifa_addr
                getnameinfo(ifaAddr, socklen_t(saLen), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                address = String(cString: hostname)
            }
        }
        freeifaddrs(ifaddr)
    }
    return address
    
}
