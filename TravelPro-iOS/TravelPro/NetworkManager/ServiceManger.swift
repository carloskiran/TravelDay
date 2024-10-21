import Foundation
import Alamofire
//import NVActivityIndicatorView
class ServiceManger {
    // POST METHOD
    enum Error: Swift.Error, CustomStringConvertible {
        
        case connectionError(message: String)
        case error(message: String)
        case badStatus(message: String)
        case malformedResponse(message: String)
        
        var description: String {
            switch self {
            case .badStatus(let message):
                return "Bad Status: \(message)"
            case .error(let message):
                return "Error: \(message)"
            case .connectionError(let message):
                return "Connection Error: \(message)"
            case .malformedResponse(let message):
                return "MalformedResponse: \(message)"
            }
        }
    }
    
    typealias ResultData<T: Codable> = Swift.Result<T, Error>
    typealias Completion<T: Codable> = (ResultData<T>) -> Void
    static func postJSONRequest<ResultType, Parameter>(_ url: String, parameters: Parameter? = nil,controller : UIViewController, boolLoaderEnable : Bool, headerEnable : Bool, methodType : HTTPMethod,jsonType : ParameterEncoder, completion: @escaping (ResultData<ResultType>) -> Void) where ResultType: Codable, Parameter: Codable {
    //    if Library.sharedInstance.isInternetReachable() {
        if boolLoaderEnable == true {
//        controller.view.layer.opacity = 0.6
            Loader.startLoading(controller.view, userIneration: false)
        }
        var headers: HTTPHeaders
       
        if headerEnable == true {
            let bearerToken = UserDefaultModule.shared.getAccessToken()
            headers = ["Cookie": "","Authorization": "bearer \(bearerToken)", "Content-Type": "application/json"]
        } else
        {
            headers = ["Cookie":""]
        }
        
        AF.request(url,method: methodType,parameters: parameters,encoder: jsonType, headers: headers)
            .responseDecodable { (response: DataResponse<ResultType, AFError>) in
                
               
                switch response.result {
                case .failure(let error):
                    completion(.failure(.connectionError(message: error.localizedDescription)))
                    print("error :\(error.localizedDescription)")
                     
                    if boolLoaderEnable == true {
                    Loader.stopLoading(controller.view)
                    controller.view.layer.opacity = 1.0
                    }
                case .success(let result):
                    if boolLoaderEnable == true {
                    Loader.stopLoading(controller.view)
                    controller.view.layer.opacity  = 1.0
                    }
                    completion(.success(result))
                    
                }
        }
        
//        } else {
//            utilsClass.sharedInstance.debugprint(message: "No Internet")
//            utilsClass.sharedInstance.NotificatonAlertMessage(title: "", subTitle: TextConstant.sharedInstance.SEmpty, body: "No internet connection", image: UIImage(named: "") ?? nil,theme: .default)
//        }
    }
 
}
