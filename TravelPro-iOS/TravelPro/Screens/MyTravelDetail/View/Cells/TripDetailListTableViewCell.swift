//
//  TripDetailListTableViewCell.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 18/05/23.
//

import UIKit

class TripDetailListTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var fromCountryLabel: UILabel!
    @IBOutlet weak var toCountryLabel: UILabel!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var customizedView: CustomViewShadow!
    @IBOutlet weak var physicalCountLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Update UI
    
    func updateUIData(_ data:CountryListObject?) {
        let userdefault = UserDefaults.standard
        let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
        if isDarkMode {
            self.customizedView.shadowRadius = 0.0
        }
        
        if let countryObject = data {
            if countryObject.origin.isEmpty {
                self.fromCountryLabel.isHidden = true
                self.fromCountryLabel.text = ""
            } else {
                self.fromCountryLabel.isHidden = false
                self.fromCountryLabel.text = countryObject.origin
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
                    
            guard let startDate = dateFormatter.date(from: countryObject.startDate), let endDate = dateFormatter.date(from: countryObject.endDate) else {
                return
            }
            
            dateFormatter.dateFormat = "MMM d, yyyy"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
            let formattedStartDate1 = dateFormatter.string(from: startDate)
            let formattedStartDate2 = dateFormatter.string(from: endDate)
            
            self.toCountryLabel.text = countryObject.destination
            self.fromDateLabel.text = formattedStartDate1
            self.toDateLabel.text = formattedStartDate2
            self.physicalCountLabel.text = "\(countryObject.physicalPresenceDays)"
            self.createdByLabel.text = countryObject.createdBy
//            self.departureTime.text = countryObject.startDate.timeStampAndDate()
//            self.destinationTime.text = countryObject.endDate.timeStampAndDate()
        }
        
    }
    
}
