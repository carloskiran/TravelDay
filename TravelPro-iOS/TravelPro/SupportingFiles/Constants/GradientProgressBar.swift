//
//  GradientProgressBar.swift
//  TravelPro
//
//  Created by VIJAY M on 24/04/23.
//

import UIKit

//extension UIImage{
//    convenience init(view: UIView) {
//
//        UIGraphicsBeginImageContext(view.frame.size)
//        view.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        self.init(cgImage: (image?.cgImage)!)
//
//    }
//}

//@IBDesignable
//class GradientView: UIView {
//
//    private var gradientLayer = CAGradientLayer()
//    private var vertical: Bool = false
//
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        // Drawing code
//
//        //fill view with gradient layer
//        gradientLayer.frame = self.bounds
//
//        //style and insert layer if not already inserted
//        if gradientLayer.superlayer == nil {
//
//            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//            gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
//            gradientLayer.colors = [UIColor.progressBarStartGradientColor, UIColor.progressBarStopGradientColor]
//            gradientLayer.locations = [0.0, 1.0]
//
//            self.layer.insertSublayer(gradientLayer, at: 0)
//        }
//    }
//
//}

//class CustomProgressBar: UIView {
//
//    private let gradientLayer = CAGradientLayer()
//    private let progressView = UIView()
//
//    var progress: Float = 0 {
//        didSet {
//            progressView.frame.size.width = bounds.width * CGFloat(progress)
//        }
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        layer.addSublayer(gradientLayer)
//
//        progressView.backgroundColor = .white
//        addSubview(progressView)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        gradientLayer.frame = bounds
//        progressView.frame = CGRect(x: 0, y: 0, width: bounds.width * CGFloat(progress), height: bounds.height)
//    }
//}


//class GradientProgressView: UIProgressView {
//
//    private let gradientLayer = CAGradientLayer()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        // Create a gradient layer and add it as a sublayer
//        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        layer.addSublayer(gradientLayer)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        // Create a gradient layer and add it as a sublayer
//        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        layer.addSublayer(gradientLayer)
//    }
//
//    override func draw(_ rect: CGRect) {
//        // Call super's draw method to draw the progress bar's background
//        super.draw(rect)
//
//        // Set the gradient layer's frame to cover the progress bar's foreground
//        gradientLayer.frame = CGRect(x: 0, y: 0, width: rect.width * CGFloat(progress), height: rect.height)
//
//        // Set the gradient layer as a mask to clip the foreground
//        layer.mask = gradientLayer
//    }
//}

