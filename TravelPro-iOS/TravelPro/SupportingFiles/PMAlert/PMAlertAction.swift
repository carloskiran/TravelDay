//
//  PMAlertAction.swift
//  PMAlertController
//
//  Created by Paolo Musolino on 07/05/16.
//  Copyright © 2018 Codeido. All rights reserved.
//

import UIKit

@objc public enum PMAlertActionStyle : Int {
    
    case `default`
    case cancel
}

@objc open class PMAlertAction: UIButton {
    
    fileprivate var action: (() -> Void)?
    
    open var actionStyle : PMAlertActionStyle
    
    open var separator = UIImageView()
    
    init(){
        self.actionStyle = .cancel
        super.init(frame: CGRect.zero)
       
    }
    
    @objc public convenience init(title: String?, style: PMAlertActionStyle, backgroundColor : UIColor, buttonTitleColor : UIColor, action: (() -> Void)? = nil){
        self.init()
        
        self.action = action
        self.addTarget(self, action: #selector(PMAlertAction.tapped(_:)), for: .touchUpInside)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: UIControl.State())
        self.titleLabel?.font = Constant.sharedInstance.regularFont
        self.actionStyle = style
        //rgba(14, 99, 252, 1)
        style == .default ? (self.setTitleColor(buttonTitleColor, for: UIControl.State())) : (self.setTitleColor(buttonTitleColor, for: UIControl.State()))
        
        self.addSeparator()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapped(_ sender: PMAlertAction) {
        //Action need to be fired after alert dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.action?()
        }
    }
    
    @objc fileprivate func addSeparator(){
        separator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        self.addSubview(separator)
        
        // Autolayout separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        separator.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 8).isActive = true
        separator.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: -8).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
}
