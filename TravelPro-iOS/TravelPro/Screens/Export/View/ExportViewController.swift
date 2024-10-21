//
//  ExportViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-31 on 26/05/23.
//

import UIKit

class ExportViewController: UIViewController, UITextFieldDelegate {

    struct Person {
        let name: String
        let age: Int
        let email: String
    }
    
    enum FileDownloadType: String {
        case pdf
        case csv
    }

    @IBOutlet var csvBtn : UIButton?
    @IBOutlet weak var countryTextfield: FloatingTF!
    @IBOutlet weak var startDateTextfield: FloatingTF!
    @IBOutlet weak var emailTextfield: FloatingTF!
    @IBOutlet var meCheckBtn : UIButton?
    @IBOutlet var customCheckBtn : UIButton?
    @IBOutlet var meEmailLbl : UILabel?
    @IBOutlet weak var btnPDF: UIButton!
    @IBOutlet weak var btnCSV: UIButton!
    @IBOutlet weak var emailTypeView: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var yearView: UIView!
    
    var startDatePicker = UIPickerView()
    var countryId = 0
    var dates = [String]()
    var selectedDate = ""
    var exportViewModel = ExportViewModel()
    var exportEntity = [ExportEntity]()
    var emailTxt = ""
    var tag = 2
    var userEmail = ""
    var fileType:FileDownloadType = .pdf
    

    override func viewDidLoad() {
        super.viewDidLoad()
        TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - viewDidLoad"))

        csvBtn?.underline()
        // Do any additional setup after loading the view.

        //threshold picker setup
        startDatePicker.delegate = self
        startDatePicker.tag = 1
        startDateTextfield.delegate = self
        startDateTextfield.tintColor = .clear
        startDateTextfield.inputView = startDatePicker
        setupStartDateDatePicker()

        userEmail = UserDefaultModule.shared.getUseremail() ?? ""

        meEmailLbl?.text = "Me (\(userEmail))"
    }


    override func viewWillAppear(_ animated: Bool) {
        TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - viewWillAppear"))

        self.countryId = 1
        self.selectedDate = ""
        countryTextfield.text = "ALL"
        startDateTextfield.text = ""
        emailTextfield.text = ""

        setupUI()
        checkYearCountrySelected()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.countryId = 0
        self.selectedDate = ""
    }
    
    private func setupUI() {
        self.countryView.addShadow()
        self.emailTypeView.addShadow()
        self.yearView.addShadow()
    }

    private func setupStartDateDatePicker(){
        TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - setupStartDateDatePicker"))

        // Swift
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: Date())
        let yearInt = Int(year) ?? 0

        dates.append("\(yearInt-2)")
        dates.append("\(yearInt-1)")
        dates.append("\(yearInt)")

        let toolbar = createPickerToolbar(4)
        startDateTextfield.inputAccessoryView = toolbar
        startDateTextfield.inputView = startDatePicker
        startDatePicker.sizeToFit()

     }

    @objc private func cancelDatePicker(){
       self.view.endEditing(true)
     }

    @objc func doneStartDatePicker(){
        TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - doneStartDatePicker"))

        if selectedDate == ""{
            let component = 0
            let row = startDatePicker.selectedRow(inComponent: component)
            let title = startDatePicker.delegate?.pickerView?(startDatePicker, titleForRow: row, forComponent: component)
            selectedDate = title ?? ""
        }
        self.view.endEditing(true)
        startDateTextfield.text = selectedDate
        checkYearCountrySelected()
        
    }

    private func createPickerToolbar(_ tag:Int) -> UIToolbar {
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        var doneButton = UIBarButtonItem()

        doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneStartDatePicker))

         let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
       let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        return toolbar
    }

    @IBAction func fromCountryAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - fromCountryAction"))
        let country = SelectTravelCountryViewController.loadFromNib()
        country.countryType = .fromCountry
        country.delegate = self
        country.fromExport = true
        self.present(country, animated: true)
    }
    
    @IBAction func btnPDFAction(_ sender: UIButton) {
        let myimage = UIImage(named: "Radio")
        fileType = .pdf
        if buttonImageIsEqualToYourImage(button: self.btnPDF, yourImage: myimage!) {
            // Button's image is equal to your image.
            self.btnPDF.setImage(UIImage(named: "Radio-1"), for: .normal)
            self.btnCSV.setImage(UIImage(named: "Radio"), for: .normal)
        } else {
            // Button's image is different from your image.
            self.btnPDF.setImage(UIImage(named: "Radio"), for: .normal)
            self.btnCSV.setImage(UIImage(named: "Radio-1"), for: .normal)
        }
    }
    
    func buttonImageIsEqualToYourImage(button: UIButton, yourImage: UIImage) -> Bool {
        guard let buttonImage = button.image(for: .normal),
              let yourImageName = yourImage.accessibilityIdentifier else {
            return false
        }
        
        return buttonImage.accessibilityIdentifier == yourImageName
    }
    @IBAction func btnCSVAction(_ sender: UIButton) {
        
        let myimage = UIImage(named: "Radio")
        fileType = .csv
        if buttonImageIsEqualToYourImage(button: self.btnCSV, yourImage: myimage!) {
            // Button's image is equal to your image.
            self.btnCSV.setImage(UIImage(named: "Radio-1"), for: .normal)
            self.btnPDF.setImage(UIImage(named: "Radio"), for: .normal)
        } else {
            // Button's image is different from your image.
            self.btnCSV.setImage(UIImage(named: "Radio"), for: .normal)
            self.btnPDF.setImage(UIImage(named: "Radio-1"), for: .normal)
        }
    }

    func checkYearCountrySelected(){
        TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - checkYearCountrySelected"))
        csvBtn?.isEnabled = false
        if selectedDate != ""{
            csvBtn?.isEnabled = true
        }
    }

    @IBAction func downloadCSVButtonAction(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - downloadCSVButtonAction"))
        downloadPdfOrCsvAPICall(fileType: fileType, exportType: "export", email: emailTxt)
    }

    @IBAction func SendReportButtonAction(_ sender: UIButton) {

        emailTxt = tag == 1 ? userEmail : emailTextfield?.text ?? ""

        if countryTextfield.text == ""{
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Please select country", image:nil,theme: .custom)
        }
        else if selectedDate == ""{

            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Please select year", image:nil,theme: .custom)
        }
        else if emailTxt == ""{

            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Please select or enter email", image:nil,theme: .custom)
        }
        else if tag == 2 && !self.emailTextfield.isValidEmail() {
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Enter valid email", image:nil,theme: .custom)
        }
        else{
            downloadPdfOrCsvAPICall(fileType: fileType, exportType: "send", email: emailTxt)
        }

    }

    @IBAction func didClickMeCheckButtonAction(_ sender: UIButton) {
        if sender.tag == 1{
            customCheckBtn?.setImage(UIImage(named: "uncheck.png"), for: .normal)
            if let image = UIImage(named: "Check.png") {
                meCheckBtn?.setImage(image, for: .normal)
            }
            tag = 1
        }
       else
        {
           if let image = UIImage(named: "uncheck.png") {
               meCheckBtn?.setImage(image, for: .normal)
           }
        }
        self.emailTextfield.text = ""
        self.emailTypeView.isUserInteractionEnabled = false
    }

    @IBAction func didClickCustomCheckButtonAction(_ sender: UIButton) {
        if sender.tag == 2{
            meCheckBtn?.setImage(UIImage(named: "uncheck.png"), for: .normal)
            if let image = UIImage(named: "Check.png") {
                customCheckBtn?.setImage(image, for: .normal)
            }
            tag = 2
        }
       else
        {
           if let image = UIImage(named: "uncheck.png") {
               customCheckBtn?.setImage(image, for: .normal)
           }
        }
        self.emailTypeView.isUserInteractionEnabled = true
    }


    private func createCSV() -> Void {
        TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - downloadCSVAPICall: createCSV"))

        let fileName = getDocumentsDirectory().appendingPathComponent("TravelTax.csv")
        let csvOutputText = convertToCSV(data: self.exportEntity)

        do {
            try csvOutputText.write(to: fileName, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - downloadCSVAPICall: createCSV Failed to create file \(error)"))
        }
        let activity = UIActivityViewController(activityItems: [csvOutputText, fileName], applicationActivities: nil)
        present(activity, animated: true)
    }
    
    private func createFileAndShow(fileType:FileDownloadType,filrUrlString:String) {
        TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - createFileAndShow"))

        convertUrlToData(url: filrUrlString, fileType: fileType)

    }
    
    private func createPDF() -> Void {
        TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - downloadCSVAPICall: createPDF"))

        let fileName = getDocumentsDirectory().appendingPathComponent("TravelTax.pdf")
        let csvOutputText = convertToPDF(data: self.exportEntity)

        do {
            try csvOutputText.write(to: fileName, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - downloadCSVAPICall: createCSV Failed to create file \(error)"))
        }
        let activity = UIActivityViewController(activityItems: [csvOutputText, fileName], applicationActivities: nil)
        present(activity, animated: true)
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }


    func convertToCSV(data: [ExportEntity]) -> String {
//        var csvString = "from,to,origin,designation,physicalPresenceDay,numberofTaxableDays,workDays,nonWorkDays,definitionofDay\n" //OLD FORMAT
        var csvString = "From,To,PhysicalPresenceDay,NumberofTaxableDays,WorkDays,NonWorkDays,DefinitionofDay,TaxStartYear,TaxEndYear\n" //NEW FORMAT

        for person in data {
//            let row = "\(person.from ?? ""),\(person.to ?? ""),\(person.origin ?? ""),\(person.designation ?? ""),\(person.physicalPresenceDay ?? 0),\(person.numberofTaxableDays ?? 0),\(person.workDays ?? 0),\(person.nonWorkDays ?? ""),\(person.definitionofDay ?? "")\n" //OLD FORMAT
            let row = "\(person.from ?? ""),\(person.to ?? ""),\(person.physicalPresenceDay ?? 0),\(person.numberofTaxableDays ?? 0),\(person.workDays ?? 0),\(person.nonWorkDays ?? ""),\(person.definitionofDay ?? ""),\(person)\n" //NEW FORMAT
            csvString.append(row)
        }
        TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - convertToCSV \(csvString)"))
        return csvString
    }
    
    func convertUrlToData(url:String,fileType:FileDownloadType) {
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: url)
            let pdfData = try? Data.init(contentsOf: url!)
            var pathName = ""
            switch fileType {
            case .pdf:
                pathName = "TravelTaxDay_\(String.random()).pdf"
            default:
                pathName = "TravelTaxDay_\(String.random()).csv"
            }
            let actualPath = self.getDocumentsDirectory().appendingPathComponent(pathName)
     
            do {
                TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "convertUrlToData - convertToCSV try"))
                try pdfData?.write(to: actualPath, options: .atomic)
            } catch {
                TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "convertUrlToData - Pdf could not be saved"))
            }
            
            DispatchQueue.main.async {
                let activity = UIActivityViewController(activityItems: [pdfData ?? Data(), actualPath], applicationActivities: nil)
                self.present(activity, animated: true)
            }
        }

    }
    
    func convertToPDF(data: [ExportEntity]) -> String {
//        var csvString = "from,to,origin,designation,physicalPresenceDay,numberofTaxableDays,workDays,nonWorkDays,definitionofDay\n" //OLD FORMAT
        var csvString = "From,To,PhysicalPresenceDay,NumberofTaxableDays,WorkDays,NonWorkDays,DefinitionofDay,TaxStartYear,TaxEndYear\n" //NEW FORMAT

        for person in data {
//            let row = "\(person.from ?? ""),\(person.to ?? ""),\(person.origin ?? ""),\(person.designation ?? ""),\(person.physicalPresenceDay ?? 0),\(person.numberofTaxableDays ?? 0),\(person.workDays ?? 0),\(person.nonWorkDays ?? ""),\(person.definitionofDay ?? "")\n" //OLD FORMAT
            let row = "\(person.from ?? ""),\(person.to ?? ""),\(person.physicalPresenceDay ?? 0),\(person.numberofTaxableDays ?? 0),\(person.workDays ?? 0),\(person.nonWorkDays ?? ""),\(person.definitionofDay ?? ""),\(person)\n" //NEW FORMAT
            csvString.append(row)
        }
        TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - convertToPDF \(csvString)"))
        return csvString
    }


    //MARK: download CSV API Call

    func downloadPdfOrCsvAPICall(fileType:FileDownloadType,exportType:String,email:String) {
        
        let countryID = countryTextfield.text == "ALL" ? "" : countryTextfield.text
        
        self.exportViewModel.exportEmailAndDownload(countryId: countryID ?? "" , year: selectedDate ,exportType: exportType, email: email,fileType: fileType.rawValue,controller: self, enableLoader: true) { response in
            
            switch response.status {
                case 200:
                switch exportType {
                  case "export":
                    TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - downloadCSVAPICall download success: \(response)"))
                    self.createFileAndShow(fileType: fileType, filrUrlString: response.msg ?? "")
                  default:
                    TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - downloadPdfOrCsvAPICall send report success: \(response)"))
                    utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Report sent successfully", image:nil,theme: .custom)
                }
                default:
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "\(response.msg ?? "")", image:nil,theme: .custom)
            }
            
            
        } onFailure: { error in
            TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - downloadPdfOrCsvAPICall error: \(error)"))
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }
        
    }

    func SendReportAPICall() {
        
        let countryID = countryTextfield.text == "ALL" ? "" : countryTextfield.text
        
        self.exportViewModel.SendReportAPI(countryId: countryID ?? "" , year: selectedDate, email: emailTxt , controller: self, enableLoader: true) { response in

            if response.status == 200{
                TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - SendReportAPICall success: \(response)"))
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: "Report sent successfully", image:nil,theme: .custom)

                print("Success")

            }

            } onFailure: { error in
                TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - SendReportAPICall Error: \(error)"))
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
            }

  }


// MARK: - UnitTestcase
    
    func unitTestcase() {
        self.doneStartDatePicker()
        self.fromCountryAction(UIButton())
        self.btnPDFAction(UIButton())
        self.btnCSVAction(UIButton())
        self.SendReportButtonAction(UIButton())
        self.didClickMeCheckButtonAction(UIButton())
        self.didClickCustomCheckButtonAction(UIButton())
        self.createCSV()
        self.createPDF()
        convertUrlToData(url: "https://test.sample.pdf", fileType: .pdf)
        downloadPdfOrCsvAPICall(fileType: .pdf, exportType: "export", email: "test@test.com")
        SendReportAPICall()
    }

}

extension ExportViewController:SelectTravelCountryDelegate,UIPickerViewDataSource,UIPickerViewDelegate {

    //MARK: - PickerView

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }

       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return self.dates.count
       }

       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

           return self.dates[row]
       }

       func view(forRow row: Int, forComponent component: Int) -> UIView? {
           let label =  UILabel()
           return label
       }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          let date = self.dates[row]
          // Date that the user select.
          selectedDate = date
      }


    //MARK: - SelectTravelCountryDelegate
    func didSelectedCountry(country: CountryListModel?, type: CountryType) {
        if let data = country {

               self.countryId = data.countryId
                countryTextfield.text = data.countryName
                checkYearCountrySelected()
        }
    }

}


extension UIImage {

    func saveToDocuments(filename:String) {
        TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - saveToDocuments"))
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        if let data = self.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: fileURL)
                TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - saveToDocuments fileURL \(fileURL)"))
            } catch {
                print("error saving file to documents:", error)
                TravelTaxMixPanelAnalytics(action: .export, state: .info, data: MixPanelData(message: "ExportViewController - saveToDocuments error saving file to documents \(error)"))
            }
        }
    }

}


