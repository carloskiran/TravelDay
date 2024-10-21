//
//  NewFilterTravelViewController.swift
//  TravelPro
//
//  Created by VIJAY M on 09/06/23.
//

import UIKit

class NewFilterTravelViewController: UIViewController {
    
    @IBOutlet weak var travelListTableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    
    var travelList: [TravelListEntity?] = [] {
        didSet {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        cellRegisteration()
    }
    
    private func cellRegisteration() {
        self.travelListTableView.register(UINib(nibName: MyTravelListTableViewCell.TableReuseIdentifier, bundle: nil),forCellReuseIdentifier: MyTravelListTableViewCell.TableReuseIdentifier)
        travelListTableView.reloadData()
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension NewFilterTravelViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.travelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTravelListTableViewCell.TableReuseIdentifier, for: indexPath) as? MyTravelListTableViewCell else { return UITableViewCell() }
        cell.updateUI(self.travelList[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 159.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = MyTravelDetailViewController.loadFromNib()
        detail.hidesBottomBarWhenPushed = true
        detail.travelID = self.travelList[indexPath.row]?.travelId ?? ""
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
