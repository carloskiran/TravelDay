//
//  CreateMissingTravelViewMmodel.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 06/06/23.
//

import Foundation
import UIKit


class CreateMissingTravelViewMmodel {
    
    /// AddMissingTravelRecord
    /// - Parameters:
    ///   - origin: String
    ///   - destination: String
    ///   - startDate: String
    ///   - endDate: String
    ///   - enableLoader: Bool
    ///   - controller: UIViewController
    ///   - success: CommonResponse
    ///   - failure: String
    func addMissingTravelRecord(origin:Int = 0,
                            destination:Int = 0,
                            startDate: String = "",
                                endDate: String = "", taxStartYear: String = "", taxEndYear: String = "", nonWorkDays: [String] = [""],
                            enableLoader:Bool = false ,
                            controller : UIViewController = UIViewController() ,
                            onSuccess success: @escaping (CreateTravelModel) -> Void,
                            onFailure failure: @escaping (String) -> Void) {
        let params:[String : Any] = [
            "origin": origin,
            "destination" : destination,
            "startDate" : startDate,
            "endDate" : endDate,
            "nonWorkDays" : nonWorkDays,
            "taxStartYear": taxStartYear,
            "taxEndYear": taxEndYear
        ]
        print("missing travel : \(params)")
        let request = AddMissingTravelAPIRequest(params)
        if enableLoader {
            Loader.startLoading(controller.view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: CreateTravelModel.self) { responses in
            if enableLoader {
                Loader.stopLoading(controller.view)
            }
            switch responses {
            case .success(let response):
                success(response)
            case .failure(let error):
                failure(error.description)
            }
        }
    }
    
}
