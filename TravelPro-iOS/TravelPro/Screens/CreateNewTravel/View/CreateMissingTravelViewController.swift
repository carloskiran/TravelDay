//
//  CreateMissingTravelViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 31/05/23.
//

import UIKit

class CreateMissingTravelViewController: UIViewController {

    // MARK: - Properties
    var startDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    var missingTravelHandler:AddMissingTravelHelper! = AddMissingTravelHelper()
    var addMissingViewModel = CreateMissingTravelViewMmodel()
    
    var startDate = Date()
    var endDate = Date()
    
    // MARK: - IBOutlets
    @IBOutlet weak var fromTextfield: FloatingTF!
    @IBOutlet weak var toTextfield: FloatingTF!
    @IBOutlet weak var startDateTextfield: FloatingTF!
    @IBOutlet weak var endDateTextfield: FloatingTF!


    // MARK: - View life cycle
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        TravelTaxMixPanelAnalytics(action: .createMissingTravel, state: .info, data: MixPanelData(message: "CreateMissingTravelViewController - viewWillAppear"))
        setupUI()
    }
   
    // MARK: - Private methods
    private func setupUI() {
        TravelTaxMixPanelAnalytics(action: .createMissingTravel, state: .info, data: MixPanelData(message: "CreateMissingTravelViewController - setupUI"))
        //start date
        startDateTextfield.delegate = self
        startDateTextfield.tintColor = .clear
        setupStartDateDatePicker()
        
        //end date
        endDateTextfield.delegate = self
        endDateTextfield.tintColor = .clear
        setupEndDateDatePicker()
    }
    
    private func setupStartDateDatePicker(){
        TravelTaxMixPanelAnalytics(action: .createMissingTravel, state: .info, data: MixPanelData(message: "CreateMissingTravelViewController - setupStartDateDatePicker"))
        startDatePicker.datePickerMode = .date
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
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
        startDatePicker.maximumDate = yesterday
        let toolbar = createPickerToolbar(1)
        startDateTextfield.inputAccessoryView = toolbar
        startDateTextfield.inputView = startDatePicker
        if #available(iOS 14, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
            startDatePicker.sizeToFit()
        }
     }
    
    private func setupEndDateDatePicker(){
        TravelTaxMixPanelAnalytics(action: .createMissingTravel, state: .info, data: MixPanelData(message: "CreateMissingTravelViewController - setupEndDateDatePicker"))
        endDatePicker.datePickerMode = .date
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
//        let date = Calendar.current.date(byAdding: .year, value: -2, to:Date())
        // Get the current year
        let currentYear = Calendar.current.component(.year, from: Date())

        // Calculate the start date based on the current year
        var startDateComponents = DateComponents()
        startDateComponents.year = currentYear - 2
        startDateComponents.month = 1
        startDateComponents.day = 1
        let startDate = Calendar.current.date(from: startDateComponents)!
        
        endDatePicker.minimumDate = startDate
        endDatePicker.maximumDate = yesterday
        let toolbar = createPickerToolbar(2)
        endDateTextfield.inputAccessoryView = toolbar
        endDateTextfield.inputView = endDatePicker
        if #available(iOS 14, *) {
            endDatePicker.preferredDatePickerStyle = .wheels
            endDatePicker.sizeToFit()
        }
        
     }
    
    private func createPickerToolbar(_ tag:Int) -> UIToolbar {
        TravelTaxMixPanelAnalytics(action: .createMissingTravel, state: .info, data: MixPanelData(message: "CreateMissingTravelViewController - createPickerToolbar"))
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
        TravelTaxMixPanelAnalytics(action: .createMissingTravel, state: .info, data: MixPanelData(message: "CreateMissingTravelViewController - doneStartDatePicker"))
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        startDateTextfield.text = formatter.string(from: startDatePicker.date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.0000"
        let newStartTime = dateFormatter.string(from: startDatePicker.date)
        startDate = startDatePicker.date
        
        self.missingTravelHandler.startDateString = newStartTime
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        
        // Get the current year
        let currentYear = Calendar.current.component(.year, from: startDatePicker.date)

        // Calculate the start date based on the current year
        var startDateComponents = DateComponents()
        startDateComponents.year = currentYear
        startDateComponents.month = 1
        startDateComponents.day = 1
        let startDate = Calendar.current.date(from: startDateComponents)!
        
        // Calculate the start date based on the current year
        var endDateComponents = DateComponents()
        endDateComponents.year = currentYear
        endDateComponents.month = 12
        endDateComponents.day = 31
        let endDate = Calendar.current.date(from: endDateComponents)!
        
        endDatePicker.minimumDate = startDate
        if currentYear ==  Calendar.current.component(.year, from: Date()){
            endDatePicker.maximumDate = yesterday
        } else {
            endDatePicker.maximumDate = endDate
        }
        
        endDateTextfield.text = ""
        endDateTextfield.text = ""

        self.view.endEditing(true)
    }
    
    @objc func doneEndDatePicker() {
        TravelTaxMixPanelAnalytics(action: .createMissingTravel, state: .info, data: MixPanelData(message: "CreateMissingTravelViewController - doneEndDatePicker"))
        guard (self.missingTravelHandler.startDateString != nil) else {
            self.view.endEditing(true)
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select start date", image: nil,theme: .default)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
       
        guard startDateTextfield.text == formatter.string(from: endDatePicker.date) || endDatePicker.date >= startDatePicker.date else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "End date should be greater than start date", image: nil,theme: .default)
        }
        
        endDateTextfield.text = formatter.string(from: endDatePicker.date)
        endDate = endDatePicker.date

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.0000"
        let newStartTime = dateFormatter.string(from: endDatePicker.date)
        
        self.missingTravelHandler.endDateString = newStartTime
        self.view.endEditing(true)
    }
    
    private func addMissingTravelAPI() {
        TravelTaxMixPanelAnalytics(action: .createMissingTravel, state: .info, data: MixPanelData(message: "CreateMissingTravelViewController - addMissingTravelAPI"))
        
        let calendar = Calendar.current
        let selectedYear = calendar.component(.year, from: startDatePicker.date)
        
        // Determine the start date based on the selected year
        var startDateComponents = DateComponents()
        startDateComponents.year = selectedYear
        startDateComponents.month = 1
        startDateComponents.day = 1
        let startDate = calendar.date(from: startDateComponents)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
        let startDateString = dateFormatter.string(from: startDate)

        // Determine the end date based on the selected year
        var endDateComponents = DateComponents()
        endDateComponents.year = selectedYear
        endDateComponents.month = 12
        endDateComponents.day = 31
        let endDate = calendar.date(from: endDateComponents)!
        let endDateString = dateFormatter.string(from: endDate)

        print("current date: \(startDate) and end date: \(endDate)")
        
//        let nonWorkingDays = self.removeNonWorkingDays(startDate: self.startDate, endDate: self.endDate)
        
        
        self.addMissingViewModel.addMissingTravelRecord(origin:self.missingTravelHandler.fromCountry,destination: self.missingTravelHandler.toCountry,startDate: self.missingTravelHandler.startDateString ?? "",endDate: self.missingTravelHandler.endDateString ?? "", taxStartYear: startDateString, taxEndYear: endDateString, nonWorkDays: []) { response in
            TravelTaxMixPanelAnalytics(action: .createMissingTravel, state: .info, data: MixPanelData(message: "CreateMissingTravelViewController - addMissingTravelAPI - success response"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Successfully updated", image: UIImage(named: "Notification") ?? nil,theme: .custom)
            self.missingTravelHandler = AddMissingTravelHelper()
            self.dismiss(animated: true)
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            if let tabBarController = appDelegate?.window!.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 1
            }
            
        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .createMissingTravel, state: .info, data: MixPanelData(message: "CreateMissingTravelViewController - addMissingTravelAPI - failure response"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }
        
    }
    
    
    // MARK: - REMOVEAL OF NON WORKING DAYS
    
//    func removeNonWorkingDays(startDate: Date, endDate: Date) -> ([Date], [Date], [String]) {
//        let calendar = Calendar.current
//        var filteredDates: [Date] = []
//
//        let numbersString = UserDefaultModule.shared.getNonWorkingDays()
//
//        // Split the string by comma and convert each substring to an integer
//        let numbers = numbersString.split(separator: ",").compactMap { Int($0) }
//
//        // Create a set from the array of integers
//        let numberSet = Set(numbers)
//
//        let nonWorkingDays: Set<Int> = numberSet  // 1 represents Sunday, 7 represents Saturday
//
//        var currentDate = startDate
//        var nonWorkingDay = [Date]()
//        var listOfNonWorkingDay = [String]()
//        while currentDate <= endDate {
//            let dayOfWeek = calendar.component(.weekday, from: currentDate)
//
//            if !nonWorkingDays.contains(dayOfWeek) {
//                filteredDates.append(currentDate)
//            } else {
//                nonWorkingDay.append(currentDate)
//
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
//                let dateString = dateFormatter.string(from: currentDate)
//                listOfNonWorkingDay.append(dateString)
//            }
//
//
//            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
//        }
//
//        return (filteredDates, nonWorkingDay, listOfNonWorkingDay)
//    }
    
    // MARK: - User Interactions

    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func fromCountryAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .createMissingTravel, state: .info, data: MixPanelData(message: "CreateMissingTravelViewController - fromCountryAction"))
        let country = SelectTravelCountryViewController.loadFromNib()
        country.countryType = .fromCountry
        country.delegate = self
        self.present(country, animated: true)
    }
    
    @IBAction func toCountryAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .createMissingTravel, state: .info, data: MixPanelData(message: "CreateMissingTravelViewController - toCountryAction"))
        let country = SelectTravelCountryViewController.loadFromNib()
        country.countryType = .toCountry
        country.delegate = self
        self.present(country, animated: true)
    }

    @IBAction func applyButtonAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .createMissingTravel, state: .info, data: MixPanelData(message: "CreateMissingTravelViewController - applyButtonAction"))
        guard self.missingTravelHandler.fromCountry > 0 else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select country from", image: nil,theme: .default)
        }
        
        guard self.missingTravelHandler.toCountry > 0 else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select country to", image: nil,theme: .default)
        }
              
        guard (self.missingTravelHandler.startDateString != nil) else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select start date", image: nil,theme: .default)
        }
        
        guard (self.missingTravelHandler.endDateString != nil) else {
            return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select end date", image: nil,theme: .default)
        }
        self.addMissingTravelAPI()
    }
    

}

extension CreateMissingTravelViewController:SelectTravelCountryDelegate {
    
    //MARK: - SelectTravelCountryDelegate
    func didSelectedCountry(country: CountryListModel?, type: CountryType) {
        TravelTaxMixPanelAnalytics(action: .createMissingTravel, state: .info, data: MixPanelData(message: "CreateMissingTravelViewController - didSelectedCountry"))
        if let data = country {
            switch type {
            case .toCountry:
                guard self.missingTravelHandler.fromCountry > 0 else {
                    return utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Select country from", image: nil,theme: .default)
                }
                if self.missingTravelHandler.fromCountry == data.countryId {
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Country From and To should not be the same", image: nil,theme: .default)
                } else {
                    self.missingTravelHandler.toCountry = data.countryId
                    self.missingTravelHandler.toCountryString = data.countryName
                     toTextfield.text = data.countryName
                }

            default:
                self.missingTravelHandler.fromCountry = data.countryId
                fromTextfield.text = data.countryName
                self.missingTravelHandler.fromCountryString = data.countryName
            }
        }
    }
    
}

extension CreateMissingTravelViewController:UITextFieldDelegate {
    //MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}


//MARK: - Add Missing Travel Handler

struct AddMissingTravelHelper {
    var fromCountry:Int
    var toCountry:Int
    var startDate:String
    var endDate:String
    var fromCountryString:String
    var toCountryString:String
    var startDateString:String?
    var endDateString:String?
    
    init() {
        self.fromCountry = 0
        self.toCountry = 0
        self.startDate = ""
        self.endDate = ""
        self.fromCountryString = ""
        self.toCountryString = ""
    }
}
