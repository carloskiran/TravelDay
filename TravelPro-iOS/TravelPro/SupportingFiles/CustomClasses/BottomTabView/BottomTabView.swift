
import UIKit

class BottomTabView: UIView {

    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var feedBtn: UIButton!
    @IBOutlet weak var albumBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func commonInit() {
        
    }
    @IBAction func didClickHome(_ sender: UIButton) {
        print("Home called")
       
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.moveToTabbarViaIndex(intIndex: 0)
            bounceAnimation(view: homeBtn)
        
    }
    
    @IBAction func didClickFeed(_ sender: UIButton) {
        print("Feed called")
        
            bounceAnimation(view: feedBtn)
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.moveToTabbarViaIndex(intIndex: 1)
         
    }
    
    func bounceAnimation(view: UIButton) {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = 0.3 * 2
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        view.layer.add(impliesAnimation, forKey: nil)
    }
    @IBAction func didClickAlbumBtn(_ sender: UIButton) {
        print("Album called")
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.moveToTabbarViaIndex(intIndex: 3)
            bounceAnimation(view: albumBtn)
        
    }
    
    @IBAction func didClickSettingsBtn(_ sender: UIButton) {
        print("Settings called")
        
            bounceAnimation(view: settingsBtn)
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.moveToTabbarViaIndex(intIndex: 4)
        
    }
    @IBAction func didClickPlusBtn(_ sender: UIButton) {
        
        
            print("Plus option called")
           // globaldetails.isAnimationStopped = true
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.moveToTabbarViaIndex(intIndex: 2)
       
    }
}
