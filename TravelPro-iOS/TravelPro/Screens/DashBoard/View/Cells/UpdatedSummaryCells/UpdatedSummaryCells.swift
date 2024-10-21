//
//  UpdatedSummaryCells.swift
//  TravelPro
//
//  Created by VIJAY M on 23/06/23.
//

import UIKit

class UpdatedSummaryCells: UITableViewCell {
    
    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var daysLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configuration(countryName: String, days: String) {
        self.countryNameLbl.text = countryName
        self.daysLbl.text = days
    }
    
}
