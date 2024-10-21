//
//  AttachmentProgressTableViewCell.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 03/05/23.
//

import UIKit
import AWSS3
import AWSCore
import KFGradientProgressView

class AttachmentProgressTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var progressView: GradientProgressView!
    @IBOutlet weak var uploadReadingLbl: UILabel!
    @IBOutlet weak var documentCloseBtn: UIButton!
    @IBOutlet weak var documentNameLbl: UILabel!
    @IBOutlet weak var imgFileType: UIImageView!
    var uploadedImg: AWSFileUploadingDelegate?
    @IBOutlet weak var stackView: UIStackView!
    //MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupProgressView()
        // Initialization code
       
        
    }
    
    func setupProgressView() {
        progressView.progressColors = [.attachmentGreenColor]
        progressView.layer.cornerRadius = 2
        progressView.layer.masksToBounds = true
        progressView.progressCornerRadius = 2
        progressView.progressEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        progressView.animationDuration = 1
        progressView.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        progressView.setProgress(0.0, animated: false)
        progressView.isHidden = false
        documentNameLbl.text = ""
        uploadReadingLbl.text = ""
        documentCloseBtn.isHidden = true
    }
    
    func apiConfiguration(fileURL: URL, fileType: String, indexValue: Int, categoryName: documentCategory) {
        self.documentNameLbl.text = fileURL.lastPathComponent
        debugPrint("File Type :\(fileType)")
        imgFileType.image = UIImage(named: fileType.uppercased())
        AWSManager.shared.uploadingDocumentsToAWS(fileURL: fileURL, fileType: fileType, indexValue: indexValue) { progressReading in
            print(progressReading)
            let roundUpValue = Float(Double(round(100 * progressReading) / 100))
            let readingCount = "\(roundUpValue)".count-3
            print("roundUpValue : \(roundUpValue)")
            print("Reading Count: \(readingCount)")
            print("Progress Reading: \(progressReading/pow(10, Float(readingCount)))")
            self.uploadReadingLbl.text = "Uploading \(roundUpValue)%"
            self.progressView.setProgress(progressReading/pow(10, Float(readingCount)), animated: true)
        } onSuccess: { DocumentURL, index in
            print(DocumentURL)
            DispatchQueue.main.async {
                self.uploadedImg?.returningFileName(fileName: DocumentURL, indexValue: index, categoryName: categoryName)
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.documentCloseBtn.isHidden = false
                    self.uploadReadingLbl.text = ""
                    self.progressView.isHidden = true
                }
            }
        } onFailure: { errorResponse in
            print(errorResponse)
        }
    }
    
    func roundToPlaces(places:Int, reading: Float) -> Double {
            let divisor = pow(10.0, Double(places))
        return round(Double(reading) * divisor) / divisor
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

