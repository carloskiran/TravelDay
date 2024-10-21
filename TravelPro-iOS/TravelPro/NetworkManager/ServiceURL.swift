//
//  ServiceURL.swift
//
//  Created by Mac-OBS-18 on 21/02/22.
//

import Foundation
import AWSS3
 
private var isTestEnvironment: String = "Development"
//private var isTestEnvironment: String = "Development"

//private func getBaseURL() -> String {
//
//    switch isTestEnvironment {
//    case "Development":
//        return "https://travelpro.optisolbusiness.com/travelProGateway/travelProGateway/travelProLogin/"
//
//    case "Testing":
//        return "https://traveltaxdaytest.optisolbusiness.com/travelProGateway/travelProGateway/travelProLogin/"
//
//    case "Production":
//        return ""
//    default:
//        return ""
//
//    }
//
//}
//
//
//struct TravelProServerAPIURL {
//    static let TravelPro = getBaseURL()
//    static let login_api = TravelPro + "login"
//    static let sociallogin_api = TravelPro + "sociallogin"
//    static let mobilecheck_api = TravelPro + "mobilecheck"
//    static let emailcheck_api = TravelPro + "emailcheck"
//    static let edit_profile_api = TravelPro + "editProfile"
//    static let register_api = TravelPro + "register"
//    static let viewprofile_api = TravelPro + "viewProfile"
//
//}
//
//private func getAWSBaseURL() -> String {
//
//    switch isTestEnvironment {
//    case "Development":
//        return "https://d2m2nyzc6krp3t.cloudfront.net/"
////    case "Development":
////        return "https://d3cghkvc40w721.cloudfront.net/"
//
//    case "Testing":
//        return "https://d3pwh09cocu7f4.cloudfront.net/"
//
//    case "Production":
//        return ""
//
//    default:
//        return ""
//
//    }
//
//}
//
//struct getGoogleClientIDs {
//    public static let googleID = getGoogleClientID()
//
//
//}
//private func getGoogleClientID() -> String {
//
//    switch isTestEnvironment {
//    case "Development":
//        return "398435075846-r0i7g4ps20k0kdpmpr7ji16o23iqihno.apps.googleusercontent.com"
//
//    case "Testing":
//        return "398435075846-r0i7g4ps20k0kdpmpr7ji16o23iqihno.apps.googleusercontent.com"
//
//    case "Production":
//        return "398435075846-r0i7g4ps20k0kdpmpr7ji16o23iqihno.apps.googleusercontent.com"
//
//    default:
//        return "398435075846-r0i7g4ps20k0kdpmpr7ji16o23iqihno.apps.googleusercontent.com"
//
//    }
//
//}
//struct AWSConfig {
//    public static let kAccessKey = getkAccessKey()
//    public static let KsecretKey = getkAWSKsecretKey()
//    public static let KRegion: String =  getkRegion()
//    public static let kIMAGEBUCKET = getAWSkIMAGEBUCKET()
//    public static let kAWSBaseURL = getAWSBaseURL()
//    public static let kRegionSetup = getRegionSetup()
//    public static let kstaticfolderPath = getAWSFolderPath()
//    public static let AWSAccessKey = awsAccessKey()
//}
//private func getAWSFolderPath() -> String {
//
//    switch isTestEnvironment {
//    case "Development":
//        return  ""
//
//    case "Testing":
//        return  ""
//    case "Production":
//        return  "profileimages/"
//
//    default:
//        return ""
//
//    }
//}
//
//private func awsAccessKey() -> String {
//    switch isTestEnvironment {
//    case "Development":
//        return "AKIA4VX6FJTDS7ZCWPSJ"
//    case "Testing":
//        return "AKIAUHVBLSTP2WT3H3YT"
//    case "Production":
//        return ""
//    default:
//        return ""
//    }
//}
//
//private func getRegionSetup() -> AWSRegionType {
//
//    switch isTestEnvironment {
//    case "Development":
//        return .USEast1
//
//    case "Testing":
//        return .USEast1
//    case "Production":
//        return .APSoutheast1
//
//    default:
//        return .USEast1
//
//    }
//}
//
//private func getkAccessKey() -> String {
//
//    switch isTestEnvironment {
//    case "Development":
//        return "us-east-1:340abc37-1065-4f2c-b2e2-cab9785a6d65"
////    case "Development":
////        return "us-east-1:69016597-046f-4643-9e4c-126c5b3e21b4"
//
//    case "Testing":
//        return "us-east-1:6e228f62-b9f3-400f-9463-d276c9f8802a"
//    case "Production":
//        return ""
//
//    default:
//        return ""
//
//    }
//
//}
//
//private func getkRegion() -> String {
//
//    switch isTestEnvironment {
//    case "Development":
//        return "US_EAST_1"
////    case "Development":
////        return "US_WEST_2"
//
//    case "Testing":
//        return "US_EAST_1"
//    case "Production":
//        return  "ap-southeast-1"
//
//    default:
//        return "ap-southeast-1"
//
//    }
//
//}
//
//private func getkAWSKsecretKey() -> String {
//
//    switch isTestEnvironment {
//    case "Development":
//        return "mb/G8G146N1SdkXSXYczDFpDyedhcUhl+PNhnkCX"
////    case "Development":
////        return "qhHdJz4yUrztayHs4PPuHXGAxXw7Pm+Vd/NRAztJ"
//
//    case "Testing":
//        return "OhV8bD+LZhihlWILHM9CEIKVRQZHw2uqPxIIHh3M"
//
//    case "Production":
//        return ""
//
//    default:
//        return ""
//
//    }
//
//}
//
//private func getAWSkIMAGEBUCKET() -> String {
//
//    switch isTestEnvironment {
//    case "Development":
//        return "travelprodevstorage"
//
//    case "Testing":
//        return "travelprotest-application"
//
//    case "Production":
//        return  ""
//
//    default:
//        return ""
//
//    }
//
//}
//
////Aws upload imgae fromat
//struct AWSUploadDataType {
//    public static let KImageExt: String = ".png"
//    public static let KVideoExt: String =  ".mp4"
//    public static let kDocumetExt: String = ".pdf"
//    public static let kImageJpeg: String = ".jpeg"
//}
////AWS upload type
//struct CoreDataMessageType {
//    static let kText = "textmessage"
//    static let kImage = "image/png"
//    static let kVideo = "video/mp4"
//    static let kpdf = "pdf"
//    static let KAudio = "audio/mp3"
//}
