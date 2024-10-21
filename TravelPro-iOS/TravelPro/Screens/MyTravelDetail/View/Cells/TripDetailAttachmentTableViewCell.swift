//
//  TripDetailAttachmentTableViewCell.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 18/05/23.
//

import UIKit

class TripDetailAttachmentTableViewCell: UITableViewCell {

    @IBOutlet weak var fileNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(_ fileName:String) {
        fileNameLabel.text = fileName
    }
    
}
