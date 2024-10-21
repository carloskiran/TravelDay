//
//  SelectTravelCountryViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 05/05/23.
//

import UIKit

protocol SelectTravelCountryDelegate: AnyObject {
    func didSelectedCountry(country:CountryListModel?,type:CountryType)
}

class SelectTravelCountryViewController: UIViewController {

    // MARK: - Properties

    private lazy var countriesList:[CountryListModel] = [] {
        didSet{
            tableview.reloadData()
        }
    }
    weak var delegate: SelectTravelCountryDelegate!
    private var selectedCountry:CountryListModel!
    var countryType:CountryType = .fromCountry
    var fromExport = Bool()
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var selectCountryButton: CustomButton!
    
    // MARK: - View life cycle
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        TravelTaxMixPanelAnalytics(action: .selectTravelCountry, state: .info, data: MixPanelData(message: "SelectTravelCountryViewController - viewDidLoad"))
        setupUI()
        if fromExport {
            var countriesListDetails = self.getCountries()
            let allCountry = CountryListModel(phoneCode: "", isoCode: "0", countryId: 248, countryName: "ALL", dnTotalNumber: 0)
            countriesListDetails.insert(allCountry, at: 0)
            self.countriesList = countriesListDetails
        } else {
            self.countriesList = self.getCountries()
        }
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Private methods
    
    /// SetupUI
    private func setupUI() {
        TravelTaxMixPanelAnalytics(action: .selectTravelCountry, state: .info, data: MixPanelData(message: "SelectTravelCountryViewController - setupUI"))
        self.tableview.register(UINib(nibName: SelectCountryTableViewCell.TableReuseIdentifier, bundle: nil),forCellReuseIdentifier: SelectCountryTableViewCell.TableReuseIdentifier)
        searchTextField.addTarget(self, action: #selector(textFieldChanged), for: .allEditingEvents)
        searchTextField.tag = 1
    }
    
    /// - Returns: Country array
    private func getCountries() -> [CountryListModel] {
        TravelTaxMixPanelAnalytics(action: .selectTravelCountry, state: .info, data: MixPanelData(message: "SelectTravelCountryViewController - getCountries"))
        guard let path = Bundle.main.path(forResource: "customTravelCountries", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return [] }
        return (try? JSONDecoder().decode([CountryListModel].self, from: data)) ?? []
    }
    
    /// Text Field Changed
    /// - Parameter sender: UITextField
    @objc
    private func textFieldChanged(sender: UITextField) {
        if let textField = self.view.viewWithTag(sender.tag) as? UITextField {
            if textField.tag == 1 {
                if sender.isEditing {
                    if textField.text?.count == 0 {
                        if selectedCountry == nil {
                            if fromExport {
                                var countriesListDetails = self.getCountries()
                                let allCountry = CountryListModel(phoneCode: "", isoCode: "0", countryId: 248, countryName: "ALL", dnTotalNumber: 0)
                                countriesListDetails.insert(allCountry, at: 0)
                                self.countriesList = countriesListDetails
                            } else {
                                self.countriesList = self.getCountries()
                            }
                        }
                    } else {
                        if let searchText = textField.text {
                            if fromExport {
                                var countriesListDetails = self.getCountries()
                                let allCountry = CountryListModel(phoneCode: "", isoCode: "0", countryId: 248, countryName: "ALL", dnTotalNumber: 0)
                                countriesListDetails.insert(allCountry, at: 0)
                                let filtered = countriesListDetails.filter {
                                    return $0.countryName.range(of: searchText, options: [.caseInsensitive,.anchored]) != nil
                                }
                                self.countriesList = filtered
                            } else {
                                let filtered = self.getCountries().filter {
                                    return $0.countryName.range(of: searchText, options: [.caseInsensitive,.anchored]) != nil
                                }
                                self.countriesList = filtered
                            }
                        }
                    }
                    self.tableview.reloadData()
                }
               
            }
            
        }
    }
        
        // MARK: - User interactions
    @IBAction func selectCountryAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .selectTravelCountry, state: .info, data: MixPanelData(message: "SelectTravelCountryViewController - selectCountryAction"))
        self.delegate.didSelectedCountry(country: self.selectedCountry, type: countryType)
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    }


// MARK: - Extension

extension SelectTravelCountryViewController: UITableViewDataSource, UITableViewDelegate {
   
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countriesList.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        TravelTaxMixPanelAnalytics(action: .selectTravelCountry, state: .info, data: MixPanelData(message: "SelectTravelCountryViewController - UITableViewDelegate - cellForRowAt"))
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
//            for view in cell.contentView.subviews {
//                view.removeFromSuperview()
//            }
//
//            let selectedImage = UIImageView()
//            selectedImage.frame = CGRect(x: tableView.frame.size.width-35.0, y: (52-25)/2, width: 25.0, height: 25.0)
//            selectedImage
//
//            let titleLbl = UILabel()
//            titleLbl.text = "All"
//            titleLbl.frame = CGRect(x: 20.0, y: 11.0, width: tableView.frame.size.width-40, height: 30.0)
//            cell.contentView.addSubview(titleLbl)
//            cell.selectionStyle = .none
//            return cell
//        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectCountryTableViewCell.TableReuseIdentifier, for: indexPath) as? SelectCountryTableViewCell else { return UITableViewCell() }
        cell.updateUI(self.countriesList[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TravelTaxMixPanelAnalytics(action: .selectTravelCountry, state: .info, data: MixPanelData(message: "SelectTravelCountryViewController - UITableViewDelegate - didSelectRowAt"))
        if self.countriesList.count > 0 {
            self.selectCountryButton.isHidden = false
            selectedCountry = self.countriesList[indexPath.row]
        }
    }
}


// MARK: - Struct

struct CountryListModel: Codable {
    let phoneCode: String
    let isoCode: String
    let countryId: Int
    let countryName: String
    let dnTotalNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case phoneCode = "DC_COUNTRY_DIAL_CODE"
        case isoCode = "DC_COUNTRY_CODE"
        case countryId = "DN_COUNTRY_ID"
        case countryName = "DC_COUNTRY_NAME"
        case dnTotalNumber = "DN_TOTAL_NUMBER"
    }
}

 extension CountryListModel {
    /// Returns localized country name for localeIdentifier
    var localizedName: String {
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: isoCode])
        var name = NSLocale(localeIdentifier: NSLocale.current.identifier)
            .displayName(forKey: NSLocale.Key.identifier, value: id) ?? isoCode
        if isoCode == "0" {
            name = "All"
        }
        return name
    }
}
