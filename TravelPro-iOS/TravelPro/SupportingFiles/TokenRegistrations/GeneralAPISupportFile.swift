//
//  GeneralAPISupportFile.swift
//  TravelPro
//
//  Created by VIJAY M on 08/06/23.
//

import Foundation
import Alamofire

class updateToken {
    func RegisterTokenAPICall(userId:String = "",
                            token:String = "",
                            type:String = "IOS",
                            loctionToken: String = "",
                            isLocationToken: Bool = false,
                            onSuccess success: @escaping (RegisterTokenModel) -> Void,
                            onFailure failure: @escaping (String) -> Void) {
        
//        var params:[String : Any] = ["token" : token, "type" : type]
        let params:[String : Any] = ["token" : token, "type" : type, "userId": userId, "locationToken": loctionToken]
        
//        if isLocationToken {
//            params.removeValue(forKey: "token")
//            params.updateValue(userId, forKey: "userId")
//            params.updateValue(loctionToken, forKey: "locationToken")
//        }
        
        TravelTaxMixPanelAnalytics(action: .locationManager, state: .info, data: MixPanelData(message: "setupLocationManager - registerAPIToken params \(params)"))

        let request = RegisterTokenAPIRequest(params)
        if let baseURL = request.baseURL {
            print("RegisterTokenAPIRequest URL: \(baseURL)")
        }
        print("RegisterTokenAPIRequest params: \(params)")
        
        TTDNetworkManager.execute(request: request, responseType: RegisterTokenModel.self) { responses in
            switch responses {
            case .success(let response):
                success(response)
            case .failure(let error):
                failure(error.description)
            }
        }
    }
    
}
