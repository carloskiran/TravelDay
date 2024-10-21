//
//  NetworkManager.swift
//  DKKit
//
//

import Foundation
import UIKit

public enum URLType {
	case directURL
	case formedURL
}

public func URLQueryItemString(dictionary: [String: Any]) -> String {
	var components = URLComponents()
	components.queryItems = dictionary.map {
		URLQueryItem(name: $0, value: String(describing: $1))
	}
	return (components.url?.absoluteString)!
}

/// Authendication used to manage access token for webservice
///
/// - required: Access token will be added in header as Authendication
///
/// - never: Access token will not be added in header

public enum Authendication {
	case required
	case never
}

/// Network Request Error used to manage error status
///
/// - error: Error debug description will be shown here
///
/// - errorCode: Error code will be displayed (Ex: 200 - Success, 500 - Internal server)
///
/// - httpErrorCode: Http Status Error code will be displayed (Ex: 200 - Success, 500 - Internal server)
///
/// - description: Error description in detail will be shown

public struct NetworkRequestError: Error {
	var statusCode: Int?
	var description: String!
}

/// Encode Type used to manage different mode of encode
///
/// - encodedURL: This mode used to encode with base URL
///
/// - encodedJSON: This mode used to encode the parameters in JSON format

public enum EncodeType {
	case encodedURL
	case encodedJSON
}

/// HTTP Utils used to form url to be encoded with separator

public class HTTPUtils {
	public class func formUrlencode(_ values: [String: String]) -> String {
		return values.map { key, value in
			return "\(key.formUrlencoded())=\(value.formUrlencoded())"
		}.joined(separator: "&")
	}
}

/// Network Manager is used to handle network session
///
/// - Discussion: This value will be appended to the `Content-Type` header field
///
/// - Important: This value will be appended if, and only if `contentType` is non-nil

/// Configuration object for `CoreDataStack`
public struct NetworkManagerConfiguration: Equatable {
	/// The URL of the model to use
	public let baseURL: URL
	/// Designated initializer to create an instance of the
	///
	/// - Parameters:
	///   - baseURL: The model's URL
	///   - bundleIdentifier: The app's bundle identifier. Defaults to Bundle.main.bundleIdentifier
	///   - bundleName: The app's bundle name.
	///   Defaults Bundle.main.bundleURL.lastPathComponent with the extension stripped
	///   - storeType: The store type to use for the persistent store. Defaults to NSSQLiteStoreType
	public init(baseURL: URL) {
		self.baseURL = baseURL
	}
}

public final class TTDNetworkManager {
	
	private static var _internalSharedManager: TTDNetworkManager?
	
	public static var shared: TTDNetworkManager {
		guard let internalSharedManager = _internalSharedManager else {
			fatalError("please setup the core data stack with a configuration")
		}
		
		return internalSharedManager
	}
	
	/// Internal testing method to reset the shared internal manager
	internal class func _resetSharedManager() {
		_internalSharedManager = nil
	}
	
	public private(set) var configuration: NetworkManagerConfiguration
	
	/// Internal designated initializer
	///
	/// - Parameter configuration: The configuration
	private init(configuration: NetworkManagerConfiguration) {
		self.configuration = configuration
	}
	
	@discardableResult
	/// Shared
	/// - Parameter configuration: NetworkManagerConfiguration
	/// - Returns: TTDNetworkManager
	public class func shared(with configuration: NetworkManagerConfiguration) -> TTDNetworkManager {
		if let networkManager = _internalSharedManager {
			return networkManager
		}
		
		let coreDataManager = TTDNetworkManager(configuration: configuration)
		
		_internalSharedManager = coreDataManager
		
		return coreDataManager
	}
	
	/// Method that execute an network request
	///
	/// - Parameters:
	///   - request: Network request object which contains path, mode and URLQueryItems
	///   - responseType: Response model with valid value and key format
	/// - Returns: Result (Response model, Network request error)
	
	private lazy var baseURL: URL = {
		return configuration.baseURL
	}()
	
	/// Setup URL Path
	/// - Parameter request: TravelTaxDayNetworkRequest
	/// - Returns: URL
	private static func setupURLPath(request: TravelTaxDayNetworkRequest) -> URL {
		
		/// Construct the base url to make request with path details
		///
		/// - directURL: Both baseURL and path will be appended together with timestamp
		///
		/// - formedURL: Both baseURL and path will be appended together to form request URL
		
		if let baseURL = request.baseURL {
			return request.constructURL(baseURL: baseURL, additionalURLQueryItems: [])
		} else {
			return request.constructURL(baseURL: TTDNetworkManager.shared.configuration.baseURL, additionalURLQueryItems: [])
		}
		
	}
	
	/// Setup URL Request
	/// - Parameter request: TravelTaxDayNetworkRequest
	/// - Returns: URL Request
	private static func setupURLRequest(request: TravelTaxDayNetworkRequest) -> URLRequest {
		
		var networkRequest = URLRequest(url: setupURLPath(request: request))
		networkRequest.httpMethod = request.HTTPMethod.rawValue
		networkRequest.cachePolicy = .reloadIgnoringCacheData
		/// Network request time interval changed to 130 sec as similar like back end time out range
		networkRequest.timeoutInterval = 130
		
		if let mutiformEnabled = request.isMultiFormData, mutiformEnabled {
			let boundary = "Boundary-\(NSUUID().uuidString)"
			networkRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
		} else {
			networkRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
			networkRequest.setValue("Application/json", forHTTPHeaderField: "Accept")
		}
		
		if request.authorizationRequirement == .required {
             let token = UserDefaultModule.shared.getAccessToken()
				networkRequest.setValue("bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		
		/// Httpbody data will be added with parameterData and parameter
		///
		/// - parameterData: It will be encoded and converted into Data.
		/// Due to that it will directly assigned to httpBody
		///
		/// - parameter: Request parameter will be converted in below format
		///     - encodedURL: This mode used to encode with base URL
		///     - encodedJSON: This mode used to encode the parameters in JSON format
		///
		
		if let params = request.parameter {
			
			let newParms = convertToDic(data: params)
			
			guard let _ = try? JSONSerialization.data(withJSONObject: newParms, options: []) else {
				return networkRequest
			}
		}
       
		if let paramData = request.parameterData {
			networkRequest.httpBody = paramData
		}
		
		return networkRequest
		
	}
	
	/// Convert To Dic
	/// - Parameter data: String array
	/// - Returns: MutableDictionary
	private static func convertToDic(data: [String: Any]) -> NSMutableDictionary {
		let newParms = NSMutableDictionary()
		for item in data {
			let key = item.key
			let value = item.value
			newParms.setValue(value, forKey: key)
		}
		return newParms
	}
	
	/// Execute full network request
	/// - Parameters:
	///   - request: TravelTaxDayNetworkRequest
	///   - responseType: T.Type
	///   - completionHandler: NetworkRequestError
    public static func execute<T: Decodable>(request: TravelTaxDayNetworkRequest,
                                                                            responseType: T.Type,
                                                                                     completionHandler: @escaping (Result<T, NetworkRequestError>) -> Void) {
		
		/// Validate reachability for network connection
		
		if !Reachability.isConnectedToNetwork() {
			
			/// Monitor network connection instantly
			NetworkMonitor().startMonitoring()
			
			let error = NetworkRequestError(statusCode: 300,
																			description: "Please check your internet connection !!!")
			DispatchQueue.main.async {
				completionHandler(.failure(error))
			}
			return
		}
		
		
		/// URLRequest created with custom configuration
		
		let networkRequest = setupURLRequest(request: request)
		
		URLSession.shared.dataTask(with: networkRequest) { (data, response, error) in
			
			if let data = data, let httpStatus = response as? HTTPURLResponse {
				
				/// Http Status code will be used to manage the success and error status of the request
				/// - 200: Http status as success
				///
				/// - 401: Invalid or expired Access token
				///
				/// - 500: Internal server error
				///
				/// - other: Unknown error
				///
				
				switch httpStatus.statusCode {
				case 200, 201, 302:
					do {
						let dataObj = try JSONDecoder().decode(T.self, from: data)
						DispatchQueue.main.async {
							completionHandler(.success(dataObj))
						}
					} catch {
						/// Unknown error response will be returned with response
						let error = NetworkRequestError(statusCode: httpStatus.statusCode,
																						description: "Invalid data format !!!. Path: \(request.path)")
						DispatchQueue.main.async {
							completionHandler(.failure(error))
						}
					}
					
				case 401:
					/// Access token expired error will be returned with 401 http status error code
					let requestError = NetworkRequestError(statusCode: 401,
																					description: "Access token expired !!!. Path: \(request.path)")
					DispatchQueue.main.async {
						completionHandler(.failure(requestError))
					}
					
				case 502:
					/// Server down error will be returned with 502 http status error code
					let error = NetworkRequestError(statusCode: 502,
																					description: "Services not available !!! Please contact your admin !!!")
					DispatchQueue.main.async {
						completionHandler(.failure(error))
						//FTVUserDataManager.shared.logout()
					}
					
				case 501:
					/// 501 http status error code
					let error = NetworkRequestError(statusCode: 501,
																					description: "501 Error !!!. Path: \(request.path)")
					DispatchQueue.main.async {
						completionHandler(.failure(error))
					}
					
				case 500:
					/// 500 http status error code
					let error = NetworkRequestError(statusCode: 500,
																					description: "500 Error !!!. Path: \(request.path)")
					DispatchQueue.main.async {
						completionHandler(.failure(error))
					}
					
				case 404:
					/// 404 http status error code
					let error = NetworkRequestError(statusCode: 404,
																					description: "404 Error !!!. Path: \(request.path)")
					DispatchQueue.main.async {
						completionHandler(.failure(error))
					}
					
				default:
					do {
						/// Unknown error will be returned with respective http status error code
						
						let dataObj = try JSONDecoder().decode(ErrorResponse.self, from: data)
						let message = dataObj.message ?? dataObj.status?.msg
						let error = NetworkRequestError(statusCode: httpStatus.statusCode,
																						description: message ?? "\(httpStatus.statusCode) Error. Path: \(request.path)")
						DispatchQueue.main.async {
							completionHandler(.failure(error))
						}
					} catch {
						let error = NetworkRequestError(statusCode: httpStatus.statusCode,
																						description: "\(httpStatus.statusCode) Error. Path: \(request.path)")
						DispatchQueue.main.async {
							completionHandler(.failure(error))
						}
					}
					
				}
				
			} else {
				
				if let finalError = error?.localizedDescription {
					
					var alertMessage = finalError
					
					switch finalError {
					case FTVDomainError.TimeOut.rawValue:
						alertMessage = "Takes too long to load. Refresh in few secs"
						
					default:
						alertMessage = finalError
					}
					
					let error1 = NetworkRequestError(statusCode: 700,
																					description: alertMessage)
					DispatchQueue.main.async {
						completionHandler(.failure(error1))
					}
					
					
				} else {
					
					let errorLocalStr = "Unknown error !!!"
					let error1 = NetworkRequestError(statusCode: 700,
																					description: errorLocalStr)
					DispatchQueue.main.async {
						completionHandler(.failure(error1))
					}
					
				}
				
			}
			
		}.resume()
		
	}
	
}


// MARK: - ErrorStatusResponse
struct ErrorStatusResponse: Codable {
	
	let status: Int?
	let msg: String?
	
	enum CodingKeys: String, CodingKey {
		case status
		case msg
	}
}

struct ErrorResponse: Codable {
	let message: String?
	let status: ErrorStatusResponse?
	
	enum CodingKeys: String, CodingKey {
		case status
		case message
	}
}


extension String {
	
	/// Characters which are alloweed to form url encoded string
	static let formUrlencodedAllowedCharacters =
	CharacterSet(charactersIn: "0123456789" +
							 "abcdefghijklmnopqrstuvwxyz" +
							 "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
							 "-._* ")
	
	/// Forming url encode string with the above characters
	/// - Returns: Returns a url encoded string
	public func formUrlencoded() -> String {
		let encoded = addingPercentEncoding(withAllowedCharacters: String.formUrlencodedAllowedCharacters)
		return encoded?.replacingOccurrences(of: " ", with: "+") ?? ""
	}
}
