

import Foundation
import Photos
import UIKit
var imageData: Data?
class utilsClass: NSObject {
   
    static let sharedInstance = utilsClass()

    func NotificatonAlertMessage(title : String , subTitle: String , body : String , image : UIImage?, theme : NotificationViewTheme) {
    let notificationView = NotificationView(title, subtitle: subTitle, body: body, image: image)
        notificationView.isHeader = false
        notificationView.hideDuration = 2.0
        notificationView.theme = theme
        notificationView.show { (state) in
          //  print("callback: \(state)")
        }
    }
    func DebugPrint(strLog : Any) {
        debugPrint(strLog)
    }
    func checkNullvalueInt(passedValue:Any?) -> Int {
        var param:Any?=passedValue
        if(param == nil || param is NSNull)
        {
            param=""
        } else {
            param = passedValue
        }
        return (param as? Int) ?? 0
    }
    func checkNullvalue(passedValue:Any?) -> String {
        var param:Any?=passedValue
        if(param == nil || param is NSNull)
        {
            param=""
        } else {
            param = String(describing: passedValue!)
        }
        return (param as? String)!
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    func isValidPassword(password: String) -> Bool {
        let regularExpression = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{6,}$"
        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        return passwordValidation.evaluate(with: password)
    }
    
    func debugprint(message :Any) {
        debugPrint(message)
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }
        var tempDate = from
        var array = [tempDate]
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
    
    func setTheme(){
        guard let appDelegate = UIApplication.shared.delegate else { return }
        let userdefault = UserDefaults.standard
        let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
        appDelegate.window!?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    }
    
}
extension String {
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
    func multipleStringAndFont(firstString: String, firstTextColor: UIColor, secondString: String, secondTextColor: UIColor, firstTextFont: UIFont, secondTextFont: UIFont) -> NSMutableAttributedString {
        let yourAttributes = [NSAttributedString.Key.foregroundColor: firstTextColor, NSAttributedString.Key.font: firstTextFont]
        let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: secondTextColor, NSAttributedString.Key.font: secondTextFont]
        
        let partOne = NSMutableAttributedString(string: "\(firstString) ", attributes: yourAttributes as [NSAttributedString.Key : Any])
        let partTwo = NSMutableAttributedString(string: secondString, attributes: yourOtherAttributes as [NSAttributedString.Key : Any])
        
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        

        
        return combination
    }
        
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        formatter.timeZone = .current
        return formatter.date(from: self)
    }
    
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self) // replace Date String
    }
    
    func singleConvertDateFormat() -> String {
        
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000+00:00"
        olDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let oldDate = olDateFormatter.date(from: self) ?? Date()
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "MMM dd, yyyy"
        convertDateFormatter.timeZone = TimeZone.current
        return convertDateFormatter.string(from: oldDate)
        
    }
    
    func timeStampAndDate() -> (String) {
        
        let localTimeZone = NSTimeZone.local
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        let startDateString = self
        
        guard let startDate = dateFormatter.date(from: startDateString) else {
            // Handle parsing errors if necessary
            return ""
        }
        dateFormatter.timeZone = localTimeZone
        
        // Format 1: "Mar 24, 2023"
        dateFormatter.dateFormat = "MMM d, yyyy"
        let _ = dateFormatter.string(from: startDate)

        // Format 2: "08:30"
        dateFormatter.dateFormat = "HH:mm"
        let formattedStartDate2 = dateFormatter.string(from: startDate)
        
        return formattedStartDate2
    }
    
    func timeStampStringDate() -> String {
        
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        olDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let oldDate = olDateFormatter.date(from: self) ?? Date()
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "MMM dd, yyyy"
        convertDateFormatter.timeZone = TimeZone.current
        return convertDateFormatter.string(from: oldDate)
    }
    
    func generalDateConversion() -> String {
//        let timestamp = self
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//
//        if let date = dateFormatter.date(from: timestamp) {
//            let outputDateFormatter = DateFormatter()
//            outputDateFormatter.dateFormat = "MMM dd, yyyy"
//            outputDateFormatter.timeZone = TimeZone.current
//
//            let formattedDate = outputDateFormatter.string(from: date)
//            print(formattedDate) // Output: "Jan 01, 2023"
//            return formattedDate
//        }
//        return ""
        
        let inputDateFormats = ["yyyy-MM-dd'T'HH:mm:ss.SSSX", "yyyy-MM-dd'T'HH:mm:ss.SSSS"]

        let outputDateFormatter = DateFormatter()
        outputDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputDateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        outputDateFormatter.dateFormat = "MMM d, yyyy"
        var date: Date?
        for format in inputDateFormats {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
            if let parsedDate = dateFormatter.date(from: self) {
                date = parsedDate
                break
            }
        }
        if let date = date {
            let outputDateString = outputDateFormatter.string(from: date)
            print(outputDateString) // Output: "Jan 1, 2023"
            return outputDateString
        } else {
            print("Failed to parse date")
            return ""
        }
    }
    
    func settingsTimeStampStringDate() -> String {
        
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        olDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let oldDate = olDateFormatter.date(from: self) ?? Date()
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "MMM dd, yyyy"
        convertDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        return convertDateFormatter.string(from: oldDate)
    }
    
    func settingsTimeStampWithoutTimeZoneStringDate() -> String {
        
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        olDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        olDateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        let oldDate = olDateFormatter.date(from: self) ?? Date()
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "MMM dd, yyyy"
        convertDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        convertDateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        return convertDateFormatter.string(from: oldDate)
    }
    
    func timeStampDateFormat() -> Date {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        olDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let oldDate = olDateFormatter.date(from: self)
        return oldDate ?? Date()
    }
    
    func timeStampDateWithMilliseconds() -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        olDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let oldDate = olDateFormatter.date(from: self) ?? Date()
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
        convertDateFormatter.timeZone = TimeZone.current
        return convertDateFormatter.string(from: oldDate)
    }
    
    func timeStampWithoutUtcConversion() -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let oldDate = olDateFormatter.date(from: self) ?? Date()
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
        return convertDateFormatter.string(from: oldDate)
    }
    
    func convertToDateFormate(current: String, convertTo: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = current
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        dateFormatter.dateFormat = convertTo
        return  dateFormatter.string(from: date)
    }
    
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
}


extension NSMutableAttributedString {
    var fontSize:CGFloat { return 26 }
    var boldFont:UIFont { return UIFont(name: "HelveticaNeue-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "HelveticaNeue-Light", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func blackHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}

class UserLocationSetting:NSObject {
    
    static let sharedInstance = UserLocationSetting()
    
    var isLocationAccessDenied:Bool = false
    
}
