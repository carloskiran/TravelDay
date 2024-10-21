//
//  Lib.swift
//  TeleMedicineApp
//
//  Created by MAC-OBS-01 on 09/05/20.
//  Copyright © 2020 optisol. All rights reserved.
//

import UIKit
import Reachability

class Library: NSObject {
    var boolPoorconnection : Bool = Bool()
     
    class  var sharedInstance: Library {
        struct Static {
            static let instance = Library()
        }
        return Static.instance
    }
   
    func isInternetReachable() -> Bool {
//        let reach1: Reachability = (try? Reachability())!
//        if reach1.connection == .wifi || reach1.connection == .cellular {
//            print("Internet avalaible!!!")
//            return true
//        } else {
//            print("Internet NOT avalaible!!!")
            return false
       // }
    }
    
    
    // MARK:- Show Alert
    public func showAlertContinue(_ title: String, message: String,btnTitle: String, btn2Title: String, controller: UIViewController, handler: ((UIAlertAction) -> Void)?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.tabBarItem.badgeColor = UIColor(red: 0/255, green: 197/255, blue: 173/255, alpha: 0.7)
        let ok = UIAlertAction(title: btnTitle, style: .default, handler: handler)
        ac.addAction(ok)
        controller.present(ac, animated: true, completion: nil)
    }
}
 

 
