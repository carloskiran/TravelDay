//
//  UpcomingScheduleTableViewCell.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 06/06/23.
//

import UIKit

class UpcomingScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var totalTaxableLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var presenceDaysLabel: UILabel!
    @IBOutlet weak var travelDateLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var contentCustomView: CustomViewShadow!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(_ travelEntity:TravelListEntity?) {
        
        let userdefault = UserDefaults.standard
        let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
        if isDarkMode {
            self.contentCustomView.shadowColor = UIColor(named: "grayText")
        }
        
        if let destination = travelEntity?.origin {
            self.countryLabel.text = destination.countryName
            self.toLabel.text = destination.countryName
        }
        
        if let originData = travelEntity?.origin {
            self.fromLabel.text = originData.countryName
        }
        self.totalTaxableLabel.text = "\(travelEntity?.workDays ?? 0)"
        self.daysLeftLabel.text = "\(travelEntity?.totalDaysRemaining ?? 0)"
        self.presenceDaysLabel.text = "\(travelEntity?.numberOfTaxDaysUsed ?? 0)"
        self.travelDateLabel.text = travelEntity?.startDate?.timeStampStringDate()

    }
    
}
