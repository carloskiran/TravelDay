//
//  FilterTravelViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 02/06/23.
//

import UIKit

class FilterTravelViewController: UIViewController {

    
    @IBOutlet weak var countryTF: FloatingTF!
    @IBOutlet weak var startDateTextfield: FloatingTF!
    @IBOutlet weak var endDateTextfield: FloatingTF!
    
    var missingTravelHandler:AddFilterHelper! = AddFilterHelper()
    var myTravelListViewModelObj = MyTravelListViewModel()
    var delegate: FilterAppliedDelegate?
    var startDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    func setUpUI() {
        //start date
        startDateTextfield.delegate = self
        startDateTextfield.tintColor = .clear
        setupStartDateDatePicker()
        
        //end date
        endDateTextfield.delegate = self
        endDateTextfield.tintColor = .clear
        setupEndDateDatePicker()
        
        endDateTextfield.isUserInteractionEnabled = false
    }
    
    private func setupStartDateDatePicker(){
        startDatePicker.datePickerMode = .date
        _ = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
//        let date = Calendar.current.date(byAdding: .year, value: -2, to:Date())
        
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
        let toolbar = createPickerToolbar(1)
        startDateTextfield.inputAccessoryView = toolbar
        startDateTextfield.inputView = startDatePicker
        if #available(iOS 14, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
            startDatePicker.sizeToFit()
        }
     }
    
    private func setupEndDateDatePicker(){
        endDatePicker.datePickerMode = .date
//        let date = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
//        endDatePicker.minimumDate = date
        let toolbar = createPickerToolbar(2)
        endDateTextfield.inputAccessoryView = toolbar
        endDateTextfield.inputView = endDatePicker
        if #available(iOS 14, *) {
            endDatePicker.preferredDatePickerStyle = .wheels
            endDatePicker.sizeToFit()
        }
     }
    
    private func createPickerToolbar(_ tag:Int) -> UIToolbar {
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        var doneButton = UIBarButtonItem()
        switch tag {
            
        case 1:
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneStartDatePicker))
        default:
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneEndDatePicker))
        }
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        return toolbar
    }
    
    @objc private func cancelDatePicker(){
       self.view.endEditing(true)
     }
    
    @objc func doneStartDatePicker(){
        let formatter = DateFormatter()
//        formatter.dateFormat = "MMM dd, YYYY"
        formatter.dateFormat = "MMM dd, yyyy"
        startDateTextfield.text = formatter.string(from: startDatePicker.date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
        let newStartTime = dateFormatter.string(from: startDatePicker.date)
        
        let calendars = Calendar.current
        var dateComponent = calendars.dateComponents([.year, .month, .day], from: startDatePicker.date)
        dateComponent.year! += 1
        dateComponent.day! -= 1
        
        if let oneYearLater = calendars.date(from: dateComponent) {
            let selectedDateString = dateFormatter.string(from: startDatePicker.date)
            let oneYearLaterString = dateFormatter.string(from: oneYearLater)
            let oneYearLaterDate = formatter.string(from: oneYearLater)
            print("selectedDateString \(selectedDateString)")
            print("oneYearLaterString \(oneYearLaterString)")
            print("oneYearLaterDate \(oneYearLaterDate)")
            endDateTextfield.text = oneYearLaterDate
            self.missingTravelHandler.taxEndDateString = oneYearLaterString
        }
        
        self.missingTravelHandler.taxYearDateString = newStartTime

        self.view.endEditing(true)
    }
    
    @objc func doneEndDatePicker() {
       
        guard (self.missingTravelHandler.taxYearDateString != nil) else {
            self.view.endEditing(true)
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select start date", image: nil,theme: .default)
        }
        let formatter = DateFormatter()
//        formatter.dateFormat = "MMM dd, YYYY"
        formatter.dateFormat = "MMM dd, yyyy"
       
        guard startDateTextfield.text == formatter.string(from: endDatePicker.date) || endDatePicker.date >= startDatePicker.date else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "End date should be greater than start date", image: nil,theme: .default)
        }
        
        endDateTextfield.text = formatter.string(from: endDatePicker.date)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00.0000"
        let newStartTime = dateFormatter.string(from: endDatePicker.date)
        
        self.missingTravelHandler.taxEndDateString = newStartTime
        self.view.endEditing(true)
    }
    
    @IBAction func applyFilterBtnTapped(_ sender: Any) {
        let button = sender as? UIButton
        button?.isUserInteractionEnabled = false
        
        var validationCount = Int()
        
        if self.missingTravelHandler.Country < 1 {
            validationCount += 1
        }
        
        if self.missingTravelHandler.taxYearDateString == nil {
            validationCount += 1
            if validationCount == 2 {
                validationCount += 1
            }
            
        } else {
            if self.missingTravelHandler.taxEndDateString == nil {
                validationCount += 1
                button?.isUserInteractionEnabled = true
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select end date", image: nil,theme: .default)
            }
        }
        
        guard validationCount != 3 else {
            button?.isUserInteractionEnabled = true
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Please give the date or country details to apply the filter", image: nil,theme: .default)
        }
        
//        guard self.missingTravelHandler.Country > 0 else {
//            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select country from", image: nil,theme: .default)
//        }
//
//        guard (self.missingTravelHandler.taxYearDateString != nil) else {
//            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select start date", image: nil,theme: .default)
//        }
//
//        guard (self.missingTravelHandler.taxEndDateString != nil) else {
//            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select end date", image: nil,theme: .default)
//        }
        
        myTravelListViewModelObj.filterTravelList(userID: UserDefaultModule.shared.getUserID() ?? "", taxStartYear: missingTravelHandler.taxYearDateString ?? "", taxEndYear: missingTravelHandler.taxEndDateString ?? "", country: missingTravelHandler.countryString, enableLoader: true) { response in
            self.dismiss(animated: false)
            button?.isUserInteractionEnabled = true
            if response.status.status == 200 {
                if response.entity.count > 0 {
                    self.delegate?.fetchedDetails(filteredTravelList: response.entity)
                } else {
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "you don't have any travel list", image: UIImage(named: "Notification") ?? nil,theme: .custom)
                }
            } else {
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "\(response.status.status ?? 0) error accurred", image: UIImage(named: "Notification") ?? nil,theme: .custom)
            }
        } onFailure: { error in
            button?.isUserInteractionEnabled = true
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }

    }
    
    
    @IBAction func countryBtnTapped(_ sender: Any) {
        let country = SelectTravelCountryViewController.loadFromNib()
        country.countryType = .fromCountry
        country.delegate = self
        self.present(country, animated: true)
    }
    
    @IBAction func dismissBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //MARK: - UnitTestcase
    
    func unitTestcase() {
        doneStartDatePicker()
        doneEndDatePicker()
        applyFilterBtnTapped(UIButton())
        countryBtnTapped(UIButton())
    }
}

//MARK: - UITextFieldDelegate
extension FilterTravelViewController: UITextFieldDelegate {
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        return false
//    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}


//MARK: - Struct
struct AddFilterHelper {
    var Country: Int
    var taxYearDate:String
    var taxEndDate:String
    var countryString:String
    var taxYearDateString:String?
    var taxEndDateString:String?
    
    init() {
        self.Country = 0
        self.taxYearDate = ""
        self.taxEndDate = ""
        self.countryString = ""
    }
}

//MARK: - SelectTravelCountryDelegate
extension FilterTravelViewController: SelectTravelCountryDelegate {
    
    func didSelectedCountry(country: CountryListModel?, type: CountryType) {
        if let data = country {
            switch type {
            case .toCountry:
                break
            default:
                self.missingTravelHandler.Country = data.countryId
                countryTF.text = data.countryName
                self.missingTravelHandler.countryString = data.countryName
            }
        }
    }
    
}
