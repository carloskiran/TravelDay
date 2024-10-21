

import Foundation
import UIKit

//MARK: - UIButton

/// Configuring button with the given properties
/// - Parameters:
///   - backgroundColor: Background color of button given by the user
///   - titleName: Title name for button given by the user
///   - titleColor: Color of the button title given by the user
///   - textFont: Font of the button title
/// - Returns: Returns the button with the required configuration
public func Button(backgroundColor: UIColor, titleName: String, titleColor: UIColor, textFont: UIFont) -> UIButton {
	
	let button = UIButton(type: .custom)
	button.translatesAutoresizingMaskIntoConstraints = false
	button.backgroundColor = backgroundColor
	button.titleLabel?.font = textFont
	button.setTitle(titleName, for: .normal)
	button.setTitleColor(titleColor, for: .normal)
	button.setTitleColor(titleColor.withAlphaComponent(0.2), for: .highlighted)
	return button
	
}

/// Setup Back Button
/// - Returns: UIButton
public func setupBackButton() -> UIButton {
	
	let backButton = UIButton()
	backButton.translatesAutoresizingMaskIntoConstraints = false
	backButton.setImage(UIImage(named: "backIcon"), for: .normal)
	return backButton
	
}

/// ButtonImage
/// - Parameter image: UIImage
/// - Returns: UIButton
public func ButtonImage(image: UIImage?) -> UIButton {
	
	let button = UIButton()
	button.translatesAutoresizingMaskIntoConstraints = false
	button.setImage(image ?? UIImage(), for: .normal)
	return button
	
}

//MARK: - UITextField


extension UITextField {
	     func isValidEmail() -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: self.text)
        }
        func isValidPassword() -> Bool {
            let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
            let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
            return passwordValidation.evaluate(with: self.text)
        }
	/// UserNameTextField
	func userNameTextField() {
		
		self.returnKeyType = .next
		self.autocorrectionType = .no
		self.autocapitalizationType = .none
		self.keyboardType = .alphabet
		self.textContentType = UITextContentType.username
		
	}
	
	/// AddRightPadding
	func addRightPadding() {
		
		let view = UIView()
		view.frame = CGRect(x: 0, y: 0, width: 20, height: 0)
		self.rightView = view
		self.rightViewMode = .always
		
	}
	
	/// AddRightPaddingWithImageName
	/// - Parameter name: String
	func addRightPaddingWithImageName(_ name: String) {
		
		let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
		let imageView = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
		imageView.setImage(UIImage(named: name), for: .normal)
		view.addSubview(imageView)
		self.rightView = view
		self.rightViewMode = .always
		
	}
    
    /// AddPlaceholderText
    /// - Parameters:
    ///   - name: String
    ///   - color: UIColor
    func addPlaceholderText(_ name: String, color: UIColor?) {
        self.attributedPlaceholder = NSAttributedString(
            string: name,
            attributes: [NSAttributedString.Key.foregroundColor: color ?? UIColor.lightGray])
    }
}

//MARK: - UIView

//MARK: - UIImageView

extension UIImageView {
	
	/// MakeBlurImageView
	public func makeBlurImageView() {
		let blurEffect = UIBlurEffect(style: .light)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = self.bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
		self.addSubview(blurEffectView)
	}
	
}


//MARK: - UILabel

/// Configuring label with the given properties
/// - Parameters:
///   - textFont: Setting font of the lable
///   - textColor: Setting text color of the lable
/// - Returns: returns a label configured with the given properties
public func Label(textColor: UIColor,
									textFont: UIFont) -> UILabel {
	
	let label = UILabel()
	label.translatesAutoresizingMaskIntoConstraints = false
	label.textColor = textColor
	label.font = textFont
	return label
	
}

/// Configuring label with the given properties
/// - Parameters:
///   - backgroundColor: Setting back ground  color of the lable
/// - Returns: returns a label configured with the given properties
public func SepratorLabel(backgroundColor: UIColor) -> UILabel {
	
	let label = UILabel()
	label.translatesAutoresizingMaskIntoConstraints = false
	label.backgroundColor = backgroundColor
	return label
	
}

/// AddBlurView
/// - Returns: UIView
public func addLoaderBlurView() -> UIVisualEffectView {
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.layer.cornerRadius = 10.0
    blurEffectView.clipsToBounds = true
    blurEffectView.frame = CGRect(x: 0, y: 0, width: 65, height: 65)
    return blurEffectView
}


//MARK: - UITableView

extension UITableViewHeaderFooterView {
	
	/// Returns an identifier for reuse the ui element tableview header and footer view
	public static var reuseIdentifier: String {
		let className = String(describing: self)
		return className
	}
}

extension UITableViewCell {
	
	/// Returns an identifier for reuse the ui element tableview cell
	public static var TableReuseIdentifier: String! {
		let className = String(describing: self)
		return className
	}
}

extension UICollectionViewCell {
    
    /// Returns an identifier for reuse the ui element tableview cell
    public static var CollectionReuseIdentifier: String! {
        let className = String(describing: self)
        return className
    }
}

extension UITableView {
	
	/// Setting tableview with basic configuration
	func setupBasicTableView() {
		
		self.isScrollEnabled = true
		self.showsVerticalScrollIndicator = false
		self.showsHorizontalScrollIndicator = false
		self.alwaysBounceVertical = true
		self.separatorStyle = .none
		
	}
}

/// Configuring tableview with plain or individual cell views
/// - Parameters:
///   - delegate: Delegate of the tableview
///   - datasource: Datasource of the tableview
/// - Returns: Returns a plain tableview with given configuration
public func PlainTableView(_ delegate: UITableViewDelegate,
													 _ datasource: UITableViewDataSource) -> UITableView {
	
	let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
	tableView.translatesAutoresizingMaskIntoConstraints = false
	tableView.setupBasicTableView()
	tableView.dataSource = datasource
	tableView.delegate = delegate
	return tableView
	
}

/// Configuring tableview with group of cells
/// - Parameters:
///   - delegate: Delegate of the tableview
///   - datasource: Datasource of the tableview
/// - Returns: Returns a tableview with grouped configuration
public func GroupTableView(_ delegate: UITableViewDelegate,
													 _ datasource: UITableViewDataSource) -> UITableView {
	
	let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
	tableView.translatesAutoresizingMaskIntoConstraints = false
	tableView.setupBasicTableView()
	tableView.dataSource = datasource
	tableView.delegate = delegate
	return tableView
	
}

//MARK: - UIViewController

public enum transitionMode {
	case none
	case pop
	case popToRoot
	case dismiss
	case assignHome
	case exit
}

extension UIViewController {
	
	/// RemoveChildViewcontroller
	func removeChildViewcontroller() {
		if self.children.count > 0{
			let viewControllers:[UIViewController] = self.children
			viewControllers.last?.willMove(toParent: nil)
			viewControllers.last?.removeFromParent()
			viewControllers.last?.view.removeFromSuperview()
		}
	}
    
    /// LoadFromNib
    /// - Returns: UIViewController
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
	
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
   
    func addShadow(offset: CGSize = CGSize(width: 1, height: 1),
                   shadowColor: UIColor = UIColor(named: "grayText") ?? .clear,
                   shadowRadius: CGFloat = 5.0,
                   shadowOpacity: Float = 0.7,
                   cornerRadius:CGFloat = 5.0,
                   borderColor: UIColor = UIColor(named: "borderLightAndDarkGray") ?? .clear,
                   borderWidth:CGFloat = 1) {
        let userdefault = UserDefaults.standard
        let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
        switch isDarkMode {
        case true:
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = false
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowColor = UIColor.clear.cgColor
            layer.shadowRadius = 0.0
            layer.shadowOpacity = 0.0
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
        default:
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = false
            layer.shadowOffset = offset
            layer.shadowColor = shadowColor.cgColor
            layer.shadowRadius = shadowRadius
            layer.shadowOpacity = shadowOpacity
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = 0
        }
    }
}

extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

extension UINavigationController {
	/// PopToViewController
	/// - Parameters:
	///   - ofClass: AnyClass
	///   - animated: Bool
	func popToViewController(ofClass: AnyClass, animated: Bool = true) {
		if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
			popToViewController(vc, animated: animated)
		}
	}
}

//MARK: - UIAlertController


extension UIWindow {
	static var isLandscape: Bool {
		if #available(iOS 13.0, *) {
			return UIApplication.shared.windows
				.first?
				.windowScene?
				.interfaceOrientation
				.isLandscape ?? false
		} else {
			return UIApplication.shared.statusBarOrientation.isLandscape
		}
	}
}


extension UIApplication {
	
	/// TopViewController
	/// - Parameter controller: UIViewController
	/// - Returns: UIViewController
	class func topViewController(controller: UIViewController? = UIWindow.key?.rootViewController) -> UIViewController? {
		if let navigationController = controller as? UINavigationController {
			return topViewController(controller: navigationController.visibleViewController)
		}
		if let presented = controller?.presentedViewController {
			return topViewController(controller: presented)
		}
		return controller
	}
}

extension UIWindow {
	/// Key for UIWindow
	static var key: UIWindow? {
		if #available(iOS 13, *) {
			return UIApplication.shared.windows.first { $0.isKeyWindow }
		} else {
			return UIApplication.shared.keyWindow
		}
	}
}



//public func updateAVSession() {
//	
//	do {
//		try? AVAudioSession.sharedInstance().setCategory(
//			AVAudioSession.Category.playAndRecord,
//			mode: AVAudioSession.Mode.default
//		)
//		try AVAudioSession.sharedInstance().setActive(false)
//	}
//	catch let error as NSError {
//		debugPrint("Error: Could not setActive to false: \(error), \(error.userInfo)")
//	}
//	
//}


extension UITableView {
	
	public func reloadDataAndKeepOffset() {
		
		setContentOffset(contentOffset, animated: false)
		let beforeContentSize = contentSize
		reloadData()
		layoutIfNeeded()
		let afterContentSize = contentSize
		let newOffset = CGPoint(
			x: contentOffset.x + (afterContentSize.width - beforeContentSize.width),
			y: contentOffset.y + (afterContentSize.height - beforeContentSize.height))
		setContentOffset(newOffset, animated: false)
		
	}
	
	func reloadWithoutAnimation() {
		let lastScrollOffset = contentOffset
		layer.removeAllAnimations()
		setContentOffset(lastScrollOffset, animated: false)
	}
	
	func reloadSectionWithoutAnimation(section: Int) {
		UIView.performWithoutAnimation {
			let offset = self.contentOffset
			self.reloadSections(IndexSet(integer: section), with: .none)
			self.contentOffset = offset
		}
	}
	
}

//MARK: - UIPROGRESS BAR WITH THE ANIMATION OF THE READING

extension UIProgressView {
	func setAnimatedProgress(progress: Float = 1, duration: Float = 1, completion: (() -> ())? = nil) {
		Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
			DispatchQueue.main.async {
				let current = self.progress
				self.setProgress(current + 0.016, animated: true)
			}
			if self.progress >= progress {
				timer.invalidate()
				if completion != nil {
					completion!()
				}
			}
		}
	}
}


//MARK: - UINAVIGATION CONTROLLER FOR REMOVING THE VIEWCONTROLLER
extension UINavigationController {
	
	func removeViewController(_ controller: UIViewController.Type) {
		if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
			viewController.removeFromParent()
		}
	}
}


extension UICollectionReusableView {
	
	/// This method will return a reuse identifier for the UI Element  collection view
	static var reuseIdentifier: String {
		
		let className = String(describing: self)
		
		return className
	}
}

extension Dictionary where Value: Equatable {
	func key(from value: Value) -> Key? {
		return self.first(where: { $0.value == value })?.key
	}
}

// MARK: - UIVIEW

public func setupBaseView(_ color: UIColor) -> UIView {
	let view = UIView()
	view.translatesAutoresizingMaskIntoConstraints = false
	view.backgroundColor = color
	return view
} 



extension UICollectionView {
	
	var visibleCurrentCellIndexPath: IndexPath? {
		for cell in self.visibleCells {
			let indexPath = self.indexPath(for: cell)
			return indexPath
		}
		
		return nil
	}
	
}

extension UIApplication {
		var foregroundActiveScene: UIWindowScene? {
				connectedScenes
						.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
		}
}


protocol Storyboarded {
	
	static var storyboardName: String { get }
	static var storyboardID: String { get }
	static var storyboardBundle: Bundle { get }
	static var instantiationRequiresTransitioner: Bool { get }
	static func instantiate(dataTransitioner: ((Self) -> Void)?) -> Self
	
}

extension Storyboarded {
	
	static var storyboardName: String { "Main" }
	static var storyboardBundle: Bundle { Bundle.main }
	static var storyboardID: String { String(describing: self) }
	static var instantiationRequiresTransitioner: Bool { false }
	
}

extension Storyboarded where Self: UIViewController {

	static func instantiate(dataTransitioner: ((Self) -> Void)? = nil) -> Self {
		guard instantiationRequiresTransitioner == false || dataTransitioner != nil else {
			fatalError("DataTransitioner is required for instantiation")
		}

		let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)

		guard let viewController =
			storyboard.instantiateViewController(
				withIdentifier: storyboardID) as? Self else {
			fatalError("Did not recieve expected typ from storyboard instantian")
		}

		dataTransitioner?(viewController)

		return viewController
	}
	
}


public enum PlayListItemType {
	case hostLive
	case fanbetheHostLive
	case video
}

public struct PlayListItems {
	var playListType: PlayListItemType
	var title: String?
	var duration: String?
	var thumbnail: String?
	var artistName:String?
}

public struct FanUserData {
	var userName: String?
	var userImage: String?
}

 //MARK: - UIScrollView
extension UIScrollView {
    /// To get the current page of scrollView
var currentPage:Int{
    return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)+1
}
}


/// SetBoldText
/// - Parameters:
///   - string: String
///   - boldString: String
///   - font: UIFont
/// - Returns: NSMutableAttributedString
public func setBoldText(withString string: String, boldString: String, font: UIFont) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString(string: string,
                                                 attributes: [NSAttributedString.Key.font: font])
    let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.robotoBold(ofSize: font.pointSize)]
    let range = (string as NSString).range(of: boldString)
    attributedString.addAttributes(boldFontAttribute, range: range)
    return attributedString
}
