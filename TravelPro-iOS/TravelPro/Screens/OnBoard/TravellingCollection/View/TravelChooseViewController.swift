//
//  TravelChooseViewController.swift
//  TravelPro
//
//  Created by Mac-OBS-32 on 17/04/23.
//

import UIKit
import Foundation
class TravelChooseViewController: UIViewController {
    let getAreaOfInterestData = ["Business person","Professional athletes","Environmental professional","Others"]
    
    // MARK: - IBOutlets
    @IBOutlet weak var othersTextfield: UITextField!
    @IBOutlet weak var preferenceCollection: UICollectionView!
    @IBOutlet weak var preferenceCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var totalHeight: NSLayoutConstraint!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var nxtBtn: CustomButton!
    var selectedIndex : [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        othersTextfield.addPlaceholderText(signup_localize.others, color: UIColor(named: "grayText"))
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func registerCells() {
        preferenceCollection.register(UINib(nibName: "PerferenceCell", bundle: nil), forCellWithReuseIdentifier: "PerferenceCell")
        preferenceCollection.delegate = self
        preferenceCollection.dataSource = self
        preferenceCollection.allowsMultipleSelection = false
        self.preferenceCollection.reloadData()
        self.preferenceCollection.layoutIfNeeded()
        preferenceCollectionHeight.constant =  self.preferenceCollection.contentSize.height //self.preferenceCollection.contentSize.height
        //totalHeight.constant = 650 + preferenceCollectionHeight.constant
        self.headerLbl.text = login_page_controller.you_travelling
        self.nxtBtn.setTitle(login_page_controller.next, for: .normal)
    }
    @IBAction func nextButtonAction(_ sender: UIButton) {
        let sign = EmailViewController.loadFromNib()
        sign.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(sign, animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK:- UICollectionView Delegate and Data source
extension TravelChooseViewController: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    // MARK:- collectionViewLayout
    /*
     Adding the size of the collection view cell if it is in list view we are applying the size inside the if condition or if it is a grid view the properties inside the else condition is initilized
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = self.getAreaOfInterestData[indexPath.row]
        let cellWidth = (text.size(withAttributes:[.font: Constant.sharedInstance.regularFont!]).width) + 30.0
        return CGSize(width: cellWidth, height: 40.0)
        
    }
    
    
    // MARK:- numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.getAreaOfInterestData.count
    }
    // MARK:- cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = preferenceCollection.dequeueReusableCell(withReuseIdentifier: "PerferenceCell", for: indexPath) as? PerferenceCell
        cell?.lblPerference.text = self.getAreaOfInterestData[indexPath.row]
        cell?.layer.backgroundColor = UIColor.white.cgColor
        cell?.layer.borderColor = Constant.sharedInstance.borderlineColor.cgColor
        cell?.lblPerference.textColor = Constant.sharedInstance.borderlineColor
        cell?.layer.borderWidth = 1.0
        cell?.layer.cornerRadius = 21
        return cell ?? UICollectionViewCell()
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
}
