//
//  MyTravekDetailViewModel.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 24/05/23.
//

import Foundation
import UIKit

class MyTravelDetailViewModel {
    
    /// DeleteTravel
    /// - Parameters:
    ///   - userID: String
    ///   - travelID: String
    ///   - enableLoader: Bool
    ///   - controller: UIViewController
    ///   - success: CommonResponse
    ///   - failure: String
    func deleteTravel(userID:String,travelID:String,enableLoader:Bool,controller : UIViewController = UIViewController() ,onSuccess success: @escaping (CommonResponse) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let request = DeleteTravelListAPIRequest(userID: userID,travelId: travelID)
        if enableLoader {
            Loader.startLoading(controller.view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: CommonResponse.self) { responses in
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
    
    /// TravelDetail
    /// - Parameters:
    ///   - userID: String
    ///   - travelID: String
    ///   - enableLoader: Bool
    ///   - controller: UIViewController
    ///   - success: TravelDetailModel
    ///   - failure: String
    func travelDetail(userID:String,travelID:String,enableLoader:Bool,controller : UIViewController = UIViewController() ,onSuccess success: @escaping (TravelDetailModel) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let request = TravelDetailAPIRequest(userID: userID,travelId: travelID)
        if enableLoader {
            Loader.startLoading(controller.view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: TravelDetailModel.self) { responses in
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
    
    /// TravelDetail
    /// - Parameters:
    ///   - userID: String
    ///   - travelID: String
    ///   - enableLoader: Bool
    ///   - controller: UIViewController
    ///   - success: TravelDetailModel
    ///   - failure: String
    func travelInfoAPI(travelID:String,enableLoader:Bool,controller : UIViewController = UIViewController() ,onSuccess success: @escaping (TravelSummaryResponse) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let request = TravelSummaryAPIRequest(travelId: travelID)
        if enableLoader {
            Loader.startLoading(controller.view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: TravelSummaryResponse.self) { responses in
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
