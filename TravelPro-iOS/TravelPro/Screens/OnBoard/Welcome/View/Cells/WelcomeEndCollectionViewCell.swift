//
//  WelcomeEndCollectionViewCell.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 11/04/23.
//

import UIKit

// MARK: - WelcomeEndCollectionViewCellDelegate
protocol WelcomeEndCollectionViewCellDelegate: AnyObject {
    func didEndCellTapped()
}

class WelcomeEndCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    weak var delegate: WelcomeEndCollectionViewCellDelegate!


    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - User Interactions
    @IBAction func endCellTapAction(_ sender: Any) {
        self.delegate.didEndCellTapped()
    }
    

}
