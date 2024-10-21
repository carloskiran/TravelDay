//
//  NotificationEnlargementView.swift
//  TravelPro
//
//  Created by VIJAY M on 14/06/23.
//

import UIKit

class NotificationEnlargementView: UIViewController {

    @IBOutlet weak var scrollContentHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var notificationDetailsLbl: UILabel!
    @IBOutlet weak var coverView: UIView!
    
    var descriptionString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        notificationDetailsLbl.font = .fontR14
        notificationDetailsLbl.text = descriptionString
        self.coverView.layer.cornerRadius = 10
        self.coverView.layer.masksToBounds = true
        self.coverView.clipsToBounds = true
        if notificationDetailsLbl.text != "" {
            let height = calculateLabelHeight(text: self.notificationDetailsLbl.text ?? "", font: .fontR14, width: self.notificationDetailsLbl.frame.width)
            scrollContentHeightConstraints.constant = height+100
        }
    }
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func calculateLabelHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label = UILabel()
        label.font = font
        label.numberOfLines = 0
        label.text = text
        
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let boundingRect = NSString(string: text).boundingRect(with: maxSize, options: options, attributes: attributes, context: nil)
        
        return ceil(boundingRect.height)
    }
    
}
