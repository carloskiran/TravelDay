//
//  CreateNewTravel+TableViewDelegateExtension.swift
//  TravelPro
//
//  Created by MAC-OBS-48 on 11/09/23.
//

import Foundation
import UIKit



extension CreateNewTravelViewController: UITableViewDataSource, UITableViewDelegate {
   
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return isTravelAndHotelEnable ? self.travelApiCallingEnable.count : 0
        case 1:
            return isFoodAndEntertainmentEnable ? self.foodApiCallingEnable.count  : 0
        case 2:
            return isShoppingAndUntilityEnable ? self.shoppingApiCallingEnable.count : 0
        case 3:
            return isOtherEnable ? self.othersApiCallingEnable.count : 0
        default:
            return 0
        }
    }
    
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - UITableViewDelegate - cellForRowAt"))
        switch indexPath.section {
        case 0:
            var indexReading = "\(indexPath.row)"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
            var urlItem = self.travelAndHotelArray[indexReading]
            if urlItem == nil, self.travelAndHotelArray.count == 1, let indexValue = self.travelAndHotelArray.keys.first {
                urlItem = self.travelAndHotelArray[indexValue]
                indexReading = indexValue
            }
            if let urlItem = urlItem, self.travelApiCallingEnable[indexReading] == "start" {
                cell.setupProgressView()
                self.travelApiCallingEnable.updateValue("processing", forKey: "\(indexPath.row)")
                cell.apiConfiguration(fileURL: urlItem, fileType: urlItem.pathExtension, indexValue: indexPath.row, categoryName: self.selectedDocumentCategory)
                cell.documentCloseBtn.isHidden = true
            } else if self.travelApiCallingEnable[indexReading] == "completed" {
                var separateName = String()
                if let docName = urlItem?.lastPathComponent {
                    if docName.components(separatedBy: "_traveltax_").count > 1 {
                        separateName = docName.components(separatedBy: "_traveltax_")[1]
                        cell.uploadReadingLbl.isHidden = true
                    } else {
                        separateName = docName
                    }
                }
                cell.documentNameLbl.text = separateName
                cell.progressView.isHidden = true
                cell.uploadReadingLbl.isHidden = true
                cell.documentCloseBtn.isHidden = false
                if let fileType = urlItem?.pathExtension{
                    cell.imgFileType.image = UIImage(named: fileType.uppercased())
                }
            } else if self.travelApiCallingEnable[indexReading] == "processing" {
                cell.progressView.isHidden = false
                cell.documentCloseBtn.isHidden = true
                cell.uploadReadingLbl.isHidden = false
            }
            cell.uploadedImg = self
            cell.documentCloseBtn.accessibilityLabel = "\(indexPath.section)"
            cell.documentCloseBtn.tag = indexPath.row
            cell.documentCloseBtn.addTarget(self, action: #selector(removeCellBtnTapped(_:)), for: .touchUpInside)
            let userdefault = UserDefaults.standard
            let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
            if isDarkMode {
                cell.stackView.layer.cornerRadius = 3
                cell.stackView.layer.borderColor = UIColor.lightGray.cgColor
                cell.stackView.layer.borderWidth = 0.7
            }
            return cell
        case 1:
            var indexReading = "\(indexPath.row)"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
            var urlItem = self.foodAndEntertainment[indexReading]
            if urlItem == nil, self.foodAndEntertainment.count == 1, let indexValue = self.foodAndEntertainment.keys.first {
                urlItem = self.foodAndEntertainment[indexValue]
                indexReading = indexValue
            }
            if let urlItem = urlItem, self.foodApiCallingEnable[indexReading] == "start" {
                cell.setupProgressView()
                self.foodApiCallingEnable.updateValue("processing", forKey: "\(indexPath.row)")
                cell.apiConfiguration(fileURL: urlItem, fileType: urlItem.pathExtension, indexValue: indexPath.row, categoryName: self.selectedDocumentCategory)
                cell.documentCloseBtn.isHidden = true
            } else if self.foodApiCallingEnable[indexReading] == "completed" {
                var separateName = String()
                if let docName = urlItem?.lastPathComponent {
                    if docName.components(separatedBy: "_traveltax_").count > 1 {
                        separateName = docName.components(separatedBy: "_traveltax_")[1]
                        cell.uploadReadingLbl.isHidden = true
                    } else {
                        separateName = docName
                    }
                }
                cell.documentNameLbl.text = separateName
                cell.progressView.isHidden = true
                cell.uploadReadingLbl.isHidden = true
                cell.documentCloseBtn.isHidden = false
            } else if self.foodApiCallingEnable[indexReading] == "processing" {
                cell.progressView.isHidden = false
                cell.documentCloseBtn.isHidden = true
                cell.uploadReadingLbl.isHidden = false
            }
            cell.uploadedImg = self
            cell.documentCloseBtn.accessibilityLabel = "\(indexPath.section)"
            cell.documentCloseBtn.tag = indexPath.row
            cell.documentCloseBtn.addTarget(self, action: #selector(removeCellBtnTapped(_:)), for: .touchUpInside)
            if let fileType = urlItem?.pathExtension{
                cell.imgFileType.image = UIImage(named: fileType.uppercased())
            }
            let userdefault = UserDefaults.standard
            let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
            if isDarkMode {
                cell.stackView.layer.cornerRadius = 3
                cell.stackView.layer.borderColor = UIColor.lightGray.cgColor
                cell.stackView.layer.borderWidth = 0.7
            }
            return cell
        case 2:
            var indexReading = "\(indexPath.row)"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
            var urlItem = self.shoppingAndUtility[indexReading]
            if urlItem == nil, self.shoppingAndUtility.count == 1, let indexValue = self.shoppingAndUtility.keys.first {
                urlItem = self.shoppingAndUtility[indexValue]
                indexReading = indexValue
            }
            if let urlItem = urlItem, self.shoppingApiCallingEnable[indexReading] == "start" {
                cell.setupProgressView()
                self.shoppingApiCallingEnable.updateValue("processing", forKey: "\(indexPath.row)")
                cell.apiConfiguration(fileURL: urlItem, fileType: urlItem.pathExtension, indexValue: indexPath.row, categoryName: self.selectedDocumentCategory)
                cell.documentCloseBtn.accessibilityLabel = "\(indexPath.section)"
                cell.documentCloseBtn.isHidden = true
            } else if self.shoppingApiCallingEnable[indexReading] == "completed" {
                var separateName = String()
                if let docName = urlItem?.lastPathComponent {
                    if docName.components(separatedBy: "_traveltax_").count > 1 {
                        separateName = docName.components(separatedBy: "_traveltax_")[1]
                        cell.uploadReadingLbl.isHidden = true
                    } else {
                        separateName = docName
                    }
                }
                cell.documentNameLbl.text = separateName
                cell.progressView.isHidden = true
                cell.uploadReadingLbl.isHidden = true
                cell.documentCloseBtn.isHidden = false
            } else if self.shoppingApiCallingEnable[indexReading] == "processing" {
                cell.progressView.isHidden = false
                cell.documentCloseBtn.isHidden = true
                cell.uploadReadingLbl.isHidden = false
            }
            cell.uploadedImg = self
            cell.documentCloseBtn.tag = indexPath.row
            cell.documentCloseBtn.accessibilityLabel = "\(indexPath.section)"
            cell.documentCloseBtn.addTarget(self, action: #selector(removeCellBtnTapped(_:)), for: .touchUpInside)
            if let fileType = urlItem?.pathExtension{
                cell.imgFileType.image = UIImage(named: fileType.uppercased())
            }
            let userdefault = UserDefaults.standard
            let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
            if isDarkMode {
                cell.stackView.layer.cornerRadius = 3
                cell.stackView.layer.borderColor = UIColor.lightGray.cgColor
                cell.stackView.layer.borderWidth = 0.7
            }
            return cell
        case 3:
            var indexReading = "\(indexPath.row)"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
            var urlItem = self.others[indexReading]
            if urlItem == nil, self.others.count == 1, let indexValue = self.others.keys.first {
                urlItem = self.others[indexValue]
                indexReading = indexValue
            }
            if let urlItem = urlItem, self.othersApiCallingEnable[indexReading] == "start" {
                cell.setupProgressView()
                self.othersApiCallingEnable.updateValue("processing", forKey: "\(indexPath.row)")
                cell.apiConfiguration(fileURL: urlItem, fileType: urlItem.pathExtension, indexValue: indexPath.row, categoryName: self.selectedDocumentCategory)
                cell.documentCloseBtn.isHidden = true
            } else if self.othersApiCallingEnable[indexReading] == "completed" {
                var separateName = String()
                if let docName = urlItem?.lastPathComponent {
                    if docName.components(separatedBy: "_traveltax_").count > 1 {
                        separateName = docName.components(separatedBy: "_traveltax_")[1]
                        cell.uploadReadingLbl.isHidden = true
                    } else {
                        separateName = docName
                    }
                }
                cell.documentNameLbl.text = separateName
                cell.progressView.isHidden = true
                cell.uploadReadingLbl.isHidden = true
                cell.documentCloseBtn.isHidden = false
            } else if self.othersApiCallingEnable[indexReading] == "processing" {
                cell.progressView.isHidden = false
                cell.documentCloseBtn.isHidden = true
                cell.uploadReadingLbl.isHidden = false
                
            }
            cell.uploadedImg = self
            cell.documentCloseBtn.tag = indexPath.row
            cell.documentCloseBtn.accessibilityLabel = "\(indexPath.section)"
            cell.documentCloseBtn.addTarget(self, action: #selector(removeCellBtnTapped(_:)), for: .touchUpInside)
            if let fileType = urlItem?.pathExtension{
                cell.imgFileType.image = UIImage(named: fileType.uppercased())
            }
            let userdefault = UserDefaults.standard
            let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
            if isDarkMode {
                cell.stackView.layer.cornerRadius = 3
                cell.stackView.layer.borderColor = UIColor.lightGray.cgColor
                cell.stackView.layer.borderWidth = 0.7
            }
            return cell
        default:
            var indexReading = "\(indexPath.row)"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier, for: indexPath) as? AttachmentProgressTableViewCell else { return UITableViewCell() }
            var urlItem = self.pickedImageDictionary[indexReading]
            if urlItem == nil, self.pickedImageDictionary.count == 1, let indexValue = self.pickedImageDictionary.keys.first {
                urlItem = self.pickedImageDictionary[indexValue]
                indexReading = indexValue
            }
            if let urlItem = urlItem, self.apiCallingEnableOrDisable[indexReading] == "start" {
                cell.setupProgressView()
                self.apiCallingEnableOrDisable.updateValue("processing", forKey: "\(indexPath.row)")
                cell.apiConfiguration(fileURL: urlItem, fileType: urlItem.pathExtension, indexValue: indexPath.row, categoryName: self.selectedDocumentCategory)
                cell.documentCloseBtn.isHidden = true
            } else if self.apiCallingEnableOrDisable[indexReading] == "completed" {
                var separateName = String()
                if let docName = urlItem?.lastPathComponent {
                    if docName.components(separatedBy: "_traveltax_").count > 1 {
                        separateName = docName.components(separatedBy: "_traveltax_")[1]
                        cell.uploadReadingLbl.isHidden = true
                    } else {
                        separateName = docName
                    }
                }
                cell.documentNameLbl.text = separateName
                cell.progressView.isHidden = true
                cell.uploadReadingLbl.isHidden = true
                cell.documentCloseBtn.isHidden = false
            } else if self.apiCallingEnableOrDisable[indexReading] == "processing" {
                cell.progressView.isHidden = false
                cell.documentCloseBtn.isHidden = true
                cell.uploadReadingLbl.isHidden = false
            }
            cell.uploadedImg = self
            cell.documentCloseBtn.tag = indexPath.row
            cell.documentCloseBtn.accessibilityLabel = "\(indexPath.section)"
            cell.documentCloseBtn.addTarget(self, action: #selector(removeCellBtnTapped(_:)), for: .touchUpInside)
            if let fileType = urlItem?.pathExtension{
                cell.imgFileType.image = UIImage(named: fileType.uppercased())
            }
            let userdefault = UserDefaults.standard
            let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
            if isDarkMode {
                cell.stackView.layer.cornerRadius = 3
                cell.stackView.layer.borderColor = UIColor.lightGray.cgColor
                cell.stackView.layer.borderWidth = 0.7
            }
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - UITableViewDelegate - viewForHeaderInSection"))
        let headerView = headerDetailsView(titleStr: headerTitleArray[section])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped(_:)))
        headerView.tag = section
        headerView.addGestureRecognizer(tapGesture)
        return headerView
    }
    @objc func headerTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        // You can get the section from the tag property or any other identifier you set
        let section = gestureRecognizer.view?.tag ?? 0
        // Perform any action you want when the header is tapped
        print("Header tapped for section: \(section)")
        if section == 0 {
            if self.travelApiCallingEnable.count > 0 {
                self.isTravelAndHotelEnable = !self.isTravelAndHotelEnable
            }
        }
        if section == 1 {
            if self.foodApiCallingEnable.count > 0 {
                isFoodAndEntertainmentEnable = !isFoodAndEntertainmentEnable
            }
        }
        if section == 2 {
            if self.shoppingApiCallingEnable.count > 0 {
                isShoppingAndUntilityEnable = !isShoppingAndUntilityEnable
            }
        }
        if section == 3 {
            if self.othersApiCallingEnable.count > 0 {
                isOtherEnable = !isOtherEnable
            }
        }
        tableView.reloadData()
        self.setTableviewDynamicHeight()
    }
    
    func headerDetailsView(titleStr: String) -> UIView {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - headerDetailsView"))
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 10, width: tableView.frame.width, height: 55)
        contentView.backgroundColor = UIColor(named: "WhiteAndLightBlue")
        contentView.layer.cornerRadius = 3

        let attachImageView = UIImageView()
        attachImageView.image = UIImage(named: "imageAttach")
        attachImageView.frame = CGRect(x: 10, y: (60-18)/2, width: 20, height: 18)
        contentView.addSubview(attachImageView)
        
        let titleLbl = UILabel()
        titleLbl.frame = CGRect(x: 45, y: 17, width: 150, height: 30)
        titleLbl.text = titleStr
        titleLbl.textColor = UIColor(named: "GrayColor")
        titleLbl.font = .fontR14
        contentView.addSubview(titleLbl)
        
        switch titleStr {
        case "Travel and Hotel":
            switch travelApiCallingEnable.count {
            case 0:
                let dropImage = setDropImage(imageName: "dropGray")
                contentView.addSubview(dropImage)
            default:
                var dropImage = UIImageView()
                if isTravelAndHotelEnable {
                    dropImage = setDropImage(imageName: "upGray")
                } else {
                    dropImage = setDropImage(imageName: "dropGray")
                }
                contentView.addSubview(dropImage)
            }
        case "Food and Entertainment":
            switch foodApiCallingEnable.count {
            case 0:
                let dropImage = setDropImage(imageName: "dropGray")
                contentView.addSubview(dropImage)
            default:
                var dropImage = UIImageView()
                if isFoodAndEntertainmentEnable {
                    dropImage = setDropImage(imageName: "upGray")
                } else {
                    dropImage = setDropImage(imageName: "dropGray")
                }
                contentView.addSubview(dropImage)
            }
        case "Shopping and Utility":
            switch shoppingApiCallingEnable.count {
            case 0:
                let dropImage = setDropImage(imageName: "dropGray")
                contentView.addSubview(dropImage)
            default:
                var dropImage = UIImageView()
                if isShoppingAndUntilityEnable {
                    dropImage = setDropImage(imageName: "upGray")
                } else {
                    dropImage = setDropImage(imageName: "dropGray")
                }
                contentView.addSubview(dropImage)
            }
        default:
            switch othersApiCallingEnable.count {
            case 0:
                let dropImage =  setDropImage(imageName: "dropGray")
                contentView.addSubview(dropImage)
            default:
                var dropImage = UIImageView()
                if isOtherEnable {
                    dropImage = setDropImage(imageName: "upGray")
                } else {
                    dropImage = setDropImage(imageName: "dropGray")
                }
                contentView.addSubview(dropImage)
            }
        }
        
        let mainView = UIView()
        mainView.frame = CGRect(x: 0, y: 10, width: tableView.frame.width, height: 65)
        mainView.backgroundColor = UIColor(named: "lightBlueAndGray")
        mainView.addSubview(contentView)
        
        // Initialization code
        let userdefault = UserDefaults.standard
        let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
        if isDarkMode {
            contentView.layer.cornerRadius = 3
            contentView.layer.borderColor = UIColor.lightGray.cgColor
            contentView.layer.borderWidth = 0.7
        }
        return mainView
    }
    
    func setDropImage(imageName:String) -> UIImageView {
        let dropdown = UIImageView()
        dropdown.image = UIImage(named: imageName)
        dropdown.frame = CGRect(x: tableView.frame.width - 28, y: (60-7)/2, width: 14, height: 7)
        return dropdown
    }
    
    @objc func removeCellBtnTapped(_ sender: UIButton) {
        TravelTaxMixPanelAnalytics(action: .createNewTravel, state: .info, data: MixPanelData(message: "CreateNewTravelViewController - removeCellBtnTapped"))
        print(sender.tag)
        switch sender.accessibilityLabel {
        case "0":
            var duplicateImgDict = self.travelAndHotelArray
            var indexValueForDelete = "\(sender.tag)"
            let sortedArray = duplicateImgDict.sorted { int1, int2 in
                return int1.key < int2.key
            }
            print(duplicateImgDict)
            print(sortedArray)
            let dict = Dictionary(uniqueKeysWithValues: sortedArray.map {($0.key, $0.value)})
            print(dict)
            print(duplicateImgDict)
            let delete = duplicateImgDict.filter { int1 in
                let keys = int1.value
                return keys.absoluteString.range(of: "private/var") != nil
            }
            if delete.count == 1, let keylist = self.travelAndHotelArray.keys.first, keylist != indexValueForDelete {
                indexValueForDelete = keylist
            }
            let urlName = duplicateImgDict[indexValueForDelete]
            duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: indexValueForDelete)
            print(duplicateImgDict)
            self.travelApiCallingEnable.removeValue(forKey: "\(sender.tag)")
            var duplicateDocumentArray = self.travelAndHoterlDocumentArray
            for item in 0..<self.travelAndHoterlDocumentArray.count {
                if travelAndHoterlDocumentArray[item].range(of: urlName?.lastPathComponent ?? "") != nil {
                    let docName = travelAndHoterlDocumentArray[item]
                    duplicateDocumentArray.remove(at: item)
                    AWSManager.shared.deleteUploadDocument(documentName: docName)
                }
            }
            self.travelAndHoterlDocumentArray = duplicateDocumentArray
            if sender.tag < 4 {
                for n in sender.tag..<3 {
                    duplicateImgDict.updateValue(self.travelAndHotelArray["\(n+1)"]!, forKey: "\(n)")
                }
                duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: "3")
            }
            
            let duplicateAPICalling = self.travelApiCallingEnable
            // Sort the dictionary keys in ascending order
            let sortedKeys = duplicateAPICalling.keys.sorted { Int($0)! < Int($1)! }
            // Create a new dictionary with updated sequential index keys
            var updatedDictionary: [String: String] = [:]
            var currentIndex = 0
            for key in sortedKeys {
                updatedDictionary[String(currentIndex)] = duplicateAPICalling[key]
                currentIndex += 1
            }
            travelApiCallingEnable = updatedDictionary
            self.travelAndHotelArray = duplicateImgDict
        case "1":
            var duplicateImgDict = self.foodAndEntertainment
            var indexValueForDelete = "\(sender.tag)"
            let sortedArray = duplicateImgDict.sorted { int1, int2 in
                return int1.key < int2.key
            }
            let delete = duplicateImgDict.filter { int1 in
                let keys = int1.value
                return keys.absoluteString.range(of: "private/var") != nil
            }
            _ = Dictionary(uniqueKeysWithValues: sortedArray.map {($0.key, $0.value)})
            if delete.count == 1, let keylist = self.foodAndEntertainment.keys.first, keylist != indexValueForDelete {
                indexValueForDelete = keylist
            }
            let urlName = duplicateImgDict[indexValueForDelete]
            duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: indexValueForDelete)
            self.foodApiCallingEnable.removeValue(forKey: "\(sender.tag)")
            var duplicateDocumentArray = self.foodAndEntertainmentDocumentArray
            for item in 0..<self.foodAndEntertainmentDocumentArray.count {
                if foodAndEntertainmentDocumentArray[item].range(of: urlName?.lastPathComponent ?? "") != nil {
                    let docName = foodAndEntertainmentDocumentArray[item]
                    duplicateDocumentArray.remove(at: item)
                    print(self.foodAndEntertainmentDocumentArray)
                    AWSManager.shared.deleteUploadDocument(documentName: docName)
                }
            }
            self.foodAndEntertainmentDocumentArray = duplicateDocumentArray
            if sender.tag < 4 {
                for n in sender.tag..<3 {
                    duplicateImgDict.updateValue(self.foodAndEntertainment["\(n+1)"]!, forKey: "\(n)")
                }
                duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: "3")
            }
            let duplicateAPICalling = self.foodApiCallingEnable
            // Sort the dictionary keys in ascending order
            let sortedKeys = duplicateAPICalling.keys.sorted { Int($0)! < Int($1)! }
            // Create a new dictionary with updated sequential index keys
            var updatedDictionary: [String: String] = [:]
            var currentIndex = 0
            for key in sortedKeys {
                updatedDictionary[String(currentIndex)] = duplicateAPICalling[key]
                currentIndex += 1
            }
            self.foodApiCallingEnable = updatedDictionary
            self.foodAndEntertainment = duplicateImgDict
        case "2":
            var duplicateImgDict = self.shoppingAndUtility
            var indexValueForDelete = "\(sender.tag)"
            let sortedArray = duplicateImgDict.sorted { int1, int2 in
                return int1.key < int2.key
            }
            if self.shoppingApiCallingEnable.count == 1 {
                print(self.shoppingApiCallingEnable)
            }
            print(duplicateImgDict)
            print(sortedArray)
            let dict = Dictionary(uniqueKeysWithValues: sortedArray.map {($0.key, $0.value)})
            print(dict)
            print(duplicateImgDict)
            let delete = duplicateImgDict.filter { int1 in
                let keys = int1.value
                return keys.absoluteString.range(of: "private/var") != nil
            }
            if delete.count == 1, let keylist = self.shoppingAndUtility.keys.first, keylist != indexValueForDelete {
                indexValueForDelete = keylist
            }
            let urlName = duplicateImgDict[indexValueForDelete]
            duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: indexValueForDelete)
            print(duplicateImgDict)
            self.shoppingApiCallingEnable.removeValue(forKey: "\(sender.tag)")
            var duplicateDocumentArray = self.shoppingAndUtilityDocumentArray
            for item in 0..<self.shoppingAndUtilityDocumentArray.count {
                if shoppingAndUtilityDocumentArray[item].range(of: urlName?.lastPathComponent ?? "") != nil {
                    let docName = shoppingAndUtilityDocumentArray[item]
                    duplicateDocumentArray.remove(at: item)
                    AWSManager.shared.deleteUploadDocument(documentName: docName)
                }
            }
            self.shoppingAndUtilityDocumentArray = duplicateDocumentArray
            if sender.tag < 4 {
                for n in sender.tag..<3 {
                    duplicateImgDict.updateValue(self.shoppingAndUtility["\(n+1)"]!, forKey: "\(n)")
                }
                duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: "3")
            }
            
            let duplicateAPICalling = self.shoppingApiCallingEnable
            // Sort the dictionary keys in ascending order
            let sortedKeys = duplicateAPICalling.keys.sorted { Int($0)! < Int($1)! }
            // Create a new dictionary with updated sequential index keys
            var updatedDictionary: [String: String] = [:]
            var currentIndex = 0
            for key in sortedKeys {
                updatedDictionary[String(currentIndex)] = duplicateAPICalling[key]
                currentIndex += 1
            }
            self.shoppingApiCallingEnable = updatedDictionary
            self.shoppingAndUtility = duplicateImgDict
        case "3":
            var duplicateImgDict = self.others
            var indexValueForDelete = "\(sender.tag)"
            let sortedArray = duplicateImgDict.sorted { int1, int2 in
                return int1.key < int2.key
            }
            print(duplicateImgDict)
            print(sortedArray)
            let dict = Dictionary(uniqueKeysWithValues: sortedArray.map {($0.key, $0.value)})
            print(dict)
            print(duplicateImgDict)
            let delete = duplicateImgDict.filter { int1 in
                let keys = int1.value
                return keys.absoluteString.range(of: "private/var") != nil
            }
            if delete.count == 1, let keylist = self.others.keys.first, keylist != indexValueForDelete {
                indexValueForDelete = keylist
            }
            let urlName = duplicateImgDict[indexValueForDelete]
            duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: indexValueForDelete)
            print(duplicateImgDict)
            self.othersApiCallingEnable.removeValue(forKey: "\(sender.tag)")
            var duplicateDocumentArray = self.othersDocumentArray
            for item in 0..<self.othersDocumentArray.count {
                if othersDocumentArray[item].range(of: urlName?.lastPathComponent ?? "") != nil {
                    let docName = othersDocumentArray[item]
                    duplicateDocumentArray.remove(at: item)
                    AWSManager.shared.deleteUploadDocument(documentName: docName)
                }
            }
            self.othersDocumentArray = duplicateDocumentArray
            if sender.tag < 4 {
                for n in sender.tag..<3 {
                    duplicateImgDict.updateValue(self.others["\(n+1)"]!, forKey: "\(n)")
                }
                duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: "3")
            }
            
            let duplicateAPICalling = self.othersApiCallingEnable
            // Sort the dictionary keys in ascending order
            let sortedKeys = duplicateAPICalling.keys.sorted { Int($0)! < Int($1)! }
            // Create a new dictionary with updated sequential index keys
            var updatedDictionary: [String: String] = [:]
            var currentIndex = 0
            for key in sortedKeys {
                updatedDictionary[String(currentIndex)] = duplicateAPICalling[key]
                currentIndex += 1
            }
            self.othersApiCallingEnable = updatedDictionary
            self.others = duplicateImgDict
        default:
            var duplicateImgDict = self.pickedImageDictionary
            var indexValueForDelete = "\(sender.tag)"
            let sortedArray = duplicateImgDict.sorted { int1, int2 in
                return int1.key < int2.key
            }
            print(duplicateImgDict)
            print(sortedArray)
            let dict = Dictionary(uniqueKeysWithValues: sortedArray.map {($0.key, $0.value)})
            print(dict)
            print(duplicateImgDict)
            if self.pickedImageDictionary.count == 1, let keylist = self.pickedImageDictionary.keys.first, keylist != indexValueForDelete {
                indexValueForDelete = keylist
            }
            let urlName = duplicateImgDict[indexValueForDelete]
            duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: indexValueForDelete)
            print(duplicateImgDict)
            self.apiCallingEnableOrDisable.removeValue(forKey: "\(sender.tag)")
            var duplicateDocumentArray = self.uploadedDocumentArray
            for item in 0..<self.uploadedDocumentArray.count {
                if uploadedDocumentArray[item].range(of: urlName?.lastPathComponent ?? "") != nil {
                    let docName = uploadedDocumentArray[item]
                    duplicateDocumentArray.remove(at: item)
                    AWSManager.shared.deleteUploadDocument(documentName: docName)
                }
            }
            self.uploadedDocumentArray = duplicateDocumentArray
            if sender.tag < 4 {
                for n in sender.tag..<3 {
                    duplicateImgDict.updateValue(self.pickedImageDictionary["\(n+1)"]!, forKey: "\(n)")
                }
                duplicateImgDict.updateValue(URL(fileURLWithPath: ""), forKey: "3")
            }
            let duplicateAPICalling = self.apiCallingEnableOrDisable
            // Sort the dictionary keys in ascending order
            let sortedKeys = duplicateAPICalling.keys.sorted { Int($0)! < Int($1)! }
            // Create a new dictionary with updated sequential index keys
            var updatedDictionary: [String: String] = [:]
            var currentIndex = 0
            for key in sortedKeys {
                updatedDictionary[String(currentIndex)] = duplicateAPICalling[key]
                currentIndex += 1
            }
            self.apiCallingEnableOrDisable = updatedDictionary
            self.pickedImageDictionary = duplicateImgDict
        }
        self.tableView.reloadData()
        setTableviewDynamicHeight()
    }
}
