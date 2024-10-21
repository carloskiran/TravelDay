//
//  LocaitonPushServiceCall.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 13/06/23.
//

import Foundation
import UserNotifications
import Mixpanel

class LocaitonPushServiceCall: NSObject {
    
    //MARK: - Properties
    static let shared = LocaitonPushServiceCall()
    let url = "https://traveltaxdaytest.optisolbusiness.com/travelProGateway/travelProGateway/travelProTravel/updateTaxDays"
    var countryName:String = ""

    //MARK: - SendLocationPushApi
    
    /// SendLocationPush
    /// - Parameters:
    ///   - userID: String
    ///   - countryName: String
    ///   - countryCode: String
    ///   - timestamp: String
    ///   - fromCountryName: String
    ///   - fromCountryCode: String
    ///   - fromDate: String
    func sendLocationPush(userID:String,
                          countryName:String,
                          countryCode:String,
                          timestamp:String,
                          fromCountryName:String,
                          fromCountryCode:String,
                          fromDate:String,
                          handler: @escaping ((Int,String)->Void)) {
        let urlString = url
        
  
        guard let serviceUrl = URL(string: urlString) else { return }
        let parameterDictionary = ["userId" : userID,
                                   "locationCode" : countryCode,
                                   "locationName" : countryName,
                                   "currentTimeStamp" : timestamp,
                                   "fromCountryName": fromCountryName,
                                   "fromCountryCode": fromCountryCode,
                                    "fromDate": fromDate]
        self.countryName = countryName
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "PUT"
        request.cachePolicy = .reloadIgnoringCacheData
        request.timeoutInterval = 130
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Application/json", forHTTPHeaderField: "Accept")
        var token = ""
        if let userDefaults = UserDefaults(suiteName: "group.com.obs.travelpro") {
            token = userDefaults.string(forKey: "accessToken") ?? ""
        }
        request.setValue("bearer \(token)", forHTTPHeaderField: "Authorization")
        let newParms = convertDic(data: parameterDictionary)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: newParms, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { [self] (data, response, error) in
            if let response = response {
                let httpStatus = response as? HTTPURLResponse
                switch httpStatus?.statusCode {
                case 200:
                    if let data = data {
//                        NotificationCenter.default.post(name: Notification.Name("LocationDetectApiSuccess"), object: nil, userInfo: nil)
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print(json)
//                            self.scheduleLocalNotification(alert: "Current location: \(self.countryName)")
                            // set the log in mixpanel
//                            Mixpanel.mainInstance().track(event: "LocationPushService", properties: [
//                                "Source": "TravelTaxDay",
//                                ///Log state information
//                                "State": "Success",
//                                "Address": self.getConnectionAddress() ?? "-",
//                                ///Live information
//                                "Message": "Location send success - updateTaxDays API >> userid:\(userID) countryName:\(countryName) countryName:\(countryCode) timestamp:\(timestamp)",
//                                "Username": userID,
//                                ///Time zone information
//                                "Local": "L-\(self.getLocalZoneDate())",
//                                "UTC": "U-\(self.getUTCZoneDate())"
//                            ])
                            LocationPushMixPanel.shared.TravelTaxMixPanelAnalytics(message: "Location send success - updateTaxDays API >> userid:\(userID) countryName:\(countryName) countryName:\(countryCode) timestamp:\(timestamp)", userID: userID)
                            
                        } catch {
//                            Mixpanel.mainInstance().track(event: "LocationPushService", properties: [
//                                "Source": "TravelTaxDay",
//                                ///Log state information
//                                "State": "Error",
//                                "Address": self.getConnectionAddress() ?? "-",
//                                ///Live information
//                                "Message": "Location send Error - updateTaxDays API parsing error \(error)",
//                                "Username": userID,
//                                ///Time zone information
//                                "Local": "L-\(self.getLocalZoneDate())",
//                                "UTC": "U-\(self.getUTCZoneDate())"
//                            ])
                            LocationPushMixPanel.shared.TravelTaxMixPanelAnalytics(message: "Location send Error - updateTaxDays API parsing error \(error)", userID: userID)

                        }
                        handler(httpStatus?.statusCode ?? 0, "Success")
                    }
                default:
                    let response:[String: String] = ["error": error?.localizedDescription ?? ""]
//                    NotificationCenter.default.post(name: Notification.Name("LocationDetectApiFailed"), object: nil, userInfo: response)
//                    Mixpanel.mainInstance().track(event: "LocationPushService", properties: [
//                        "Source": "TravelTaxDay",
//                        ///Log state information
//                        "State": "Error",
//                        "Address": self.getConnectionAddress() ?? "-",
//                        ///Live information
//                        "Message": "Location send failed status code: \(httpStatus?.statusCode ?? 0) \(response)",
//                        "Username": userID,
//                        ///Time zone information
//                        "Local": "L-\(self.getLocalZoneDate())",
//                        "UTC": "U-\(self.getUTCZoneDate())"
//                    ])
                    LocationPushMixPanel.shared.TravelTaxMixPanelAnalytics(message: "Location send failed status code: \(httpStatus?.statusCode ?? 0) \(response)", userID: userID)

                    handler(httpStatus?.statusCode ?? 0, "/travelProTravel/updateTaxDays")
                    break
                }
            }
            
        }.resume()
        
    }
    
    func scheduleLocalNotification(alert:String) {
        let content = UNMutableNotificationContent()
        let requestIdentifier = UUID.init().uuidString
        
        content.badge = 0
        content.title = "Location Update"
        content.body = alert
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            print("Notification Register Success")
        }
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
}


