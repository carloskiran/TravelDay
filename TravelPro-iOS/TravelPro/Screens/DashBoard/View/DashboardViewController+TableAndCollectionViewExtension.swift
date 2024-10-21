//
//  DashboardViewController+TableAndCollectionViewExtension.swift
//  TravelPro
//
//  Created by MAC-OBS-48 on 11/09/23.
//

import Foundation
import UIKit


// MARK: - Extension
extension DashBoardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionView Delegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 182, height: 183)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recenttravelList.count > 5 ? 5 : self.recenttravelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - UICollectionViewDelegate - cellForItemAt"))
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentVisitCell", for: indexPath) as? RecentlyVisitedCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.updateUI(self.recenttravelList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = MyTravelDetailViewController.loadFromNib()
        detail.hidesBottomBarWhenPushed = true
        detail.delegate = self
        detail.viewDidAppear(true)
        detail.travelID = self.recenttravelList[indexPath.item]?.travelId ?? ""
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    }
    
}

extension DashBoardViewController: UITableViewDataSource, UITableViewDelegate {
   
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.upcomingtravelList.count > 5 ? 5 : self.upcomingtravelList.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - UITableViewDelegate - cellForRowAt"))
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingScheduleTableViewCell.TableReuseIdentifier, for: indexPath) as? UpcomingScheduleTableViewCell else { return UITableViewCell() }
//        cell.updateUI(self.upcomingtravelList[indexPath.row])
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpdatedSummaryCells.TableReuseIdentifier, for: indexPath) as? UpdatedSummaryCells else { return UITableViewCell() }
        let countryName = (self.upcomingtravelList[indexPath.row]?.destination?.countryName ?? "") == "N/A" ? (self.upcomingtravelList[indexPath.row]?.origin?.countryName ?? "") : (self.upcomingtravelList[indexPath.row]?.destination?.countryName ?? "")
        cell.configuration(countryName: countryName, days: "\(self.upcomingtravelList[indexPath.row]?.totalPhysicalPresenceDays ?? 0)"+"/"+"\(self.upcomingtravelList[indexPath.row]?.taxableDays ?? 0)"+" Days")
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = MyTravelDetailViewController.loadFromNib()
        detail.hidesBottomBarWhenPushed = true
        detail.viewDidAppear(true)
        detail.delegate = self
        detail.travelID = self.upcomingtravelList[indexPath.item]?.travelId ?? ""
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
