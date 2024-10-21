//
//  LocationManager.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 02/06/23.
//

import UIKit
import CoreLocation
import UserNotifications
import MapKit


protocol LocationManagerCallbackDelegate: AnyObject {
    func didReceiveLocation(for userCurrentLocation:LocationData)
}

protocol LocationManagerListRefreshCallbackDelegate: AnyObject {
    func didLocationUpdated()
}


class LocationManager: NSObject {
    
    //MARK: - Properties
    let locationManager = CLLocationManager()
    static let shared = LocationManager()
    var locationToken = String()
    var registerAPIToken = updateToken()
    weak var delegate: LocationManagerCallbackDelegate?
    weak var updateDelegate: LocationManagerListRefreshCallbackDelegate?
    
    //MARK: - Life Cycle

    private override init() { }
    
   // MARK: - Custom Methods
    func setupLocationManager() {
        TravelTaxMixPanelAnalytics(action: .locationManager, state: .info, data: MixPanelData(message: "LocationManager - setupLocationManager"))
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.distanceFilter = 200.0
        DispatchQueue.main.async {
            self.locationManager.requestAlwaysAuthorization()
        }
       
//        if authorizationStatus() == .authorizedAlways {
            startMonitoringLocationPush()
//        }
    }
    
    func startMonitoringLocationPush() {
        locationManager.startMonitoringLocationPushes { token, error in
            if let error = error {
                TravelTaxMixPanelAnalytics(action: .locationManager, state: .info, data: MixPanelData(message: "setupLocationManager - startMonitoringLocationPushes error \(error)"))
                print("errors \(error.localizedDescription)")
            }
            guard let tokenData = token else {
                return
            }
            let retrived = tokenData.map { String(format: "%02.2hhx", $0) }.joined()
            TravelTaxMixPanelAnalytics(action: .locationManager, state: .info, data: MixPanelData(message: "setupLocationManager - startMonitoringLocationPushes tokenData: \(retrived)"))
            print("&&& LOCATION TOKEN",retrived)
            self.locationToken = retrived
            if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
                appdelegate.locationToken = retrived
            }
            
            if  let userID = UserDefaultModule.shared.getUserID(), userID != "" {
                TravelTaxMixPanelAnalytics(action: .locationManager, state: .info, data: MixPanelData(message: "setupLocationManager - userID != empty, Location Toke: \(self.locationToken)"))
                DispatchQueue.main.async {
                    self.registerAPIToken.RegisterTokenAPICall(userId: userID, loctionToken: self.locationToken, isLocationToken: true) { response in
                        TravelTaxMixPanelAnalytics(action: .locationManager, state: .info, data: MixPanelData(message: "setupLocationManager - registerAPIToken:\(self.locationToken) success: \(response)"))
                    } onFailure: { error in
                        TravelTaxMixPanelAnalytics(action: .locationManager, state: .info, data: MixPanelData(message: "setupLocationManager - registerAPIToken:\(self.locationToken) error\(error)"))
                    }
                }
            }
        }
    }
    
    func checkLocationService() {
        checkLocationManagerAuthorization()
    }
    
    func startUpdateLocation() {
        locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    func stopUpdateLocation() {
        self.locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    // MARK: - Private Methods
   private func checkLocationManagerAuthorization() {
        switch authorizationStatus() {

        case .notDetermined:
            TravelTaxMixPanelAnalytics(action: .locationManager, state: .info, data: MixPanelData(message: "checkLocationManagerAuthorization - .notDetermined"))
            locationManager.requestAlwaysAuthorization()
            UserLocationSetting.sharedInstance.isLocationAccessDenied = false
            
        case .authorizedAlways:
//            let state = UIApplication.shared.applicationState
//            if state == .background || state == .active {
                TravelTaxMixPanelAnalytics(action: .locationManager, state: .info, data: MixPanelData(message: "checkLocationManagerAuthorization .authorizedAlways"))
                startUpdateLocation()
            UserLocationSetting.sharedInstance.isLocationAccessDenied = false

//            }
//            else {
//                TravelTaxMixPanelAnalytics(action: .locationManager, state: .info, data: MixPanelData(message: "checkLocationManagerAuthorization - else case"))
//                startUpdateLocation()
//            }
//            if state == .active {
//                startUpdateLocation()
//            }
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            TravelTaxMixPanelAnalytics(action: .locationManager, state: .info, data: MixPanelData(message: "checkLocationManagerAuthorization - .authorizedWhenInUse"))
//            self.scheduleLocalNotification(alert: "authorizedWhenInUse")
            startUpdateLocation()
            setupLocationAlwaysNeedPopupAlert()
            UserLocationSetting.sharedInstance.isLocationAccessDenied = false
            
        case .denied, .restricted:
            TravelTaxMixPanelAnalytics(action: .locationManager, state: .info, data: MixPanelData(message: "checkLocationManagerAuthorization - .denied, .restricted"))
            switch UserLocationSetting.sharedInstance.isLocationAccessDenied {
            case false:
                UserLocationSetting.sharedInstance.isLocationAccessDenied = true
                setupLocationPermissionPopupAlert()
           
            default:
                break
            }
       
        default:
            break
        }
    }
    
    private func authorizationStatus() -> CLAuthorizationStatus {
        var status: CLAuthorizationStatus
        status = CLLocationManager().authorizationStatus
        return status
    }
    
    private func setupLocationPermissionPopupAlert() {
        if let _ = UIApplication.topViewController()?.presentingViewController?.isKind(of: UIAlertController.self) {
            debugPrint("UIAlertController is presented")
            UIApplication.topViewController()?.dismiss(animated: true, completion: {
                if let rootVC = UIApplication.topViewController(){
                    rootVC.present(self.showPermissionNeedPopUp(), animated: true, completion: nil)
                }
            })
        } else {
            if let rootVC =  UIApplication.topViewController() {
                rootVC.present(self.showPermissionNeedPopUp(), animated: true, completion: nil)
            }
        }
    }
    
    private func setupLocationAlwaysNeedPopupAlert() {
        if let _ = UIApplication.topViewController()?.presentingViewController?.isKind(of: UIAlertController.self) {
            debugPrint("UIAlertController is presented")
            UIApplication.topViewController()?.dismiss(animated: true, completion: {
                if let rootVC = UIApplication.topViewController(){
                    rootVC.present(self.showLocationAlwaysNeedAlert(), animated: true, completion: nil)
                }
            })
        } else {
            if let rootVC =  UIApplication.topViewController() {
                rootVC.present(self.showLocationAlwaysNeedAlert(), animated: true, completion: nil)
            }
        }
    }
    
    private func showPermissionNeedPopUp() -> UIAlertController {
        
        let alert = UIAlertController(title: "Travel Tax Day",
                                      message: TextConstant.sharedInstance.kUserLocationPermission,
                                      preferredStyle: .alert)
        let Settings = UIAlertAction(title: "Go to Settings", style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true) {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                }
            }
        })
        
        let later = UIAlertAction(title: "I'll do this later", style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true) {
                UserLocationSetting.sharedInstance.isLocationAccessDenied = true
            }
        })

        alert.addAction(Settings)
        alert.addAction(later)

        return alert
    }
    
    private func showLocationAlwaysNeedAlert() -> UIAlertController {
        
        let alert = UIAlertController(title: "Travel Tax Day",
                                      message: TextConstant.sharedInstance.kAlwaysLocationNeedInfo,
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true) {
            }
        })
        
        let Settings = UIAlertAction(title: "Go to Settings", style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true) {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                }
            }
        })
        

        alert.addAction(Settings)
        alert.addAction(cancel)

        return alert
    }

}

// MARK: - Extension

extension LocationManager: CLLocationManagerDelegate {
    
    //MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationService()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationService()
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        TravelTaxMixPanelAnalytics(action: .locationManager, state: .info, data: MixPanelData(message: "didUpdateLocations - \(locations)"))
            UserLocationSetting.sharedInstance.isLocationAccessDenied = false
            self.stopUpdateLocation()
//            self.scheduleLocalNotification(alert: "didUpdateLocations")
            guard let location = locations.last else { return }
            let coordinates = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let timestamp = location.timestamp.description

            let convertDateFormat = timestamp.convertToDateFormate(current: "yyyy-MM-dd HH:mm:ss +0000", convertTo: "yyyy-MM-ddTHH:mm:ss.0000")
            let hoursMin = timestamp.convertToDateFormate(current: "yyyy-MM-dd HH:mm:ss +0000", convertTo: "HH:mm:ss.0000")
            let combineDateAndTime = convertDateFormat+"T"+hoursMin
            var userID = ""
            self.fetchCityAndCountry(location: coordinates) { city, country, code, error in
                guard let country = country,let code = code, error == nil else { return }
                if let userDefaults = UserDefaults(suiteName: "group.com.obs.travelpro") {
                    userID = userDefaults.string(forKey: "user_id") ?? ""
                }
                if let firstTime = UserDefaultModule.shared.value(forKey: "noTravelRecordUser") as? Bool, firstTime == false {
                    let locationData = LocationData(userID: userID, country: country, countryCode: code, timestamp: combineDateAndTime)
                    self.delegate?.didReceiveLocation(for: locationData)
                } else {

                    LocaitonPushServiceCall.shared.sendLocationPush(userID: userID, countryName: country, countryCode: code, timestamp: combineDateAndTime,fromCountryName: "",fromCountryCode: "",fromDate: "") { response,_ in
//                        NotificationCenter.default.post(name: Notification.Name("LocationDetectApiSuccess"), object: nil, userInfo: nil)
                        self.updateDelegate?.didLocationUpdated()
                    }
                }
            }

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
        stopUpdateLocation()
    }
    
    
}

extension LocationManager {
    
    //MARK: - FetchCityAndCountry

    func fetchCityAndCountry(location:CLLocation,completion: @escaping (_ city: String?, _ country:  String?,_ code:String?  ,_ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { completion($0?.first?.locality, $0?.first?.country,$0?.first?.isoCountryCode, $1) }
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
   
    //MARK: - SendLocationPushApi
    
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
////                success(response)
//            case .failure(let _):break
////                failure(error.description)
//            }
//        }
//    }
}


//MARK: - Struct

struct LocationData {
    var userID: String?
    var country: String?
    var countryCode: String?
    var timestamp: String?
    var fromCountryName: String?
    var fromCountryCode: String?
    var fromDate: String?
}

