//
//  MyTravelListTableViewCell.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 17/05/23.
//

import UIKit

class MyTravelListTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var residentView: CustomView!
    @IBOutlet weak var residentLabel: UILabel!
    @IBOutlet weak var progressBarView: UIProgressView!
    @IBOutlet weak var taxableDaysCompletedLabel: UILabel!
    @IBOutlet weak var totalDaysLabel: UILabel!
    @IBOutlet weak var workDayLabel: UILabel!
    @IBOutlet weak var nonWorkDayLabel: UILabel!
    @IBOutlet weak var physicalPresenceLabel: UILabel!
    
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(_ travelEntity:TravelListEntity?) {
        
        let countryName = (travelEntity?.destination?.countryName ?? "") == "N/A" ? (travelEntity?.origin?.countryName ?? "") : (travelEntity?.destination?.countryName ?? "")
        
        
//        if let originData = travelEntity?.origin {
            self.countryNameLabel.text = countryName
//        }
        self.totalDaysLabel.text = "\(travelEntity?.taxableDays ?? 0)"
     //   self.taxableDaysCompletedLabel.text = "Taxable Days Completed \(travelEntity?.numberOfTaxDaysUsed ?? 0) / \(travelEntity?.numberOfTaxDaysLeft ?? 0) Left"
        var progress = Float((travelEntity?.totalDays ?? 0)) / Float((travelEntity?.totalDaysCompleted ?? 0))
        if travelEntity?.totalDays ?? 0 == 0 || travelEntity?.totalDaysCompleted ?? 0 == 0 {
            progress = 0.0
        }
//        let progress = Float((travelEntity?.totalDays ?? 0)) / 50.0
        print(">>>> travelEntity?.totalDays ?? 0 :\(travelEntity?.totalDays ?? 0) and travelEntity?.totalDaysCompleted ?? 0 :\((travelEntity?.totalDaysCompleted ?? 0)) and progress: \(progress)")
        DispatchQueue.main.async {
           // self.updateProgressBar(progress)
        }
        updateResident(travelEntity?.resident ?? false)
//        self.workDayLabel.text = "\(travelEntity?.workDays ?? 0)"
       // self.nonWorkDayLabel.text = "\(travelEntity?.totalNonWorkDays ?? 0)"
        self.physicalPresenceLabel.text = "\(travelEntity?.totalPhysicalPresenceDays ?? 0)"
    }
    
    private func updateProgressBar(_ value:Float) {
        self.progressBarView.setProgress(value, animated: true)
    }
    
    private func updateResident(_ isResident:Bool) {
        switch isResident {
        case false:
            self.residentLabel.text = "Non-Resident"
            self.residentLabel.textColor = UIColor(named: "BlueAndWhiteColor")
            self.residentView.backgroundColor = UIColor(named: "nonresidentBg")
          
        default:
            self.residentLabel.text = "Resident"
            self.residentLabel.textColor = UIColor(named: "greenWhite")
            self.residentView.backgroundColor = UIColor(named: "residentBg")
        }
    }
    
}
