//
//  LoginViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 04/04/23.
//

import UIKit

class WelcomeLandingViewController: UIViewController,LTMorphingLabelDelegate {
    
    
    // MARK: - Properties
    
    // MARK: - IBOutlets
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var appNameLbl: LTMorphingLabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var loginBtn: CustomButton!
    @IBOutlet weak var signupBtn: CustomButton!
    
    // MARK: - View life cycle
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        configuration()
    }
    
    // MARK: - Private methods
    func configuration() {
        TravelTaxMixPanelAnalytics(action: .welcome, state: .info, data: MixPanelData(message: "WelcomeLandingViewController - configuration"))

        appNameLbl.text = "DayTaxDayTravel"
        appNameLbl.delegate = self
        welcomeLbl.text = welcome_landing_controller.welcom_to
        appNameLbl.text = welcome_landing_controller.app_name
        descLbl.text = welcome_landing_controller.app_desc
        welcomeLbl.animate(newText: welcome_landing_controller.welcom_to)
        loginBtn.setTitle(welcome_landing_controller.login, for: .normal)
        signupBtn.setTitle(welcome_landing_controller.register, for: .normal)
        appNameLbl!.morphingEnabled = false
        appNameLbl!.delegate = self
        appNameLbl!.morphingEffect = .anvil
        appNameLbl!.text = welcome_landing_controller.app_name
        appNameLbl!.textAlignment = .center
        appNameLbl!.font = UIFont.fontB40
        appNameLbl!.morphingEnabled = true
        appNameLbl.start()
    }
    
    // MARK: - User interactions
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .welcome, state: .info, data: MixPanelData(message: "WelcomeLandingViewController - loginButtonAction"))
        let sign = LoginViewController.loadFromNib()
        sign.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(sign, animated: true)
    }
    
   
    @IBAction func signupButtonAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .welcome, state: .info, data: MixPanelData(message: "WelcomeLandingViewController - signupButtonAction"))
        let sign = SignUpViewController.loadFromNib()
        sign.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(sign, animated: true)
    }
    // MARK: - Network requests

}
extension WelcomeLandingViewController {
    
    func morphingDidStart(_ label: LTMorphingLabel) {
        
    }
    
    func morphingDidComplete(_ label: LTMorphingLabel) {
        
    }
    
    func morphingOnProgress(_ label: LTMorphingLabel, progress: Float) {
        
    }
    
}
