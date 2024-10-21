//
//  NotificationCell.swift
//  OneSelf
//
//  Created by Laptop-OBS-36 on 01/08/22.
//

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var OuterView: UIVisualEffectView!
    @IBOutlet weak var doticonView: UIImageView!
    
    @IBOutlet weak var highLightLbl: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var startedNotStartedImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configuration(indexValue: IndexPath, responseCount: Int) {
        if indexValue.row == 0 {
            if responseCount > 1 {
                let path = UIBezierPath(roundedRect: self.cellView.frame, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
                
                let maskLayer = CAShapeLayer()
                
                maskLayer.path = path.cgPath
                self.cellView.layer.mask = maskLayer
                self.updateFocusIfNeeded()
            } else {
                self.cellView.layer.cornerRadius = 10
            }
        } else if indexValue.row == (responseCount-1) {
                let path = UIBezierPath(roundedRect: self.cellView.frame, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
                
                let maskLayer = CAShapeLayer()
                
                maskLayer.path = path.cgPath
            self.cellView.layer.mask = maskLayer
            self.updateFocusIfNeeded()
        } else {
            self.cellView.layer.cornerRadius = 0
        }
    }
    
    func setupUI() {
        bgView.layer.cornerRadius = 10
        OuterView.layer.cornerRadius = 10
        OuterView.clipsToBounds = true
        highLightLbl.layer.cornerRadius =  highLightLbl.frame.size.width/2
        highLightLbl.layer.masksToBounds = true
        doticonView.layer.cornerRadius = doticonView.frame.size.width/2
        doticonView.layer.masksToBounds = true
        doticonView.clipsToBounds = true
//        cellView.layer.cornerRadius = 10
        cellView.layer.masksToBounds = true
    }
}
