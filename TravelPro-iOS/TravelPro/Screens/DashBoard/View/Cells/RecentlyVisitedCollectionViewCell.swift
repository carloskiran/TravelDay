//
//  RecentlyVisitedCollectionViewCell.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 05/06/23.
//

import UIKit

class RecentlyVisitedCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var totalTaxableDaysLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var physicalPresenceLabel: UILabel!
    @IBOutlet weak var contentViewCustomView: CustomViewShadow!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateUI(_ travelEntity:TravelListEntity?) {
        
        let userdefault = UserDefaults.standard
        let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
        if isDarkMode {
            self.contentViewCustomView.shadowColor = UIColor(named: "grayText")
        }
        
        if let originData = travelEntity?.destination {
            self.countryNameLabel.text = originData.countryName
        }
        self.totalTaxableDaysLabel.text = "\(travelEntity?.taxableDays ?? 0)"
       // self.daysLeftLabel.text = "\(travelEntity?.totalDaysRemaining ?? 0)"
        self.physicalPresenceLabel.text = "\(travelEntity?.totalPhysicalPresenceDays ?? 0)"
    }
}
