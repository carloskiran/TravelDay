//
//  DashboardViewController+Extension.swift
//  TravelPro
//
//  Created by MAC-OBS-48 on 11/09/23.
//

import Foundation
import UIKit

class RootViewController: UIViewController {
    //    var anima = AnimationView()
    var mySensitiveArea: CGRect?
    let screenWidth = UIScreen.main.bounds.size.width/2
    let screenHeight = UIScreen.main.bounds.size.height
    var myCustomView: BottomTabView?
    // MARK: Start loader
    func startLoadingAnimation() {
        self.view.isUserInteractionEnabled = false
    }
    // MARK: Stop loader
    func stopLoadingAnimation() {
        self.view.isUserInteractionEnabled = true
    }
    // MARK: View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "RootViewController - viewDidLoad"))
        mySensitiveArea = CGRect(x: 0,
                                 y: 0,
                                 width: screenWidth,
                                 height: screenHeight)
    }
    // MARK: Registering the custom view for adding the Bottom bar
    func registerCustomView() {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "RootViewController - registerCustomView"))
        if myCustomView == nil { // make it only once
            myCustomView = Bundle.main.loadNibNamed("BottomTabView", owner: self, options: nil)?.first as? BottomTabView
            myCustomView?.frame = CGRect.init(x: 0.0, y: self.view.frame.height - 60.0, width: self.view.frame.width, height: 60.0)
            myCustomView?.backgroundColor = UIColor.clear
            self.view.backgroundColor = UIColor.clear
            self.view.addSubview(myCustomView!) // you can init 'self' here
        }
    }
    // MARK: Removing the custom view
    func removeCustomView() {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "RootViewController - removeCustomView"))
        if myCustomView == nil { // make it only once
            self.myCustomView?.removeFromSuperview()
        }
    }
}

extension DashBoardViewController {
    
    /// SetupCircularProgressView
    /// - Parameters:
    ///   - view: UIView
    ///   - width: CGFloat
    ///   - height: CGFloat
    ///   - isGradient: Bool
    ///   - startColor: UIColor
    ///   - endColor: UIColor
    ///   - angle: Double
    ///   - trackColor: UIColor
    ///   - progressColor: UIColor
    /// - Returns: KDCircularProgress
    internal func setupCircularProgressView(view:UIView = UIView(),isGradient:Bool = false,startColor:UIColor = .clear,endColor:UIColor = .clear, angle:Double = 0.0, trackColor:UIColor = .clear, progressColor:UIColor = .clear) -> KDCircularProgress {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - setupCircularProgressView"))
        var circleProgress:KDCircularProgress?
        circleProgress = KDCircularProgress(frame: CGRect(x: 0, y:0, width: view.frame.size.width, height: view.frame.size.height))
        circleProgress?.startAngle = 90
        circleProgress?.progressThickness = 0.4
        circleProgress?.trackThickness = 0.4
        circleProgress?.clockwise = true
        circleProgress?.gradientRotateSpeed = 2
        circleProgress?.roundedCorners = true
        circleProgress?.glowAmount = 0.0
        circleProgress?.glowMode = .noGlow
        switch isGradient {
        case true:
            circleProgress?.progressColors = [startColor,endColor]
        default:
            circleProgress?.progressColors = [progressColor]
        }
        circleProgress?.progressInsideFillColor = .clear
        circleProgress?.trackColor = trackColor
        circleProgress?.angle = (angle / 100.0) * 360.0
        circleProgress?.animate(fromAngle: 0, toAngle: angle, duration: 1.0) { _ in }
        return circleProgress ?? KDCircularProgress()
        
    }
    
    
    func confirmStayInputs() {
        currentDataFromConfirmStay.isUserInteractionEnabled = false
        let selectedDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.timeZone = TimeZone.current
        self.currentDataFromConfirmStay.text = dateFormatter.string(from: selectedDate)
        self.currentCountryFromConfirmStay.text = ""
        startDatePicker.datePickerMode = .date
        let toolbar = createPickerToolbar(7)
        travelDataArrivedFromConfirmStay.inputAccessoryView = toolbar
        travelDataArrivedFromConfirmStay.inputView = startDatePicker
        startDatePicker.timeZone = Calendar.current.timeZone
        if #available(iOS 14, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
            startDatePicker.sizeToFit()
        }
        let gregorian = Calendar(identifier: .gregorian)
        let yesterday = gregorian.date(byAdding: .day, value: -1, to: Date())!
        // Get the current year
        let currentYear = Calendar.current.component(.year, from: Date())
        // Calculate the start date based on the current year
        var startDateComponents = DateComponents()
        startDateComponents.year = currentYear - 2
        startDateComponents.month = 1
        startDateComponents.day = 1
        let startDate = Calendar.current.date(from: startDateComponents)!
        startDatePicker.minimumDate = startDate
        startDatePicker.maximumDate = Date()
    }
    
    //MARK: - Internal

    internal func setupStartDateDatePicker(){
        startDatePicker.datePickerMode = .date
        let _: Calendar = Calendar.current
        let toolbar = createPickerToolbar(6)
        startDateTextfield.inputAccessoryView = toolbar
        startDateTextfield.inputView = startDatePicker
        startDatePicker.timeZone = Calendar.current.timeZone
        if #available(iOS 14, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
            startDatePicker.sizeToFit()
        }
        let gregorian = Calendar(identifier: .gregorian)
        let yesterday = gregorian.date(byAdding: .day, value: -1, to: Date())!
        // Get the current year
        let currentYear = Calendar.current.component(.year, from: Date())
        // Calculate the start date based on the current year
        var startDateComponents = DateComponents()
        startDateComponents.year = currentYear - 2
        startDateComponents.month = 1
        startDateComponents.day = 1
        let startDate = Calendar.current.date(from: startDateComponents)!
        startDatePicker.minimumDate = startDate
        startDatePicker.maximumDate = Date()

     }
        
    internal func createPickerToolbar(_ tag:Int) -> UIToolbar {
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        var doneButton = UIBarButtonItem()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      
        switch tag {
        case 6:
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneStartDatePicker))
            toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
            return toolbar
        default:
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTravelArrrivedFrom))
            toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
            return toolbar
        }
    }
   
    internal func selectCurrentYear() {
        self.currentDateLbl.textColor = UIColor(named: "headingText")
        self.pastDateLbl.textColor = UIColor(named: "GrayColor")
        self.lastDateLbl.textColor = UIColor(named: "GrayColor")
        self.currentDateSelectorView.backgroundColor = UIColor(named: "btnLoginColor")
        self.pastDateSelectorView.backgroundColor = UIColor(named: "GrayColor")
        self.lastDateSelectorView.backgroundColor = UIColor(named: "GrayColor")
        self.selectedDate = self.currentDateLbl.text ?? ""
        self.getUpcomingTravelList(date: self.selectedDate)
    }
    
    @objc internal func cancelDatePicker(){
       self.view.endEditing(true)
     }

    internal func setupCurrentTravelDetail(_ travelEntity:TravelListEntity?) {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - setupCurrentTravelDetail"))
        if let originData = travelEntity?.destination {
            self.presentCountryLabel.text = originData.countryName
        }
        
        updateResident(travelEntity?.resident ?? false)

        self.totalDaysLabel.text = "\(travelEntity?.taxableDays ?? 0)"
        self.presenceDayLabel.text = "\(travelEntity?.totalPhysicalPresenceDays ?? 0)"
    }
    
    internal func updateResident(_ isResident:Bool) {
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - updateResident"))
        switch isResident {
        case false:
            self.residentLabel.text = "Non-Resident"
            let isDarkMode : Bool = UserDefaults.standard.value(forKey: "isDark") as? Bool ?? false
            switch isDarkMode {
            case true:
                self.residentView.backgroundColor = UIColor.nonResidentColor.withAlphaComponent(1.0)
                self.residentLabel.textColor =  UIColor.white
                
            default:
                self.residentView.backgroundColor = UIColor.nonResidentColor
                self.residentLabel.textColor = UIColor.nonResidentWithAlphaColor
            }
        default:
            self.residentLabel.text = "Resident"
            self.residentLabel.textColor =  UIColor.residentColor.withAlphaComponent(1.0)
            self.residentView.backgroundColor = UIColor.residentColor
        }
    }
    
}

extension DashBoardViewController:MyTravelDetailViewControllerDelegate {
    func didPressBack() { }
    func didTravelDeleted(_ selectedTYpe: String) {
        self.getCurrentListResponse()
        self.getUpcomingTravelList(date: self.selectedDate)
        self.getRecentTravelList()
    }
}


extension DashBoardViewController: LocationManagerCallbackDelegate {
   
    func didReceiveLocation(for userCurrentLocation: LocationData) {
        print(">>>> userCurrentLocation: \(userCurrentLocation)")
        UserLocationSetting.sharedInstance.isLocationAccessDenied = false
        TravelTaxMixPanelAnalytics(action: .dashboard, state: .info, data: MixPanelData(message: "DashBoardViewController - didReceiveLocation: \(userCurrentLocation)"))
        self.locationData = userCurrentLocation
        self.getNewUserRecordAPI()
    }
    
}

extension DashBoardViewController: LocationManagerListRefreshCallbackDelegate {
   
    func didLocationUpdated() {
        DispatchQueue.main.async {
            UserLocationSetting.sharedInstance.isLocationAccessDenied = false
            self.getRecentTravelList()
            self.getCurrentListResponse()
            self.getUpcomingTravelList(date: self.selectedDate)
        }
    }
    
}

//MARK: - SelectTravelCountryDelegate
extension DashBoardViewController: SelectTravelCountryDelegate {
    
    func didSelectedCountry(country: CountryListModel?, type: CountryType) {
        if let data = country {
            switch type {
            case .fromCountry:
                if self.locationContentView.isHidden == false {
                    self.countryFrom.text = data.countryName
                    self.locationData.fromCountryCode = data.isoCode
                    self.locationData.fromCountryName = data.countryName
                }
                if self.confirmStayPopupView.isHidden == false {
                    self.countryArrivedFromConfirmStay.text = data.countryName
                    self.confirmStayHandler.origin = data.isoCode
                }
            default:
                break
            }
        }
    }
    
}
 
//MARK: - Struct

struct ConfirmStayHandler {
    var existingId:String = ""
    var origin:String = ""
    var destination:String = ""
    var startDate:String = ""
}
