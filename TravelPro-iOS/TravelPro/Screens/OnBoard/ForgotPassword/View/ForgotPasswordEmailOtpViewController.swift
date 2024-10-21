//
//  ForgotPasswordEmailOtpViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 17/04/23.
//

import UIKit

class ForgotPasswordEmailOtpViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - IBOutlets

    // MARK: - View life cycle
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: - Private methods
    
    // MARK: - User interactions
   
    @IBAction func okAction(_ sender: Any) {
        let signup = ForgotPasswordMobileOtpViewController.loadFromNib()
        self.navigationController?.pushViewController(signup, animated: true)
    }
    
}
