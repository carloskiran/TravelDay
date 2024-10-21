//
//  WelcomeViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 04/04/23.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageIndicationImageViewOne: UIImageView!
    @IBOutlet weak var pageIndicationImageViewTwo: UIImageView!
    @IBOutlet weak var pageIndicationImageViewThree: UIImageView!
    @IBOutlet weak var pageIndicationStackView: UIStackView!
    @IBOutlet weak var letsGoBtn: CustomButton!
    var currentPage =  0
    // MARK: - Properties
    var timing = Timer()
    var splashImages:[String] {
        get {
            return ["ad-1","ad-2","ad-3"]
        }
    }
    var splashTexts:[String] {
        get {
            return [tp_strings.welcome_controller.plan_your_dream,tp_strings.welcome_controller.calculate_tax,tp_strings.welcome_controller.enjoy_business_trip]
        }
    }
    
    var splashDescriptions:[String] {
        get {
            return [tp_strings.welcome_controller.travel_places,tp_strings.welcome_controller.enjoy_your_journey,tp_strings.welcome_controller.income_tax_returns]
        }
    }
    
    var nextBtnTitles:[String] {
        get {
            return [tp_strings.welcome_controller.lets_go,tp_strings.welcome_controller.continues,tp_strings.welcome_controller.lets_start]
        }
    }
    
    // MARK: - View life cycle
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        configurations()
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    func testCaseCoverage(currentPage: Int) {
        self.setupScrollTabIndicator(currentPage)
    }
    
    // MARK: - Private methods
    private func setupScrollTabIndicator(_ currentPage:Int) {
        switch currentPage {
        case 4:
            self.pageIndicationStackView.isHidden = true
            self.letsGoBtn.isHidden = false
            self.timing.invalidate()
        case 3:
            self.pageIndicationStackView.isHidden = false
            self.pageIndicationImageViewOne.isHidden = true
            self.pageIndicationImageViewTwo.isHidden = true
            self.pageIndicationImageViewThree.isHidden = false
            self.letsGoBtn.isHidden = false
            self.letsGoBtn.setTitle(self.nextBtnTitles[currentPage-1], for: .normal)
            self.letsGoBtn.setTitle(self.nextBtnTitles[currentPage-1], for: .selected)
        case 2:
            self.pageIndicationStackView.isHidden = false
            self.pageIndicationImageViewOne.isHidden = true
            self.pageIndicationImageViewTwo.isHidden = false
            self.pageIndicationImageViewThree.isHidden = true
            self.letsGoBtn.setTitle(self.nextBtnTitles[currentPage-1], for: .normal)
            self.letsGoBtn.setTitle(self.nextBtnTitles[currentPage-1], for: .selected)
            self.letsGoBtn.isHidden = false
        case 1:
            self.pageIndicationStackView.isHidden = false
            self.pageIndicationImageViewOne.isHidden = false
            self.pageIndicationImageViewTwo.isHidden = true
            self.pageIndicationImageViewThree.isHidden = true
            self.letsGoBtn.setTitle(self.nextBtnTitles[currentPage-1], for: .normal)
            self.letsGoBtn.setTitle(self.nextBtnTitles[currentPage-1], for: .selected)
        default:
            self.pageIndicationStackView.isHidden = false
            self.pageIndicationImageViewOne.isHidden = false
            self.pageIndicationImageViewTwo.isHidden = true
            self.pageIndicationImageViewThree.isHidden = true
            self.letsGoBtn.setTitle(self.nextBtnTitles[0], for: .normal)
            self.letsGoBtn.setTitle(self.nextBtnTitles[0], for: .selected)
            self.letsGoBtn.isHidden = false
        }
    }
    
    
    private func registerCell() {
        collectionView.register(UINib(nibName: tp_strings.welcome_controller.welcome_collection_cell, bundle: .main), forCellWithReuseIdentifier: tp_strings.welcome_controller.welcome_collection_cell)
        collectionView.register(UINib(nibName: tp_strings.welcome_controller.welcome_collection_end_cell, bundle: .main), forCellWithReuseIdentifier: tp_strings.welcome_controller.welcome_collection_end_cell)
    }
    
    private func configurations() {
        self.letsGoBtn.titleLabel?.font = .fontR14
        self.letsGoBtn.layer.cornerRadius = 5.0
    }
    
    // MARK: - User interactions
    @IBAction func pushButtonAction(_ sender: UIButton) {
        let welcomeLanding = WelcomeLandingViewController.loadFromNib()
        welcomeLanding.hidesBottomBarWhenPushed = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.pushViewController(welcomeLanding, animated: true)
        
    }
    
    // MARK: - Network requests


}

// MARK: - Extension

//extension WelcomeViewController: UIScrollViewDelegate {
//
//    // MARK: - UIScrollViewDelegate
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let currentPage = scrollView.currentPage
//    }
////    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
////        let currentPage = scrollView.currentPage
////        setupScrollTabIndicator(currentPage)
////    }
//}


extension WelcomeViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WelcomeCollectionViewCell.reuseIdentifier, for: indexPath) as? WelcomeCollectionViewCell else{
//            return UICollectionViewCell()
//        }
        
        guard let endCell = collectionView.dequeueReusableCell(withReuseIdentifier: WelcomeEndCollectionViewCell.reuseIdentifier, for: indexPath) as? WelcomeEndCollectionViewCell else{
            return UICollectionViewCell()
        }
        
//        switch indexPath.item {
//        case 3:
            endCell.delegate = self
            return endCell
//        default:
//            cell.updateData(splashImages[indexPath.item], splashTexts[indexPath.item], splashDescriptions[indexPath.item])
//            return cell
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
}

extension WelcomeViewController: WelcomeEndCollectionViewCellDelegate {

    // MARK: - WelcomeEndCollectionViewCellDelegate
    func didEndCellTapped() {
        let welcomeLanding = WelcomeLandingViewController.loadFromNib()
        welcomeLanding.hidesBottomBarWhenPushed = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.pushViewController(welcomeLanding, animated: true)
    }
    
}
