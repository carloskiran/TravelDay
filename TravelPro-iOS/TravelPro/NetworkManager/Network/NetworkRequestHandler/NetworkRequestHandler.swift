//
//  NetworkRequestHandler.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 18/04/23.
//

import Foundation


// MARK: - Login

final class LoginAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any]) {
        super.init(.post, authorizationRequirement: .never)
        path = ServerOnboardEndpoint.login_api
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            parameterData = jsonData
        }
    }
}

final class EmailAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any]) {
        super.init(.post, authorizationRequirement: .never)
        path = ServerOnboardEndpoint.emailcheck_api
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            parameterData = jsonData
        }
    }
}

final class MobileAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any]) {
        super.init(.post, authorizationRequirement: .never)
        path = ServerOnboardEndpoint.mobilecheck_api
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            parameterData = jsonData
        }
    }
}

final class ForgotPasswordAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any]) {
        super.init(.post, authorizationRequirement: .never)
        path = ServerEndpoint.forgotpassword_api
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            parameterData = jsonData
        }
    }
}

final class GenerateOTPAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any]) {
        super.init(.post, authorizationRequirement: .required)
        path = ServerEndpoint.generateotp_api
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            parameterData = jsonData
        }
    }
}

final class CreatePasswordAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any]) {
        super.init(.post, authorizationRequirement: .never)
        path = ServerEndpoint.createpassword_api
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            parameterData = jsonData
        }
    }
}

final class CountryAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any]) {
        super.init(.get, authorizationRequirement: .never)
        path = ServerEndpoint.country_api
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            parameterData = jsonData
        }
    }
}


final class ValidateSignupOTPAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any]) {
        super.init(.post, authorizationRequirement: .never)
        path = ServerEndpoint.validateotp_signup_api
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            parameterData = jsonData
        }
    }
}

final class ValidateProfileOTPAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any]) {
        super.init(.post, authorizationRequirement: .never)
        path = ServerEndpoint.validateotp_profile_api
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            parameterData = jsonData
        }
    }
}

// MARK: - Create Travel

final class CreateTravelAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any]) {
        super.init(.put, authorizationRequirement: .required)
        path = ServerEndpoint.createtravel_api
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            parameterData = jsonData
        }
        queryItems = [URLQueryItem(name: "code", value: "1")]
    }
}

final class CheckTravelParamsAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any],destination:Int,maximumStayDays:Int, definitionOfDays:String,fiscalStartYear:String,fiscalEndYear:String,threshold:Int) {
        super.init(.get, authorizationRequirement: .required)
        path = ServerEndpoint.check_new_params_api
        queryItems = [URLQueryItem(name: "code", value: "1"),
                      URLQueryItem(name: "destination", value: "\(destination)"),
                      URLQueryItem(name: "maximumStayDays", value: "\(maximumStayDays)"),
                      URLQueryItem(name: "definitionOfDays", value: definitionOfDays),
                      URLQueryItem(name: "fiscalStartYear", value: fiscalStartYear),
                      URLQueryItem(name: "fiscalEndYear", value: fiscalEndYear),
                      URLQueryItem(name: "threshold", value: "\(threshold)")]
    
    }
}

final class ConfirmStayAPIRequest : TravelTaxDayNetworkRequest {
    init(existingId:String,origin:String,destination:String, startDate:String) {
        super.init(.put, authorizationRequirement: .required)
        path = ServerEndpoint.confirm_stay_api
        queryItems = [URLQueryItem(name: "existingId", value: existingId),
                      URLQueryItem(name: "origin", value: origin),
                      URLQueryItem(name: "destination", value: destination),
                      URLQueryItem(name: "startDate", value: startDate)
                      ]
    }
}


final class OverrideRecordParamsAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any],recordID:String) {
        super.init(.put, authorizationRequirement: .required)
        path = ServerEndpoint.overrideparams_api
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            parameterData = jsonData
        }
        queryItems = [URLQueryItem(name: "code", value: "1"), URLQueryItem(name: "existingRecordId", value: recordID)]
    }
}


final class RegisterTokenAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any]) {
        super.init(.put, authorizationRequirement: .required)
        path = ServerEndpoint.registertoken_api
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            parameterData = jsonData
        }
    }
}

final class AddMissingTravelAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any]) {
        super.init(.post, authorizationRequirement: .required)
        path = ServerEndpoint.add_missingtravel_api
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            parameterData = jsonData
        }
    }
}
//final class RegisterAPIRequest : TravelTaxDayNetworkRequest {
//    init(_ params: [String: Any]) {
//        super.init(.post, authorizationRequirement: .never)
//        path = ServerEndpoint.register_api
//        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
//            parameterData = jsonData
//        }
//    }
//}



final class ViewProfileAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any]) {
        super.init(.get, authorizationRequirement: .required)
        path = ServerOnboardEndpoint.viewprofile_api
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            parameterData = jsonData
        }
    }
}


// MARK: - Travel List

final class getMyTravelListAPIRequest : TravelTaxDayNetworkRequest {
    init(userID:String,type:String) {
        super.init(.get, authorizationRequirement: .required)
        path = ServerEndpoint.mytravellist_api
        queryItems = [URLQueryItem(name: "userId", value: userID),
                      URLQueryItem(name: "year", value: type)]
    }
}


// MARK: - Search Record List

final class getSearchRecordsAPIRequest : TravelTaxDayNetworkRequest {
    init(userID:String,taxStartYear:String, taxEndYear: String, country: String) {
        super.init(.get, authorizationRequirement: .required)
        path = ServerEndpoint.searchrecords_api
        queryItems = [URLQueryItem(name: "userId", value: userID), URLQueryItem(name: "taxStartYear", value: taxStartYear), URLQueryItem(name: "taxEndYear", value: taxEndYear), URLQueryItem(name: "country", value: country)]
    }
}

// MARK: - Delete Travel

final class DeleteTravelListAPIRequest : TravelTaxDayNetworkRequest {
    init(userID:String,travelId:String) {
        super.init(.delete, authorizationRequirement: .required)
        path = ServerEndpoint.deletetravellist_api
        queryItems = [URLQueryItem(name: "userId", value: userID),
                      URLQueryItem(name: "travelId", value: travelId)]
    }
}

// MARK: - Travel detail

final class TravelDetailAPIRequest : TravelTaxDayNetworkRequest {
    init(userID:String,travelId:String) {
        super.init(.get, authorizationRequirement: .required)
        path = ServerEndpoint.traveldetail_api
        queryItems = [URLQueryItem(name: "userId", value: userID),
                      URLQueryItem(name: "travelId", value: travelId)]
    }
}

// MARK: - Travel detail

final class TravelSummaryAPIRequest : TravelTaxDayNetworkRequest {
    init(travelId:String) {
        super.init(.get, authorizationRequirement: .required)
        path = ServerEndpoint.travelSummary_api
        queryItems = [URLQueryItem(name: "travelId", value: travelId)]
    }
}

// MARK: - Settings update


final class updateSettingsAPIRequest : TravelTaxDayNetworkRequest {
    
    init(userID:String,hours:String,days:String,workDayInput:String, taxStartYear: String, taxEndYear: String, taxableDays: String,definitionOfDays : String) {
        let params = ["userId": userID, "hours": hours, "days": days, "taxStartYear": taxStartYear, "taxEndYear": taxEndYear, "taxableDays": taxableDays,"definitionOfDays" :definitionOfDays]
        super.init(.put, authorizationRequirement: .required)
        path = ServerEndpoint.updateSettings_api
        //        queryItems = [URLQueryItem(name: "userId", value: userID),
        //                      URLQueryItem(name: "hours", value: hours),URLQueryItem(name: "days", value: days),URLQueryItem(name: "nonWorkDayInput", value: workDayInput), URLQueryItem(name: "taxStartYear", value: taxStartYear), URLQueryItem(name: "taxEndYear", value: taxEndYear), URLQueryItem(name: "taxableDays", value: taxableDays)]
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            parameterData = jsonData
        }
        print("params: \(parameterData!) and the params is: \(params)")
        
    }
    
}


// MARK: - View Settings

final class ViewSettingsAPIRequest : TravelTaxDayNetworkRequest {
    
    init(_ params: [String: Any])  {
        super.init(.get, authorizationRequirement: .required)
        path = ServerEndpoint.viewSettings_api
        parameterData = nil
    }
    
}

// MARK: - Terms and condition

final class TermsAndConditionAPIRequest : TravelTaxDayNetworkRequest {
    
    init(_ params: [String: Any])  {
        super.init(.get, authorizationRequirement: .never)
        path = ServerEndpoint.termsAndConditionApi
        parameterData = nil
    }
    
}

// MARK: - SendLocationPushAPIRequest

final class SendLocationPushAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any]) {
        super.init(.post, authorizationRequirement: .required)
        path = ""
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            parameterData = jsonData
        }
    }
}


// MARK: - Delete Account

final class DeleteAccountAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any]) {
        super.init(.delete, authorizationRequirement: .required)
        path = ServerEndpoint.deleteAccount_api
        parameterData = nil

    }

}

// MARK: // NOTIFICATION API
final class NotificationtAPIRequest : TravelTaxDayNetworkRequest {
    init(userID:String) {
        super.init(.get, authorizationRequirement: .required)
        path = ServerEndpoint.notificaiton_api
        queryItems = [URLQueryItem(name: "receiverId", value: userID)]
    }
}

// MARK: // NOTIFICATION API
final class ReadNotificationtAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any]) {
        super.init(.post, authorizationRequirement: .required)
        path = ServerEndpoint.readNotificaiton_api
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            parameterData = jsonData
        }
    }
}

// MARK: - DownloadCSV update


final class DownloadCSVAPIRequest : TravelTaxDayNetworkRequest {

    init(countryId:String,year:String,exportType:String,fileType:String,email:String) {

        super.init(.get, authorizationRequirement: .required)

        path = ServerEndpoint.export_email_download

        switch exportType {
        case "send":
            queryItems = [URLQueryItem(name: "countryId", value: countryId),
                          URLQueryItem(name: "year", value: year),
                          URLQueryItem(name: "exportType", value: exportType),
                          URLQueryItem(name: "fileType", value: fileType),
                          URLQueryItem(name: "email", value: email)]
        default:
            queryItems = [URLQueryItem(name: "countryId", value: countryId),
                          URLQueryItem(name: "year", value: year),
                          URLQueryItem(name: "exportType", value: exportType),
                          URLQueryItem(name: "fileType", value: fileType)
                          ]
        }        

    }

}

// MARK: - Send Report
 
final class SendReportAPIRequest : TravelTaxDayNetworkRequest {
    init(countryId:String,year:String,email:String) {
        super.init(.put, authorizationRequirement: .required)
        path = ServerEndpoint.sendReport_api
        queryItems = [URLQueryItem(name: "countryId", value: countryId),
                      URLQueryItem(name: "year", value: year),URLQueryItem(name: "email", value: email)]
    }

}


// MARK: New user check API
final class NewUserCheckAPIRequest : TravelTaxDayNetworkRequest {
    init() {
        super.init(.get, authorizationRequirement: .required)
        path = ServerEndpoint.newUserCheck_api
    }
}

// MARK: New OTP generate

final class NewUserOTPAPIRequest : TravelTaxDayNetworkRequest {
    init(_ params: [String: Any]) {
        super.init(.post, authorizationRequirement: .never)
        path = ServerEndpoint.newuserotp
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) {
            parameterData = jsonData
        }
    }
}
