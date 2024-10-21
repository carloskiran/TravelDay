//
//  LocationPushMixPanel.swift
//  TravelPro
//
//  Created by MAC-OBS-48 on 30/09/23.
//

import Foundation
import Mixpanel

class LocationPushMixPanel: NSObject {
   
    static let shared = LocationPushMixPanel()
    
     func TravelTaxMixPanelAnalytics(message:String,userID:String) {
        
        Mixpanel.mainInstance().track(event: "LocationPushService", properties: [
            "Source": "TravelTaxDay",
            ///Log state information
            "State": "Success",
            "Address": self.getConnectionAddress() ?? "-",
            ///Live information
            "Message": message,
            "Username": userID,
            ///Time zone information
            "Local": "L-\(self.getLocalZoneDate())",
            "UTC": "U-\(self.getUTCZoneDate())"
        ])
        
    }

    private func getUTCZoneDate() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: Date())
    }

    private func getLocalZoneDate() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: Date())
    }

    private func convertDic(data: [String: Any]) -> NSMutableDictionary {
        let newParms = NSMutableDictionary()
        for item in data {
            let key = item.key
            let value = item.value
            newParms.setValue(value, forKey: key)
        }
        return newParms
    }

    private func getConnectionAddress() -> String? {
        
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
}

