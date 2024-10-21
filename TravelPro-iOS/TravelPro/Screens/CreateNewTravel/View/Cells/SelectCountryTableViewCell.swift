//
//  SelectCountryTableViewCell.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 05/05/23.
//

import UIKit

class SelectCountryTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var selectCircleImageView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(_ country:CountryListModel) {
        switch country.isoCode {
        case "0":
            self.countryLabel.text = country.localizedName
        default:
            self.countryLabel.text = country.isoCode.getFlag() + " " + country.localizedName
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)

         if selected {
             self.selectCircleImageView.isHidden = false
         } else {
             self.selectCircleImageView.isHidden = true
         }
     }
    
}
