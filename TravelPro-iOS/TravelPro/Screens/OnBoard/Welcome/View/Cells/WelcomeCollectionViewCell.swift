//
//  WelcomeCollectionViewCell.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 10/04/23.
//

import UIKit

class WelcomeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var splashLabel: UILabel!
    @IBOutlet weak var splashDescriptionLabel: UILabel!

    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// UpdateData
    /// - Parameters:
    ///   - splashImage: String
    ///   - splashText: String
    ///   - splashDescText: String
    func updateData(_ splashImage:String, _ splashText:String, _ splashDescText:String) {
        self.imageView.image = UIImage(named:splashImage)
        self.splashLabel.text = splashText.localized()
        self.splashDescriptionLabel.text = splashDescText
    }
    

}
