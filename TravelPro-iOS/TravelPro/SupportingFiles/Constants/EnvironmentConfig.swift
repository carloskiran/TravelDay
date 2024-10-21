

import Foundation
import AWSS3

public var current_environment: environment = .test
//public var current_environment: environment = .devlopment

public enum environment: String {

    case production = ""
    case devlopment = "https://travelpro.optisolbusiness.com/travelProGateway/travelProGateway/"
    case test = "https://traveltaxdaytest.optisolbusiness.com/travelProGateway/travelProGateway/"
}

struct ServerAPIURL {
    static let ttd_ServiceUrl = getBaseURL()
}

struct ServerEndpoint {
    static let forgotpassword_api = "travelProLogin/forgotpassword"
    static let country_api = "travelProLogin/country"
    static let generateotp_api = "travelProLogin/generateotp"
    static let newuserotp = "travelProLogin/newuserotp"
    static let createpassword_api = "travelProLogin/createpassword"
    static let validateotp_signup_api = "travelProLogin/newuserotpvalidate"
    static let validateotp_profile_api = "travelProLogin/otpvalidation"
    static let createtravel_api = "travelProTravel/travel/createorupdate"
    static let confirm_stay_api = "travelProTravel/confirmStay"
    static let check_new_params_api = "travelProTravel/checkTravelParams"
    static let overrideparams_api = "travelProTravel/overrideRecord"
    static let registertoken_api = "travelProLogin/devicetoken"
    static let add_missingtravel_api = "travelProTravel/travel/missedrecord"
    static let mytravellist_api = "travelProTravel/allrecords"
    static let deletetravellist_api = "travelProTravel/travelrecord"
    static let traveldetail_api = "travelProTravel/tripinfo"
    static let mix_panel_token = "2f965981f5b36f3ea24b1c69b7b6d7f4"
    static let updateSettings_api = "travelProProfile/userSettings"
    static let viewSettings_api = "travelProProfile/viewSettings"
    static let termsAndConditionApi = "travelProLogin/termsandconditions"
    static let searchrecords_api = "travelProTravel/searchrecords"
    static let deleteAccount_api = "travelProLogin/useraccount"
    static let notificaiton_api = "travelProNotification/notification/user"
    static let readNotificaiton_api = "travelProNotification/readnotification"
    static let export_email_download = "travelProTravel/travel/email/export"
    static let downloadpdforcsv = "travelProTravel/downloadData"
    static let sendReport_api = "travelProTravel/travel/emailexport"
    static let travelSummary_api = "travelProTravel/travelSummary"
    static let newUserCheck_api = "travelProTravel/newUserCheck"
}

struct ServerOnboardEndpoint {
    static let login_api = ServerAPIURL.ttd_ServiceUrl+"travelProLogin/login"
    static let sociallogin_api = ServerAPIURL.ttd_ServiceUrl+"travelProLogin/sociallogin"
    static let mobilecheck_api = ServerAPIURL.ttd_ServiceUrl+"travelProLogin/mobilecheck"
    static let emailcheck_api = ServerAPIURL.ttd_ServiceUrl+"travelProLogin/emailcheck"
    static let edit_profile_api = ServerAPIURL.ttd_ServiceUrl+"travelProLogin/editProfile"
    static let register_api = ServerAPIURL.ttd_ServiceUrl+"travelProLogin/register"
    static let viewprofile_api = ServerAPIURL.ttd_ServiceUrl+"travelProLogin/viewProfile"
}

private func getBaseURL() -> String {
    current_environment.rawValue
}

struct travel_tax_day {

	static let pagination_size = "20"
	static let mix_panel_token = "38991355ef4cbebdbbf9c22680847b4c"
	
}

struct socket_keys {
		
}

private func getAWSBaseURL() -> String {
    
    switch current_environment {
    case .devlopment:
        return "https://d2m2nyzc6krp3t.cloudfront.net/"
//    case "Development":
//        return "https://d3cghkvc40w721.cloudfront.net/"
        
    case .test:
        return "https://d3pwh09cocu7f4.cloudfront.net/"
        
    default:
        return ""
    }
    
}

struct getGoogleClientIDs {
    public static let googleID = getGoogleClientID()
    
    
}
private func getGoogleClientID() -> String {
    
    switch current_environment {
    case .devlopment:
        return "398435075846-r0i7g4ps20k0kdpmpr7ji16o23iqihno.apps.googleusercontent.com"
        
    case .test:
        return "398435075846-r0i7g4ps20k0kdpmpr7ji16o23iqihno.apps.googleusercontent.com"

    default:
        return "398435075846-r0i7g4ps20k0kdpmpr7ji16o23iqihno.apps.googleusercontent.com"
        
    }
    
}
struct AWSConfig {
    public static let kAccessKey = getkAccessKey()
    public static let KsecretKey = getkAWSKsecretKey()
    public static let KRegion: String =  getkRegion()
    public static let kIMAGEBUCKET = getAWSkIMAGEBUCKET()
    public static let kAWSBaseURL = getAWSBaseURL()
    public static let kRegionSetup = getRegionSetup()
    public static let kstaticfolderPath = getAWSFolderPath()
    public static let AWSAccessKey = awsAccessKey()
}
private func getAWSFolderPath() -> String {

    switch current_environment {
    case .devlopment:
        return  "profileimages/"

    case .test:
        return  "profileimages/"
   
    default:
        return "profileimages/"
    }
}

private func awsAccessKey() -> String {
    switch current_environment {
    case .devlopment:
        return "AKIA4VX6FJTDS7ZCWPSJ"
    case .test:
        return "AKIAUHVBLSTP2WT3H3YT"

    default:
        return ""
    }
}

private func getRegionSetup() -> AWSRegionType {
    
    switch current_environment {
    case .devlopment:
        return .USEast1
    case .test:
        return .USEast1
    default:
        return .APSoutheast1
    }
}

private func getkAccessKey() -> String {

    switch current_environment {
    case .devlopment:
        return "us-east-1:340abc37-1065-4f2c-b2e2-cab9785a6d65"
    case .test:
        return "us-east-1:6e228f62-b9f3-400f-9463-d276c9f8802a"
    default:
        return ""

    }

}

private func getkRegion() -> String {

    switch current_environment {
    case .devlopment:
        return "US_EAST_1"
    case .test:
        return "US_EAST_1"
    default:
        return "ap-southeast-1"

    }

}

private func getkAWSKsecretKey() -> String {

    switch current_environment {
    case .devlopment:
        return "mb/G8G146N1SdkXSXYczDFpDyedhcUhl+PNhnkCX"
    case .test:
        return "OhV8bD+LZhihlWILHM9CEIKVRQZHw2uqPxIIHh3M"
    default:
        return ""

    }

}

private func getAWSkIMAGEBUCKET() -> String {

    switch current_environment {
    case .devlopment:
        return "travelprodevstorage"
    case .test:
        return "travelprotest-application"
    default:
        return ""
    }

}

//Aws upload imgae fromat
struct AWSUploadDataType {
    public static let KImageExt: String = ".png"
    public static let KVideoExt: String =  ".mp4"
    public static let kDocumetExt: String = ".pdf"
    public static let kImageJpeg: String = ".jpeg"
}
//AWS upload type
struct CoreDataMessageType {
    static let kText = "textmessage"
    static let kImage = "image/png"
    static let kVideo = "video/mp4"
    static let kpdf = "pdf"
    static let KAudio = "audio/mp3"
}
