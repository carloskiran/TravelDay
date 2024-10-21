
import UIKit

class Languagehandler:NSObject {

    static let shared = Languagehandler()
    
    /// SaveLanguage
    /// - Parameter languageName: languages
    func saveLanguage( languageName:languages) {
        UserDefaults.standard.set(languageName.rawValue, forKey: "LanguageName")
        UserDefaults.standard.synchronize()
    }
    
    /// GetCurrentLanguage
    /// - Returns: String
    func getCurrentLanguage() -> String {
        guard let currentLanguage = UserDefaults.standard.object(forKey: "LanguageName") as? String else { return "en" }
        return currentLanguage
    }
}

extension String {
    /// LocalizeString
    /// - Parameter string: String
    func localized() -> String {
        let path = Bundle.main.path(forResource: Languagehandler.shared.getCurrentLanguage(), ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}


/// Languages
enum languages:String {
    case english = "en"
    case enligh_uk = "en-GB"
    case french = "fr"
}
