//
//  LocationPushService.swift
//  locationpush
//
//  Created by MAC-OBS-25 on 06/06/23.
//

import CoreLocation
import OSLog
import os
import UserNotifications
import Mixpanel

class LocationPushService: NSObject, CLLocationPushServiceExtension, CLLocationManagerDelegate {

    var completion: (() -> Void)?
    var locationManager: CLLocationManager?
    var userIdFromAppGroup:String = ""

    func didReceiveLocationPushPayload(_ payload: [String : Any], completion: @escaping () -> Void) {
        os_log(">>>> didReceiveLocationPushPayload", log: .debug, type: .default)
//        if let userDefaults = UserDefaults(suiteName: "group.com.obs.travelpro") {
//            var userid = userDefaults.string(forKey: "user_id") ?? ""
////            LocationPushMixPanel.shared.TravelTaxMixPanelAnalytics(message: "didReceiveLocationPushPayload >>>", userID: userid)
//        }
//        Mixpanel.mainInstance().track(event: "LocationPushService", properties: [
//            "Source": "TravelTaxDay",
//            ///Log state information
//            "State": "Success",
//            ///Live information
//            "Message": "didReceiveLocationPushPayload >>>",
//            "Username": userid
//        ])

        if let userDefaults = UserDefaults(suiteName: "group.com.obs.travelpro") {
            if userDefaults.string(forKey: "accessToken") != nil {
//                self.scheduleLocalNotification(alert: "didReceiveLocationPushPayload")
                self.completion = completion
                self.locationManager = CLLocationManager()
                self.locationManager!.delegate = self
                self.locationManager!.requestLocation()
                //var userid = ""
//                if let userDefaults = UserDefaults(suiteName: "group.com.obs.travelpro") {
//                    userid = userDefaults.string(forKey: "user_id") ?? ""
//                }
               /* DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    Mixpanel.mainInstance().track(event: "LocationPushService", properties: [
                        "Source": "TravelTaxDay",
                        ///Log state information
                        "State": "Success",
                        ///Live information
                        "Message": "didReceiveLocationPushPayload >>>",
                        "Username": userid
                    ])
                }*/
            }
        } else {
            os_log(">>>> didReceiveLocationPushPayload -- else part executed", log: .debug, type: .default)
        }

    }
    
    func serviceExtensionWillTerminate() {
        os_log(">>>> serviceExtensionWillTerminate", log: .debug, type: .default)
        // Called just before the extension will be terminated by the system.
        self.completion?()
    }

    // MARK: - CLLocationManagerDelegate methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        os_log(">>>> didUpdateLocations", log: .debug, type: .default)
//        self.scheduleLocalNotification(alert: ">>>> didUpdateLocations")
        guard let location = locations.last else { return }
        let coordinates = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let timestamp = location.timestamp.description
        let convertDate = timestamp.convertDateFormat(current: "yyyy-MM-dd HH:mm:ss +0000", convertTo: "yyyy-MM-dd'T'HH:mm:ss.0000")
        self.fetchCityAndCountry(location: coordinates) { city, country, code, error in
            guard let country = country,let code = code, error == nil else { return }
            if let userDefaults = UserDefaults(suiteName: "group.com.obs.travelpro") {
                self.userIdFromAppGroup = userDefaults.string(forKey: "user_id") ?? ""
            }
            LocaitonPushServiceCall.shared.sendLocationPush(userID: self.userIdFromAppGroup, countryName: country, countryCode: code, timestamp: convertDate,fromCountryName: "",fromCountryCode: "",fromDate: "") { response,_ in }
        }
           
        self.completion?()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        os_log(">>>> didFailWithError", log: .debug, type: .default)
        self.completion?()
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
    
    //MARK: - FetchCityAndCountry

    func fetchCityAndCountry(location:CLLocation,completion: @escaping (_ city: String?, _ country:  String?,_ code:String?  ,_ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { completion($0?.first?.locality, $0?.first?.country,$0?.first?.isoCountryCode, $1) }
    }
    
//    //MARK: - SendLocationPushApi
//    
//    func sendLocationPushApi(countryName:String,countryCode:String,timestamp:String) {
//        let userID = UserDefaultModule.shared.getUserID()
//        let params:[String: Any] = [
//            "userId": userID ?? "",
//            "contryName": countryName,
//            "countryCode" : countryCode,
//            "timestamp" : timestamp
//        ]
//        
//        let request = SendLocationPushAPIRequest(params)
//        TTDNetworkManager.execute(request: request, responseType: CommonStatusResponse.self) { responses in
//            switch responses {
//            case .success(let _):break
//                //                success(response)
//            case .failure(let _):break
//                //                failure(error.description)
//            }
//        }
//    }

}

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let debug = OSLog(subsystem: subsystem, category: "debug")
}

extension String {
   
    func convertDateFormat(current: String, convertTo: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = current
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        dateFormatter.dateFormat = convertTo
        return  dateFormatter.string(from: date)
    }
}
