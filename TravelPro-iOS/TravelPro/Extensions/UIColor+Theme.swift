//
//  UIColor+Theme.swift
//  MVVMSwiftExample
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit


extension UIColor {
    
    // MARK: Private
    
    // MARK: Private
    fileprivate static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    fileprivate static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return rgba(r, g, b, 1.0)
    }
    
    // MARK: Public
    
    static let borderColor = rgb(254, 250, 236)
    static let backgroundColor = rgb(67, 73, 110)
    static let scoreColor = rgb(255, 193, 45)
    static let textColor = UIColor.white
    static let playerBackgroundColor = rgb(84, 77, 126)
    static let brightPlayerBackgroundColor = rgba(101, 88, 156, 0.5)
    static let headingWhiteText = UIColor(named: "headingWhiteText")!
    static let headingGrayColor = UIColor(named: "HeadingGrayColor")!
    static let headingText = UIColor(named: "headingText")!
    static let progressBarStartGradientColor = UIColor(named: "ProgressBarStartGradientColor")!
    static let progressBarStopGradientColor = UIColor(named: "ProgressBarStopGradientColor")!
    static let attachmentGreenColor = UIColor(named: "btnLoginColor")!
    static let profileProgressTrackColor = rgba(241, 250, 254, 1.0)
    static let profileProgressStartColor = rgba(32, 61, 131, 1.0)
    static let profileProgressEndColor = rgba(9, 123, 191, 1.0)
    static let dayProgressTrackColor = rgba(237, 239, 244, 1.0)
    static let WorkDayProgressColor = rgba(52, 169, 206, 1.0)
    static let nonWorkDayProgressColor = rgba(227, 105, 61, 1.0)
    static let physicalDayProgressColor = rgba(32, 61, 131, 1.0)
    static let tabbarSelectedTitleColor = rgba(27, 170, 76, 1.0)
    static let tabbarUnselectedTitleColor = rgba(108, 123, 138, 1.0)
    
    static let residentColor = rgba(27, 170, 76, 0.15)
    static let nonResidentColor = rgba(32, 61, 131, 0.15)
    static let nonResidentWithAlphaColor = rgba(32, 61, 131, 1.0)



}
extension UIColor {

    /// Coverting the hex string color code into 12 or 24 or 32 bit rgb color code
    /// - Parameter hexString: Hex color code string
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let aValue, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (aValue, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (aValue, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (aValue, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (aValue, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(red) / 255,
                  green: CGFloat(green) / 255,
                  blue: CGFloat(blue) / 255,
                  alpha: CGFloat(aValue) / 255)
    }
}
