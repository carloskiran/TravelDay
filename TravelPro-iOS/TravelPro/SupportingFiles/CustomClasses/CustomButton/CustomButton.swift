
import UIKit
import Foundation

@IBDesignable
class CustomButton: UIButton {
     @IBInspectable var borderWidth: CGFloat {
           set {
               layer.borderWidth = newValue
           }
           get {
               return layer.borderWidth
           }
       }

       @IBInspectable var cornerRadius: CGFloat {
           set {
               layer.cornerRadius = newValue
           }
           get {
               return layer.cornerRadius
           }
       }

       @IBInspectable var borderColor: UIColor? {
           set {
               guard let uiColor = newValue else { return }
               layer.borderColor = uiColor.cgColor
           }
           get {
               guard let color = layer.borderColor else { return nil }
               return UIColor(cgColor: color)
           }
       }
    @IBInspectable public var referenceText: String = "" {
              didSet {
                  self.setTitle(NSLocalizedString(referenceText, comment: ""), for: .normal)
              }
          }
    
    public override class var layerClass: AnyClass
    { CAGradientLayer.self }
       private var gradientLayer: CAGradientLayer
    {
        if let layer = layer as? CAGradientLayer {
            return layer
        } else {
            return CAGradientLayer()
        }
    }

       @IBInspectable public var startColor: UIColor = .white {
           didSet { updateColors() } }
       @IBInspectable public var endColor: UIColor = .red     { didSet { updateColors() } }

       // expose startPoint and endPoint to IB

       @IBInspectable public var startPoint: CGPoint {
           get { gradientLayer.startPoint }
           set { gradientLayer.startPoint = newValue }
       }

       @IBInspectable public var endPoint: CGPoint {
           get { gradientLayer.endPoint }
           set { gradientLayer.endPoint = newValue }
       }

       public override init(frame: CGRect = .zero) {
           super.init(frame: frame)
           updateColors()
       }

       required init?(coder: NSCoder) {
           super.init(coder: coder)
           updateColors()
       }
}
private extension CustomButton {
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}
class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "check")! as UIImage
    let uncheckedImage = UIImage(named: "uncheck")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
        
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
        
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
