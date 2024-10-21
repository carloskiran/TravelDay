//
//  AWSManager.swift
//  Smilables
//
//  Created by @karthi on 23/02/22.
//

import Foundation
import AWSS3
//import AWSCognito
import AWSCore
import AVFoundation
import WXImageCompress
import Alamofire

enum ContentType: String {
    case image = "image/jpeg"
    case video = "movie/mov"
}

struct AWSSuccessResponse {
    let urlString:String
    let keyName:String
}
var totalItemsUploaded: Int?
var currentItem: Int?

typealias progressBlock = (_ progress: Double) -> Void
typealias completionBlock = (_ response: AWSSuccessResponse?, _ error: Error?) -> Void

class AWSManager {
    
    static let shared = AWSManager()
    
    public lazy var baseS3BucketURL: URL? = {
        let url = AWSS3.default().configuration.endpoint.url
        return url
    }()
    
    class func initialize() {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSConfig.kRegionSetup,
                                                                identityPoolId:AWSConfig.kAccessKey)
        let configuration = AWSServiceConfiguration(region:AWSConfig.kRegionSetup, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    class func AWSInitialize() {
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: AWSConfig.AWSAccessKey, secretKey: AWSConfig.KsecretKey)
        let configuration = AWSServiceConfiguration(region: AWSConfig.kRegionSetup, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    
    func uploadingDocumentsToAWS(fileURL: URL, fileType: String, indexValue: Int, progressReading: @escaping (Float) -> Void, onSuccess success: @escaping(String, Int) -> Void, onFailure failure: @escaping(String) -> Void)  {
        
        AWSManager.AWSInitialize()
        
        let S3BucketName = AWSConfig.kIMAGEBUCKET
        let transferUtility = AWSS3TransferUtility.default()
        let bucketName = S3BucketName
        let timestamp = NSDate().timeIntervalSince1970
        let timestr = String(format: "%.f", timestamp)
        let key = "createTravel/"+timestr+"_traveltax_"+fileURL.lastPathComponent
        print(key)
        
        var contentType = "" // default content type
        
        switch fileType {
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
        case "", "jpg":
            if fileURL.pathExtension == "png" || fileURL.pathExtension == "jpeg" || fileURL.pathExtension == "jpg" {
                contentType = ContentType.image.rawValue
            } else {
                contentType = ContentType.video.rawValue
            }
        default:
            break
        }
        print("contentType: \(contentType)")
        
        let uploadExpression = AWSS3TransferUtilityUploadExpression()
        uploadExpression.progressBlock = { task, progress in
            DispatchQueue.main.async {
                // Update UI with upload progress
                let percent = Float(progress.fractionCompleted * 100)
                print("Upload progress: \(percent)%")
                progressReading(percent)
            }
        }
        transferUtility.uploadFile(fileURL,
                                   bucket: bucketName,
                                   key: key, // Replace with the desired key (filename) in S3
                                   contentType: contentType, // Replace with the appropriate content type for PDF or Excel files
                                   expression: uploadExpression) { task, error in
            if let error = error {
                print("Upload failed: \(error.localizedDescription)")
            } else {
                print("Upload successful \(task)")
                success(key, indexValue)
            }
        }
        
    }
    
    func deleteUploadDocument(documentName: String) {
        AWSManager.AWSInitialize()
        
        let s3 = AWSS3.default()
        let deleteObjectRequest = AWSS3DeleteObjectRequest()
        deleteObjectRequest?.bucket = AWSConfig.kIMAGEBUCKET
        deleteObjectRequest?.key = documentName
        
        s3.deleteObject(deleteObjectRequest!).continueWith { (task) -> Any? in
            if let error = task.error {
                print("Error deleting object: \(error)")
            } else {
                print("Object deleted successfully")
            }
            return nil
        }

    }
 
    
    // Upload video from local path url
    func uploadVideo(videoData: Data,success: @escaping (String) -> Void, onFailure failure: @escaping (Error) -> Void) {
        
        let fileName = self.getUniqueFileName()
        let getPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
        getPreSignedURLRequest.bucket =  AWSConfig.kIMAGEBUCKET
        getPreSignedURLRequest.key = AWSConfig.kstaticfolderPath  + fileName
        getPreSignedURLRequest.httpMethod = .PUT
        getPreSignedURLRequest.expires = Date(timeIntervalSinceNow: 3600)

        //Important: set contentType for a PUT request.
        let fileContentTypeStr = ContentType.video.rawValue
        getPreSignedURLRequest.contentType = fileContentTypeStr
        AWSS3PreSignedURLBuilder.default().getPreSignedURL(getPreSignedURLRequest).continueWith { (task:AWSTask<NSURL>) -> Any? in
            if let error = task.error {
                print("Error: \(error)")
                failure(error)
                return nil
            }
            let presignedURL = task.result
            let preSignedURLStr = presignedURL?.absoluteString
            print("Upload presignedURL is: \(String(describing: preSignedURLStr))")
            let url = URL(string: preSignedURLStr!)
            var request = URLRequest(url:url!)
            request.cachePolicy = .reloadIgnoringLocalCacheData
            request.httpMethod = "PUT"
            request.setValue(fileContentTypeStr, forHTTPHeaderField: "Content-Type")
            let uploadTask:URLSessionTask = URLSession.shared.uploadTask(with: request, from: videoData) { data, response, error in
                if let error = error {
                    failure(error)
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                    success(fileName)
                }
            }
            uploadTask.resume()
            _ = uploadTask.progress.observe(\.fractionCompleted) { progress, _ in
                print("progress: ", progress.fractionCompleted)
            }
            return nil
        }
    }
    
    
    func uploadImageToAWS(uploadImage: UIImage!,type: String? = "",viewController: UIViewController!, completion: @escaping(_ uploadUrl: String, _ statusCode: Int) -> Void) {
        // MARK: create file path
        let getPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
        let filePath: URL = createFilePath(image: uploadImage)
        let globalFileName = ProcessInfo.processInfo.globallyUniqueString  + (".jpeg")
         getPreSignedURLRequest.bucket = AWSConfig.kIMAGEBUCKET
        getPreSignedURLRequest.key = AWSConfig.kstaticfolderPath  + globalFileName
         getPreSignedURLRequest.httpMethod = .PUT
        getPreSignedURLRequest.expires = Date(timeIntervalSinceNow: 3600)
         getPreSignedURLRequest.contentType = ContentType.image.rawValue
 
        // MARK: Get PreSigned URLRequest
        self.imageUploadGetPreSignedURLRequest(preSignedURL: getPreSignedURLRequest, viewController: viewController, fileURL: filePath, fileName: globalFileName, currentItem: 0, totalCount: 0, type: type) { (filename, statusCode) in
            if statusCode.rawValue == 200{
                completion(filename!,statusCode.rawValue)
            } else {
                print("error")
                completion("",statusCode.rawValue)
            }
        }
        
        
    }
    
    
    // MARK: image Upload Get Pre Signed URL Request
    func imageUploadGetPreSignedURLRequest(preSignedURL: AWSS3GetPreSignedURLRequest, viewController : UIViewController, fileURL:URL, fileName: String,  currentItem: Int? = 0, totalCount: Int? = 0,type: String? = "", completion: @escaping(_ result: String?,_ statusCode: ResponseCode) -> Void)  {
        print(fileURL)
      //  currentItem = currentItem
      // totalItemsUploaded = totalCount
        AWSManager.initialize()
        AWSS3PreSignedURLBuilder.default().getPreSignedURL(preSignedURL).continueWith { (task:AWSTask<NSURL>) -> Any? in
            if let error = task.error as NSError? {
                print("DC: Error: \(error.localizedDescription)")
                return nil
            }
            else {
                let presignedURL = task.result!
                print("DC: Upload presignedURL is: \(String(describing: presignedURL))")
                // Create url request & configure
                var request = URLRequest(url: presignedURL as URL)
                request.httpMethod = "PUT"
                if fileURL.pathExtension == "png" || fileURL.pathExtension == "jpeg" {
                    request.setValue(ContentType.image.rawValue, forHTTPHeaderField: "Content-Type")
                } else {
                    request.setValue(ContentType.video.rawValue, forHTTPHeaderField: "Content-Type")
                }
                // Create urlSession add to operarion Queue
                let sessionConfiguration = URLSessionConfiguration.default
                let urlSession = URLSession.init(configuration: sessionConfiguration, delegate: self as? URLSessionDelegate, delegateQueue: (OperationQueue.main))
                // URLSession UploadTask
                let uploadTask: URLSessionUploadTask = urlSession.uploadTask(with: request, fromFile: (fileURL as URL?)!, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                    
                    let httpResponse =  response as? HTTPURLResponse
                    print("httpResponse")
                    if httpResponse?.statusCode == 200 {
                        completion(fileName,ResponseCode(rawValue: (httpResponse?.statusCode)!)!)
                    }
                    else {
                        if data != nil{
                            completion(fileName,ResponseCode(rawValue: (httpResponse?.statusCode)!)!)
                        }else{
                            completion(fileName,ResponseCode(rawValue: 404)!)
                        }
                        print("DC: AWSManger httpResponse failure \(String(describing: httpResponse))")
                        print("DC: AWSManger httpResponse failure \(String(describing: httpResponse?.statusCode))")
                    }
                })
                uploadTask.resume()
            }
            return nil
        }
    }
    
    
    func createFilePath(image: UIImage) -> URL {
        // MARK: create file directory
        let docDir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let imageUniqueName : Int64 = Int64(NSDate().timeIntervalSince1970 * 1000)
        if let filePath = docDir?.appendingPathComponent("\(imageUniqueName).png") {
            do {
 
                if let compressImage = image.wxCompress().jpegData(compressionQuality: 0.5){
                    try compressImage.write(to: filePath, options : .atomic)
                return filePath
                }
            } catch {
                print("couldn't write image")
            }
        }
        return URL.init(string: "")!
    }
    // Get unique file name
    func getUniqueFileName() -> String {
        let strExt: String = ".MOV"
        return (ProcessInfo.processInfo.globallyUniqueString + (strExt))
    }
    
    class func getCloundFrontURL(_ keyName:String) -> String {
        if keyName.contains(".jpeg") {
            let str = AWSConfig.kAWSBaseURL + keyName
            print(str)
            return str
        } else {
            let str = AWSConfig.kAWSBaseURL + keyName
            print(str)
            return str
        }
    }
    
    class func getThumbnailImage(keyName: String,completion:@escaping ((_ url: URL) -> Void)) {
        let videoURL = keyName.dropLast(4)
        let ext = "-00001.png"
        let imgURL = AWSConfig.kAWSBaseURL + videoURL + ext
        if let imageURL = URL(string: imgURL) {
            completion(imageURL)
        }
    }
    
    
    enum ResponseCode: Int {
        // Requested api returns expected response
        case success                 = 200
        // Email Id not found
        case inVaildEmail           = 201
        // Invaild OTP
        case inValidOTP             = 202
        // Password Mismatching
        case inValidPwd             = 203
        // Token Mismatching
        case tokenMismatch          = 204
        // File not found
        case fileUnvailable         = 206
        // SR ID not found
        case srIdUnvailable        = 207
        // ISR ID not found
        case isrIdUnvailable        = 208
        // File name not found
        case fileNameUnvailable     = 209
        // Some thing went wrong
        case unExpectedError        = 210
        // Invalid password
        case pwdInvalid             = 211
        // Previous password already exists
        case previousPwdSame        = 212
        // User display or read permission missing
        case permissionDisAllow     = 230
        // Email already Exists
        case emailAlreadyExists      = 302
        // The HTTP request is incomplete or malformed.
        case badRequest             = 400
        // Authorization is required to use the service
        case unAuthorization        = 401
        // User do not have permission to access the database.
        case forbidden              = 403
        // The named database is not running on the server, or the named web service does not exist.
        case notFound               = 404
        // The maximum connection idle time was exceeded while receiving the request
        case timeOut                = 408
        // An internal error occurred. The request could not be processed.
        case serviceUnavailable     = 500
        // No internet
        case noNetwork              = -1
    }
    
}


