//
//  MyTravelListViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 17/05/23.
//

import UIKit

protocol FilterAppliedDelegate {
    func fetchedDetails(filteredTravelList: [TravelListEntity])
}

class MyTravelListViewController: UIViewController {

      // MARK: - Properties
    var listViewModel = MyTravelListViewModel()
    var listType:TravelListType = .all
    var travelList: [TravelListEntity?] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var shouldReload:Bool = true
    
      // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var currentButton: UIButton!
    @IBOutlet weak var upcomingButton: UIButton!
    @IBOutlet weak var pastButton: UIButton!
    @IBOutlet weak var allSegmentImageView: UIImageView!
    @IBOutlet weak var currentSegmentImageView: UIImageView!
    @IBOutlet weak var upcomingSegmentImageView: UIImageView!
    @IBOutlet weak var pastSegmentImageView: UIImageView!
    @IBOutlet weak var currentTitleLbl: UILabel!
    @IBOutlet weak var upcomingTitleLbl: UILabel!
    @IBOutlet weak var pastTitleLbl: UILabel!
    
    // MARK: - View life cycle
    
      // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.APIRefreshCallback), name: Notification.Name("RefreshAppForeground"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if self.shouldReload {
            setInitialRecordYear()
//        } else {
//            self.shouldReload = true
//        }
    }
    
      // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.appRefreshDelegate = self
    }
      // MARK: - Private methods
    
    private func travelListAPI(listType:String) {
        self.listViewModel.myTravelList(userID: UserDefaultModule.shared.getUserID() ?? "", type: listType, enableLoader: true,controller: self) { response in
            self.travelList = response.traveList
            if self.travelList.count == 0 {
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "No data found", image: UIImage(named: "Notification") ?? nil,theme: .custom)
            } else {
                let indexPath = NSIndexPath(row: 0, section: 0)
                DispatchQueue.main.async {
                    self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
                }
            }
        } onFailure: { error in
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }
    }
   
    /// SetupUI
    private func setupUI() {
        self.tableView.register(UINib(nibName: MyTravelListTableViewCell.TableReuseIdentifier, bundle: nil),forCellReuseIdentifier: MyTravelListTableViewCell.TableReuseIdentifier)
        
        let calendar = Calendar(identifier: .gregorian)
        let current = calendar.component(.year, from: Date())
        let lastYear = current - 1
        let beforeLastYear = current - 2
        currentTitleLbl.text = "\(current)"
        upcomingTitleLbl.text = "\(lastYear)"
        pastTitleLbl.text = "\(beforeLastYear)"
    }
    
    private func setInitialRecordYear() {
        let calendar = Calendar(identifier: .gregorian)
        let current = calendar.component(.year, from: Date())
        let lastYear = current - 1
        let beforeLastYear = current - 2
        
        switch self.listType {
        case .current:
            selectCurrentYear()
            travelListAPI(listType: "\(current)")
        case .upcoming:
            selectCurrentlastYear()
            travelListAPI(listType: "\(lastYear)")
        case .past:
            selectCurrentBeforeLastYear()
            travelListAPI(listType: "\(beforeLastYear)")
        default:
            selectCurrentYear()
            travelListAPI(listType: "\(current)")
        }
    }
    
    private func selectCurrentYear() {
        self.allSegmentImageView.image = UIImage(named: "segmentGray")
        self.currentSegmentImageView.image = UIImage(named: "segmentGreen")
        self.upcomingSegmentImageView.image = UIImage(named: "segmentGray")
        self.pastSegmentImageView.image = UIImage(named: "segmentGray")
    }
    
    private func selectCurrentlastYear() {
        self.allSegmentImageView.image = UIImage(named: "segmentGray")
        self.currentSegmentImageView.image = UIImage(named: "segmentGray")
        self.upcomingSegmentImageView.image = UIImage(named: "segmentGreen")
        self.pastSegmentImageView.image = UIImage(named: "segmentGray")
    }
    
    private func selectCurrentBeforeLastYear() {
        self.allSegmentImageView.image = UIImage(named: "segmentGray")
        self.currentSegmentImageView.image = UIImage(named: "segmentGray")
        self.upcomingSegmentImageView.image = UIImage(named: "segmentGray")
        self.pastSegmentImageView.image = UIImage(named: "segmentGreen")
    }
    
    @objc func APIRefreshCallback() {
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.isAppBackground = false
        DispatchQueue.main.async {
            self.setInitialRecordYear()
        }
    }
    
      // MARK: - User interactions
    @IBAction func pageMenuButtonAction(_ sender: UIButton) {
        
        let calendar = Calendar(identifier: .gregorian)
        let current = calendar.component(.year, from: Date())
        let lastYear = current - 1
        let beforeLastYear = current - 2
        
        switch sender.tag {
        case 1:
            self.listType = .all
            self.selectCurrentYear()
//            travelListAPI(listType: .all)
        case 2:
            self.listType = .current
            self.selectCurrentYear()
            travelListAPI(listType: "\(current)")
        case 3:
            self.listType = .upcoming
            self.selectCurrentlastYear()
            travelListAPI(listType: "\(lastYear)")
        default:
            self.listType = .past
            self.selectCurrentBeforeLastYear()
            travelListAPI(listType: "\(beforeLastYear)")
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        let filter = FilterTravelViewController.loadFromNib()
        filter.modalPresentationStyle = .pageSheet
        filter.delegate = self
        if let sheet = filter.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        self.present(filter, animated: true)
    }
    
    // MARK: - UnitTestcase
    
    func unitTestcase() {
        self.selectCurrentlastYear()
        self.selectCurrentBeforeLastYear()
        
        let but1 = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        but1.tag = 1
        pageMenuButtonAction(but1)
        
        let but2 = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        but2.tag = 1
        pageMenuButtonAction(but2)
        
        let but3 = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        but3.tag = 1
        pageMenuButtonAction(but3)
        
        let but4 = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        but4.tag = 1
        pageMenuButtonAction(but4)
        
        filterButtonAction(but4)
                
        didTravelDeleted("all")
        didTravelDeleted("current")
        didTravelDeleted("past")
        didTravelDeleted("test")
    }
 
}


// MARK: - Extension

extension MyTravelListViewController: UITableViewDataSource, UITableViewDelegate {
   
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.travelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTravelListTableViewCell.TableReuseIdentifier, for: indexPath) as? MyTravelListTableViewCell else { return UITableViewCell() }
        cell.updateUI(self.travelList[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 139.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = MyTravelDetailViewController.loadFromNib()
        detail.hidesBottomBarWhenPushed = true
        detail.delegate = self
        detail.selectedlistType = self.listType
        
        detail.travelID = self.travelList[indexPath.row]?.travelId ?? ""
        
        self.navigationController?.pushViewController(detail, animated: true)
    }
}

// MARK: - MyTravelDetailViewControllerDelegate

extension MyTravelListViewController:MyTravelDetailViewControllerDelegate {
    func didTravelDeleted(_ selectedTYpe: String) {
        self.shouldReload = false
        let calendar = Calendar(identifier: .gregorian)
        
        let current = calendar.component(.year, from: Date())
        let lastYear = current - 1
        let beforeLastYear = current - 2
        switch selectedTYpe {
        case "all":
            self.listType = .all
//            self.travelListAPI(listType: .all)
        case "current":
            self.listType = .current
            self.travelListAPI(listType: "\(current)")
        case "past":
            self.listType = .past
            self.travelListAPI(listType: "\(lastYear)")
        default:
            self.listType = .upcoming
            self.travelListAPI(listType: "\(beforeLastYear)")
        }
    }
    func didPressBack() {
        self.shouldReload = false
    }
}

extension MyTravelListViewController: FilterAppliedDelegate {
    func fetchedDetails(filteredTravelList: [TravelListEntity]) {
        DispatchQueue.main.async {
            let pageObj = NewFilterTravelViewController.loadFromNib()
            pageObj.travelList = filteredTravelList
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
    }
}

extension MyTravelListViewController:RefreshAppDelegate {
    func didAppRefreshBegin() {
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.isAppBackground = false
        DispatchQueue.main.async {
            self.setInitialRecordYear()
        }
    }
}

//MARK: - Enum


 enum TravelListType:String {
    case all
    case current
    case past
    case upcoming
}
