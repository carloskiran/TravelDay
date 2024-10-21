//
//  ExportViewModel.swift
//  TravelPro
//
//  Created by MAC-OBS-31 on 10/06/23.
//

import Foundation

import UIKit
import Alamofire

class ExportViewModel {


    func exportEmailAndDownload(countryId:String = "",
                              year:String = "",
                              exportType:String = "",
                              email:String = "",
                              fileType: String = "",
                              controller : UIViewController = UIViewController() ,
                              enableLoader:Bool = false ,
                              onSuccess success: @escaping (CommonResponse) -> Void,
                              onFailure failure: @escaping (String) -> Void) {

//        let params = ["countryId": countryId!,"year":year] as [String : Any]
//
//        let request = DownloadCSVAPIRequest(params)

        let request = DownloadCSVAPIRequest(countryId: countryId, year: year,exportType: exportType,fileType: fileType,email: email)


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

    
    func SendReportAPI(countryId:String = "",
                              year:String = "",email:String = "",
                              controller : UIViewController = UIViewController() ,
                              enableLoader:Bool = false ,
                              onSuccess success: @escaping (ExportStatusModel) -> Void,
                              onFailure failure: @escaping (String) -> Void) {


        let request = SendReportAPIRequest(countryId: countryId, year: year,email: email)


        if enableLoader {
            Loader.startLoading(controller.view,userIneration: false)
        }
        TTDNetworkManager.execute(request: request, responseType: ExportStatusModel.self) { responses in
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


