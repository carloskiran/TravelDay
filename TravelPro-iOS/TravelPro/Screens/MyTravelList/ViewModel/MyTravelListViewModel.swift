//
//  MyTravelListViewModel.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 19/05/23.
//

import Foundation
import UIKit


class MyTravelListViewModel {
    
    /// MyTravelList
    /// - Parameters:
    ///   - userID: String
    ///   - type: String
    ///   - enableLoader: Bool
    ///   - controller: UIViewController
    ///   - success: MyTravelListModel
    ///   - failure: String
    func myTravelList(userID: String, type: String, enableLoader: Bool, controller: UIViewController = UIViewController(), onSuccess success: @escaping (MyTravelListModel) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let request = getMyTravelListAPIRequest(userID: userID, type: type)
        if enableLoader {
            Loader.startLoading(controller.view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: MyTravelListModel.self) { responses in
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
    
    func filterTravelList(userID:String, taxStartYear: String, taxEndYear: String, country: String, enableLoader:Bool, controller : UIViewController = UIViewController(), onSuccess success: @escaping (FilterResponseModel) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let request = getSearchRecordsAPIRequest(userID: userID, taxStartYear: taxStartYear, taxEndYear: taxEndYear, country: country)
        if let baseURL = request.baseURL, let params = request.parameter {
            print("filterTravelList URL \(baseURL.absoluteString)")
            print("filterTravelList Params \(params)")
        }
        if enableLoader {
            Loader.startLoading(controller.view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: FilterResponseModel.self) { responses in
            if enableLoader {
                Loader.stopLoading(controller.view)
            }
            switch responses {
            case .success(let response):
                print(response)
                success(response)
            case .failure(let error):
                failure(error.description)
            }
        }
    }
    
    func getNewCheckUserAPI(enableLoader:Bool, controller : UIViewController = UIViewController(), onSuccess success: @escaping(NewUserCheckResponse) -> Void, onFailure failure: @escaping(String) -> Void) {
       
       /// Network request object created with valid path and method
       let request = NewUserCheckAPIRequest()
       if enableLoader {
           Loader.startLoading(controller.view,userIneration: false)
       }
       TTDNetworkManager.execute(request: request, responseType: NewUserCheckResponse.self) { responses in
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
