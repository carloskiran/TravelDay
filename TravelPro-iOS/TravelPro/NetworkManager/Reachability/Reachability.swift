

import Foundation
import SystemConfiguration
import Network

/// delay
/// - Parameters:
///   - interval: TimeInterval
///   - closure: Void
public func delay(interval: TimeInterval, closure: @escaping () -> Void) {
	DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
		closure()
	}
}

public class Reachability {
	
	public class func isConnectedToNetwork() -> Bool {
		
		var zeroAddress = sockaddr_in(sin_len: 0,
																	sin_family: 0,
																	sin_port: 0,
																	sin_addr: in_addr(s_addr: 0),
																	sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
		zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
		zeroAddress.sin_family = sa_family_t(AF_INET)
		
		let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
				SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
			}
		}
		
		var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
		if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
			return false
		}
		
		let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
		let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
		let ret = (isReachable && !needsConnection)
		
		return ret
		
	}
}


public class NetworkMonitor: NSObject {
	
		let monitor = NWPathMonitor()
		private var status: NWPath.Status = .requiresConnection
	  private var isNotificationTriggered = true
	
		var isReachable: Bool { status == .satisfied }
		var isReachableOnCellular: Bool = true

	func startMonitoring() {
		
		monitor.pathUpdateHandler = { path in
			self.status = path.status
			self.isReachableOnCellular = path.isExpensive
			
			if path.status == .satisfied {
				
				guard !self.isNotificationTriggered else {
					return
				}
				NotificationCenter.default.post(name: Notification.Name("NetworkAvailable"), object: nil)
				self.isNotificationTriggered = true
				self.stopMonitoring()
				
			} else {
				self.isNotificationTriggered = false
				
			}
			print(path.isExpensive)
		}
		
		let queue = DispatchQueue(label: "NetworkMonitor")
		monitor.start(queue: queue)
	}

		func stopMonitoring() {
				monitor.cancel()
		}
}
