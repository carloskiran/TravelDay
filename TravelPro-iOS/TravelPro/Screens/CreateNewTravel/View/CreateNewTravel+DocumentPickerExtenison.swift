//
//  CreateNewTravel+DocumentPickerExtenison.swift
//  TravelPro
//
//  Created by MAC-OBS-48 on 11/09/23.
//

import Foundation
import UIKit
import AWSCore
import AWSS3


extension CreateNewTravelViewController: UIDocumentPickerDelegate {
    //MARK: - UIDocumentPickerDelegate

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - UIDocumentPickerDelegate - documentPicker"))
        for urlItem in urls {
            switch selectedDocumentCategory {
            case .TravelAndHotel:
                let details = self.travelAndHotelArray.filter { $0.value != URL(fileURLWithPath: "") }
                print("details count TravelAndHotel: \(details)")
                if details.count < 4 {
                    isTravelAndHotelEnable = true
                    self.travelApiCallingEnable.updateValue("start", forKey: "\(details.count)")
                    self.travelAndHotelArray.updateValue(urlItem, forKey: "\(details.count)")
                } else {
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: "Travel And Hotel", body: "You have already reached the maximum count of upload documents", image: UIImage(named: "Notification") ?? nil,theme: .custom)
                }
            case .FoodAndEntertainment:
                let details = self.foodAndEntertainment.filter { $0.value != URL(fileURLWithPath: "") }
                print("details count FoodAndEntertainment: \(details)")
                if details.count < 4 {
                    isFoodAndEntertainmentEnable = true
                    self.foodApiCallingEnable.updateValue("start", forKey: "\(details.count)")
                    self.foodAndEntertainment.updateValue(urlItem, forKey: "\(details.count)")
                } else {
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: "Food And Entertainment", body: "You've already reached the maximum count of upload documents", image: UIImage(named: "Notification") ?? nil,theme: .custom)
                }
            case .ShoppingAndUtility:
                let details = self.shoppingAndUtility.filter { $0.value != URL(fileURLWithPath: "") }
                print("details count ShoppingAndUtility: \(details)")
                if details.count < 4 {
                    isShoppingAndUntilityEnable = true
                    self.shoppingApiCallingEnable.updateValue("start", forKey: "\(details.count)")
                    self.shoppingAndUtility.updateValue(urlItem, forKey: "\(details.count)")
                } else {
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: "Shopping And Utility", body: "You've already reached the maximum count of upload documents", image: UIImage(named: "Notification") ?? nil,theme: .custom)
                }
            case .Others:
                let details = self.others.filter { $0.value != URL(fileURLWithPath: "") }
                print("details count Others: \(details)")
                if details.count < 4 {
                    isOtherEnable = true
                    self.othersApiCallingEnable.updateValue("start", forKey: "\(details.count)")
                    self.others.updateValue(urlItem, forKey: "\(details.count)")
                } else {
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: "Others", body: "You've already reached the maximum count of upload documents", image: UIImage(named: "Notification") ?? nil,theme: .custom)
                }
            case .none:
                let details = self.pickedImageDictionary.filter { $0.value != URL(fileURLWithPath: "") }
                print("details count none: \(details)")
                if details.count < 4 {
                    self.apiCallingEnableOrDisable.updateValue("start", forKey: "\(details.count)")
                    self.pickedImageDictionary.updateValue(urlItem, forKey: "\(details.count)")
                } else {
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: "Others", body: "You've already reached the maximum count of upload documents", image: UIImage(named: "Notification") ?? nil,theme: .custom)
                }
            }
            self.tableView.reloadData()
            setTableviewDynamicHeight()
            //            }
        }
        self.dismiss(animated: true)
    }
    
    
    
    func uploadFile(with resource: String, type: String, documentURL: String) {   //1
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - uploadFile"))
        let key = "\(resource).\(type)"
        
        //6
        let transferFile = AWSS3TransferUtility.default()
        let fileURL = URL(fileURLWithPath: documentURL)
        let bucketName = AWSConfig.kIMAGEBUCKET  //3
        
        var contentType = "" // default content type
        
        switch type {
        case "xlsx":
            contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        case "xls":
            contentType = "application/vnd.ms-excel"
        case "numbers":
            contentType = "application/vnd.apple.numbers"
        case "docx":
            contentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case "doc":
            contentType = "application/msword"
        case "pdf":
            contentType = "application/pdf"
        default:
            break
        }
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = { (task, progress) in
            DispatchQueue.main.async {
                let percent = Int(progress.fractionCompleted * 100)
                print("Upload progress: \(percent)%")
            }
        }
        let uploadTask = transferFile.uploadFile(fileURL, bucket: bucketName, key: key, contentType: contentType, expression: expression, completionHandler: { task, error in
            if let error = error {
                TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - uploadFile - failure response"))
                print("Error uploading file: \(error.localizedDescription)")
            } else {
                TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - uploadFile - success response"))
                print("File uploaded successfully.")
            }
        })
        print(uploadTask.description)
        
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
}
