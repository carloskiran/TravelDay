

import Foundation

public struct TPAppInfo {
	
	var appName : String {
		return readFromInfoPlist(withKey: "CFBundleName") ?? "(unknown app name)"
	}
	
	var version : String {
		return readFromInfoPlist(withKey: "CFBundleShortVersionString") ?? "(unknown app version)"
	}
	
	var build : String {
		return readFromInfoPlist(withKey: "CFBundleVersion") ?? "(unknown build number)"
	}
	
	var minimumOSVersion : String {
		return readFromInfoPlist(withKey: "MinimumOSVersion") ?? "(unknown minimum OSVersion)"
	}
	
	var copyrightNotice : String {
		return readFromInfoPlist(withKey: "NSHumanReadableCopyright") ?? "(unknown copyright notice)"
	}
	
	var bundleIdentifier : String {
		return readFromInfoPlist(withKey: "CFBundleIdentifier") ?? "(unknown bundle identifier)"
	}
	
	var uuid: String {
		return UUID().uuidString
	}
		
	/// lets hold a reference to the Info.plist of the app as Dictionary
	private let infoPlistDictionary = Bundle.main.infoDictionary
	
	/// Retrieves and returns associated values (of Type String) from info.Plist of the app.
	private func readFromInfoPlist(withKey key: String) -> String? {
		return infoPlistDictionary?[key] as? String
	}
	
}

