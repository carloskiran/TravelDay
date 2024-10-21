//
//  NotificationViewModel.swift
//  OneSelf
//
//  Created by VIJAY M on 16/04/22.
//

import Foundation
import UIKit

class NotificationViewModel {
    public func getNotificationAPI(enableLoader:Bool, controller : UIViewController = UIViewController(), onSuccess success: @escaping(NotificationResponseModel?) -> Void, onFailure failure: @escaping(String) -> Void) {
        
        /// Network request object created with valid path and method
        let request = NotificationtAPIRequest(userID: UserDefaultModule.shared.getUserID() ?? "")
        if enableLoader {
            Loader.startLoading(controller.view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: NotificationResponseModel?.self) { responses in
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
    
    public func readNotificationAPI(notificationId: String, enableLoader:Bool, controller : UIViewController = UIViewController(), onSuccess success: @escaping(ReadNotificationResponseModel?) -> Void, onFailure failure: @escaping(String) -> Void) {
        var params = [String: Any]()
        params["id"] = notificationId
        /// Network request object created with valid path and method
        let request = ReadNotificationtAPIRequest(params)
        if enableLoader {
            Loader.startLoading(controller.view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: ReadNotificationResponseModel?.self) { responses in
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
