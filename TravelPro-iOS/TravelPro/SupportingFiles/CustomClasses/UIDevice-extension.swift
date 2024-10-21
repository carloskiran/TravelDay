
import Foundation
import UIKit

extension UIDevice {
    public var modelName: String {
        #if targetEnvironment(simulator)
            let deviceIsSimulator = true
        #else
            let deviceIsSimulator = false
        #endif

        var machineString: String = ""

        if deviceIsSimulator {
            if let dir = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                machineString = dir
            }
        } else {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            machineString = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
        }
        switch machineString {
        case "iPod5,1": return "iPod Touch 5"
        case "iPod7,1": return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
        case "iPhone4,1": return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2": return "iPhone 5"
        case "iPhone5,3", "iPhone5,4": return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2": return "iPhone 5s"
        case "iPhone7,2": return "iPhone 6"
        case "iPhone7,1": return "iPhone 6 Plus"
        case "iPhone8,1": return "iPhone 6s"
        case "iPhone8,2": return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3": return "iPhone 7"
        case "iPhone9,2", "iPhone9,4": return "iPhone 7 Plus"
        case "iPhone8,4": return "iPhone SE"
        case "iPhone10,1", "iPhone10,4": return "iPhone 8"
        case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6": return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
        case "iPad5,3", "iPad5,4": return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad Mini 3"
        case "iPad5,1", "iPad5,2": return "iPad Mini 4"
        case "iPad6,3", "iPad6,4": return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8": return "iPad Pro (12.9-inch) (1st generation)"
        case "iPad7,1", "iPad7,2": return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
        case "iPad8,9", "iPad8,10": return "iPad Pro (11-inch) (2nd generation)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
        case "iPad8,11", "iPad8,12": return "iPad Pro (12.9-inch) (4th generation)"
        case "iPad7,3", "iPad7,4": return "iPad Pro 10.5 Inch"
        case "AppleTV5,3": return "Apple TV"
        default: return machineString
        }
    }

    public var deviceIOSVersion: String {
        return UIDevice.current.systemVersion
    }

    public var deviceScreenWidth: CGFloat {
        let screenSize: CGRect = UIScreen.main.bounds
        let width = screenSize.width
        return width
    }

    public var deviceScreenHeight: CGFloat {
        let screenSize: CGRect = UIScreen.main.bounds
        let height = screenSize.height
        return height
    }
    
    public var iPad11inch: Bool {
        switch UIDevice.current.modelName {
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4", "iPad8,9", "iPad8,10":
            return true
        default: break
        }
        return false
    }

    public var iPad12inch: Bool {
        switch UIDevice.current.modelName {
        case "iPad6,7", "iPad6,8", "iPad7,1", "iPad7,2", "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8", "iPad8,11", "iPad8,12":
            return true
        default: break
        }
        return false
    }
    
    public var lessIphone5S: Bool {
        switch UIDevice.current.modelName {
        case "iPhone 4", "iPhone 4s", "iPhone 5", "iPhone 5c", "iPhone 5s", "iPhone SE":
            return true
        default: break
        }
        return false
    }

    public var iphone6: Bool {
        switch UIDevice.current.modelName {
        case "iPhone 6", "iPhone 6s":
            return true
        default: break
        }
        return false
    }

    public var iphone6Plus: Bool {
        switch UIDevice.current.modelName {
        case "iPhone 6 Plus":
            return true
        default: break
        }
        return false
    }

    public var iphone6sPlus: Bool {
        switch UIDevice.current.modelName {
        case "iPhone 6s Plus":
            return true
        default: break
        }
        return false
    }

    public var iphone7: Bool {
        switch UIDevice.current.modelName {
        case "iPhone 7":
            return true
        default: break
        }
        return false
    }

    public var iphone7Plus: Bool {
        switch UIDevice.current.modelName {
        case "iPhone 7 Plus":
            return true
        default: break
        }
        return false
    }

    public var iphone8: Bool {
        switch UIDevice.current.modelName {
        case "iPhone 8":
            return true
        default: break
        }
        return false
    }

    public var iphone8Plus: Bool {
        switch UIDevice.current.modelName {
        case "iPhone 8 Plus":
            return true
        default: break
        }
        return false
    }

    public var iphoneSE2: Bool {
        switch UIDevice.current.modelName {
        case "iPhone12,8":
            return true
        default: break
        }
        return false
    }

    public var iphoneMedSeries: Bool {
        switch UIDevice.current.modelName {
        case "iPhone 6", "iPhone 6s", "iPhone 7", "iPhone 8", "iPhone12,8":
            return true
        default: break
        }
        return false
    }

    public var iphonePlusSeries: Bool {
        switch UIDevice.current.modelName {
        case "iPhone 6 Plus", "iPhone 6s Plus", "iPhone 7 Plus", "iPhone 8 Plus":
            return true
        default: break
        }
        return false
    }

    public var iPhoneXrSeries: Bool {
        switch UIDevice.current.modelName {
        case "iPhone11,8":
            return true
        default: break
        }
        return false
    }

    public var iPhoneXSeries: Bool {
        switch UIDevice.current.modelName {
        case "iPhone X", "iPhone11,2", "iPhone11,4", "iPhone11,8":
            return true
        default: break
        }
        return false
    }

    public var iPhoneX: Bool {
        switch UIDevice.current.modelName {
        case "iPhone X", "iPhone10,3", "iPhone10,6":
            return true
        default: break
        }
        return false
    }

    public var iPhoneXs: Bool {
        switch UIDevice.current.modelName {
        case "iPhone11,2":
            return true
        default: break
        }
        return false
    }

    public var iPhoneXsMax: Bool {
        switch UIDevice.current.modelName {
        case "iPhone11,4", "iPhone11,6":
            return true
        default: break
        }
        return false
    }

    public var iPhone11Series: Bool {
        switch UIDevice.current.modelName {
        case "iPhone12,5", "iPhone12,3", "iPhone12,1":
            return true
        default: break
        }
        return false
    }

    public var iphone11: Bool {
        switch UIDevice.current.modelName {
        case "iPhone12,1":
            return true
        default: break
        }
        return false
    }

    public var iphone11Pro: Bool {
        switch UIDevice.current.modelName {
        case "iPhone12,3":
            return true
        default: break
        }
        return false
    }

    public var iphone11ProMax: Bool {
        switch UIDevice.current.modelName {
        case "iPhone12,5":
            return true
        default: break
        }
        return false
    }

    public var iPhone12Series: Bool {
        switch UIDevice.current.modelName {
        case "iPhone13,1", "iPhone13,2", "iPhone13,3", "iPhone13,4":
            return true
        default: break
        }
        return false
    }

    public var iphone12: Bool {
        switch UIDevice.current.modelName {
        case "iPhone13,2":
            return true
        default: break
        }
        return false
    }

    public var iphone12Mini: Bool {
        switch UIDevice.current.modelName {
        case "iPhone13,1":
            return true
        default: break
        }
        return false
    }

    public var iphone12Pro: Bool {
        switch UIDevice.current.modelName {
        case "iPhone13,3":
            return true
        default: break
        }
        return false
    }

    public var deviceOrientationString: String {
        var orientation: String
        switch UIDevice.current.orientation {
        case .portrait:
            orientation = "Portrait"
        case .portraitUpsideDown:
            orientation = "Portrait Upside Down"
        case .landscapeLeft:
            orientation = "Landscape Left"
        case .landscapeRight:
            orientation = "Landscape Right"
        case .faceUp:
            orientation = "Face Up"
        case .faceDown:
            orientation = "Face Down"
        default:
            orientation = "Unknown"
        }
        return orientation
    }

    //  Landscape Portrait
    public var isDevicePortrait: Bool {
        return UIDevice.current.orientation.isPortrait
    }

    public var isDeviceLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }
}
