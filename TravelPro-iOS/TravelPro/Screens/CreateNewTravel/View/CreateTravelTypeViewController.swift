//
//  CreateTravelTypeViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 31/05/23.
//

import UIKit

class CreateTravelTypeViewController: UIViewController {
    
    // MARK: - Properties
    var travelType:SelectTravelType = .none
   
    // MARK: - IBOutlets

    @IBOutlet weak var newTravelView: UIView!
    @IBOutlet weak var missingTravelView: UIView!
    @IBOutlet weak var newTravelSelectImageView: UIImageView!
    @IBOutlet weak var missingTravelSelectImageView: UIImageView!


    // MARK: - View life cycle
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        TravelTaxMixPanelAnalytics(action: .createTravelType, state: .info, data: MixPanelData(message: "CreateTravelTypeViewController - viewWillAppear"))
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        TravelTaxMixPanelAnalytics(action: .createTravelType, state: .info, data: MixPanelData(message: "CreateTravelTypeViewController - viewDidDisappear"))
        self.travelType = .none
    }
   
    // MARK: - User Interation
    @IBAction func segmentButtonAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .createTravelType, state: .info, data: MixPanelData(message: "CreateTravelTypeViewController - segmentButtonAction"))
        switch sender.tag {
        case 2:
            travelType = .missing
            self.newTravelSelectImageView.isHidden = true
            self.missingTravelSelectImageView.isHidden = false
            self.newTravelView.backgroundColor = UIColor.clear
            self.missingTravelView.backgroundColor = UIColor(named: "WhiteAndDarkblue")
            
        default:
            travelType = .new
            self.newTravelSelectImageView.isHidden = false
            self.missingTravelSelectImageView.isHidden = true
            self.newTravelView.backgroundColor = UIColor(named: "WhiteAndDarkblue")
            self.missingTravelView.backgroundColor = UIColor.clear
           
        }
    }
    
    @IBAction func proceedButtonAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .createTravelType, state: .info, data: MixPanelData(message: "CreateTravelTypeViewController - proceedButtonAction"))
        switch self.travelType {
        case .missing:
            let missing = CreateMissingTravelViewController.loadFromNib()
            missing.modalPresentationStyle = .pageSheet
            if let sheet = missing.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            self.present(missing, animated: true)
        case .new:
            let new = CreateNewTravelViewController.loadFromNib()
            new.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(new, animated: true)
            
        default:
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select travel option to create", image: nil,theme: .default)
        }
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        TravelTaxMixPanelAnalytics(action: .createTravelType, state: .info, data: MixPanelData(message: "CreateTravelTypeViewController - setupUI"))
        self.newTravelSelectImageView.isHidden = true
        self.missingTravelSelectImageView.isHidden = true
        self.newTravelView.backgroundColor = UIColor.clear
        self.missingTravelView.backgroundColor = UIColor.clear
    }

}

//MARK: - Enum

enum SelectTravelType:String {
    case new
    case missing
    case none
}
