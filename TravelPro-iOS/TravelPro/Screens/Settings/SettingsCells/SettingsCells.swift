//
//  SettingsCells.swift
//  TravelPro
//
//  Created by VIJAY M on 03/05/23.
//

import UIKit

class SettingsCells: UITableViewCell {
    
    // OUTLET PROPERTIES
    @IBOutlet weak var OptionLbl: UILabel!
    @IBOutlet weak var optionSwitch: UISwitch!
    @IBOutlet weak var detailedOptionBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func configuration(titleString: String, showSwitch: Bool = true, switchOnOff: Bool = true, showOptionBtn: Bool = true, optionBtnTxt: String = "") {
        TravelTaxMixPanelAnalytics(action: .settingsCells, state: .info, data: MixPanelData(message: "SettingsCells - configuration"))
        containerView.layer.borderColor = UIColor(named: "BorderLineWhiteAndGrayColor")?.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 5
        optionSwitch.isHidden = showSwitch
        optionSwitch.isOn = switchOnOff
        detailedOptionBtn.isHidden = showOptionBtn
        detailedOptionBtn.setTitle(optionBtnTxt, for: .normal)
        detailedOptionBtn.setTitle(optionBtnTxt, for: .selected)
        OptionLbl.text = titleString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
