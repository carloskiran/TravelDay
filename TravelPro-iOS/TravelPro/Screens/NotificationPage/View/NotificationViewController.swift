//
//  NotificationViewController.swift
//  TravelPro
//
//  Created by VIJAY M on 13/06/23.
//

import UIKit

class NotificationViewController: UIViewController {
    
    // OUTLET PROPERTIES
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var noMessageView: UIView!
    @IBOutlet weak var sorryLbl: UILabel!
    @IBOutlet weak var noRecordLbl: UILabel!
    
    // GLOBAL PROPERTIES
    var notificationAPIViewModel = NotificationViewModel()
    var notificationResponse: NotificationResponseModel?
    var resultTodayDetails = [NotificationEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        self.setupUI()
        self.APICalling()
    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        self.hidesBottomBarWhenPushed = false
        self.noMessageView.isHidden = true
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        self.noMessageView.isHidden = true
        self.noRecordLbl.text = "No Notification Yet"
        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        tableView.layer.cornerRadius = 10.0
        tableView.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func APICalling() {
        TravelTaxMixPanelAnalytics(action: .notificationPage, state: .info, data: MixPanelData(message: "NotificationViewController - APICalling"))
        notificationAPIViewModel.getNotificationAPI(enableLoader: false ,controller: self) { response in
            self.notificationResponse = response
            if let response = response {
                let details = response.entity
                self.resultTodayDetails = details
                if details.count > 0 {
                    self.noMessageView.isHidden = true
                    self.tableView.isHidden = false
                    TravelTaxMixPanelAnalytics(action: .notificationPage, state: .info, data: MixPanelData(message: "NotificationViewController - details.count > 0"))
                } else {
                    self.noMessageView.isHidden = false
                    self.tableView.isHidden = true
                    TravelTaxMixPanelAnalytics(action: .notificationPage, state: .info, data: MixPanelData(message: "NotificationViewController - details.count = 0"))
                }
                self.tableView.reloadData()
            }
        } onFailure: { errorResponse in
            TravelTaxMixPanelAnalytics(action: .notificationPage, state: .info, data: MixPanelData(message: "NotificationViewController -APICalling - Error: \(errorResponse)"))
            self.noMessageView.isHidden = false
            self.tableView.isHidden = true
        }
    }
    
    @IBAction func backBtnTappedc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UnitTestcase
    
    func UnitTestcase(){
        self.APICalling()
        let _ = formatRelativeTime(from: Date())
        let _ = checkNullvalue(passedValue: "test")
    }
}


// MARK: - UITABLEVIEW DATASOURCE FUNCTION
extension NotificationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultTodayDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
        if let cell =  tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as? NotificationCell {
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.clear
            let title = resultTodayDetails[indexPath.row].notificationTitle
            let time = resultTodayDetails[indexPath.row].createdDate
            cell.highLightLbl.isHidden = resultTodayDetails[indexPath.row].read
            cell.headerLbl.text = title
            
            let dateString = time
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: dateString)!
            let timeLblStr = formatRelativeTime(from: date)
            
            cell.timeLbl.config(text: timeLblStr, textColor: UIColor(hexString: "9D9595"), font: .fontM12)
            cell.descLbl.text = resultTodayDetails[indexPath.row].description
//            cell.configuration(indexValue: indexPath, responseCount: self.resultTodayDetails.count)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func commonDataTimeHourCalculator(inputDate: String, formatstring: String, from: Bool = true) -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = formatstring
        olDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let oldDate = olDateFormatter.date(from: inputDate)
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = formatstring
        convertDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateString =  convertDateFormatter.string(from: oldDate ?? Date())
        let timeDate = checkNullvalue(passedValue: dateString)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatstring
        let dateVal = dateFormatter.date(from: String(timeDate))!
        if Calendar.current.isDateInToday(dateVal) && from {
            let convertedDate = checkTimeDifferenceFromNow(dateStr: checkNullvalue(passedValue: dateString), format: "MM/dd/yyyy h:mm a")
            print("convertedDate", convertedDate)
            if convertedDate == 0.0 {
                let convertedMin = checkMinuteDifferenceFromNow(dateStr: checkNullvalue(passedValue: dateString), format: "MM/dd/yyyy h:mm a")
                if convertedMin == 0.0 {
                    return "Just now"
                } else {
                    if convertedMin == 1.0 {
                        return "\(Int(convertedMin))m"
                    } else {
                        return "\(Int(convertedMin))m"
                    }
                }
            } else {
                if convertedDate == 1.0 {
                    return "\(Int(convertedDate))h"
                } else {
                    return "\(Int(convertedDate))h"
                }
            }
        } else {
            let convertDateFormatter = DateFormatter()
            if from {
                convertDateFormatter.dateFormat = "dd,MMM"
            } else {
                convertDateFormatter.dateFormat = "MM/dd/yyyy"
            }
            convertDateFormatter.timeZone = TimeZone.current
            let finalDate = convertDateFormatter.string(from: oldDate!)
            return finalDate
        }
    }
    
    func formatRelativeTime(from date: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        formatter.allowedUnits = [.minute, .hour, .day, .weekOfMonth, .month, .year]
        
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
        guard let timeDifferenceString = formatter.string(from: components) else {
            return ""
        }

        if timeDifferenceString == "0m" {
            return "Just now"
        }
        
        return timeDifferenceString+" ago"
    }
    
    func checkNullvalue(passedValue: Any?) -> String {
        var param: Any? = passedValue
        if param == nil || param is NSNull {
            param=""
        } else {
            param = String(describing: passedValue!)
        }
        return (param as? String)!
    }
    
    func checkTimeDifferenceFromNow(dateStr: String, format: String = "yyyy-MM-dd HH:mm:ss" ) -> Double {
        print(dateStr)
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = format // "MM/dd/yyyy"
        let date1 = inputFormatter.date(from: dateStr)
        
        var date2 = Date()
        let strdat2 = inputFormatter.string(from: date2)
        date2 = inputFormatter.date(from: strdat2)!
        if date2 > date1! {
            let elapsedTime = date2.timeIntervalSince(date1!)
            let hours = floor(elapsedTime / 60 / 60)
            return hours
        } else {
            let elapsedTime = date1!.timeIntervalSince(date2)
            let hours = floor(elapsedTime / 60 / 60)
            return hours
        }
        
    }
    
    func checkMinuteDifferenceFromNow(dateStr: String, format: String = "yyyy-MM-dd HH:mm:ss" ) -> Double {
        print(dateStr)
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = format // "MM/dd/yyyy"
        let date1 = inputFormatter.date(from: dateStr)
        
        var date2 = Date()
        let strdat2 = inputFormatter.string(from: date2)
        date2 = inputFormatter.date(from: strdat2)!
        if date2 > date1! {
            let elapsedTime = date2.timeIntervalSince(date1!)
            let hours = floor(elapsedTime / 60)
            return hours
        } else {
            let elapsedTime = date1!.timeIntervalSince(date2)
            let hours = floor(elapsedTime / 60)
            return hours
        }
        
    }
}

// MARK: - UITABLEVIEW DELEGATE FUNCTION
extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            TravelTaxMixPanelAnalytics(action: .notificationPage, state: .info, data: MixPanelData(message: "NotificationViewController - didSelectRowAt"))

            let notificationPageObj = NotificationEnlargementView.loadFromNib()
            if !self.resultTodayDetails[indexPath.row].read {
                self.readNotificationAPICall(notificationID: self.resultTodayDetails[indexPath.row].id)
            }
            notificationPageObj.descriptionString = self.resultTodayDetails[indexPath.row].description
            self.resultTodayDetails[indexPath.row].read = true
            self.tableView.reloadData()
            notificationPageObj.modalPresentationStyle = .pageSheet
            if let sheet = notificationPageObj.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            self.present(notificationPageObj, animated: true)
        }
    }
    
    func readNotificationAPICall(notificationID: String) {
        notificationAPIViewModel.readNotificationAPI(notificationId: notificationID, enableLoader: false) { response in
            if let respon = response {
                print(respon)
            }
        } onFailure: { error in
            print(error)
        }

    }
}

