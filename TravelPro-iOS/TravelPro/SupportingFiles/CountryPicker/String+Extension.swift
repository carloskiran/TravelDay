//
//  String+Extensions.swift
//  CountryPicker
//
//  Created by Samet Macit on 31.12.2020
//  Copyright © 2021 Mobven. All rights reserved.

import Foundation

public extension String {
    /// Returns String unicode value of country flag for iso code
    func getFlag() -> String {
        unicodeScalars
            .map { 127_397 + $0.value }
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
    
    func isValidEmail() -> Bool {
       let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
       return emailTest.evaluate(with: self)
   }
}
