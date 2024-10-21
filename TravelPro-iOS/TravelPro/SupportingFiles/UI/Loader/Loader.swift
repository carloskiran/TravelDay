

import Foundation
import UIKit

class Loader: NSObject {

    /// This property used to store UIActivityIndicatorView to check the instance exist or not in dictionary
	static var loadIconDictionary: [UIView: UIActivityIndicatorView] = [:]
    static var loadBlurViewDictionary: [UIView: UIVisualEffectView] = [:]

	/// StartLoading
	/// - Parameters:
	///   - view: UIView
	///   - enable: Bool
    static func startLoading(_ view: UIView, userIneration:Bool) {
        view.isUserInteractionEnabled = userIneration
        if let activityIndicatorView = Loader.loadIconDictionary[view] {
            view.bringSubviewToFront(activityIndicatorView)
            return
        } else {
            let activityView = UIActivityIndicatorView(style: .large)
            activityView.center = view.center
            activityView.color = UIColor.white
            let blurView = addLoaderBlurView()
            blurView.center = view.center
            view.addSubview(blurView)
            view.addSubview(activityView)
            view.bringSubviewToFront(activityView)
            activityView.startAnimating()
            Loader.loadIconDictionary[view] = activityView
            Loader.loadBlurViewDictionary[view] = blurView
        }
    }

	/// StopLoading
	/// - Parameter view: UIView
	static func stopLoading(_ view: UIView) {
        view.isUserInteractionEnabled = true
        if let activityIndicatorView = Loader.loadIconDictionary[view] {
            activityIndicatorView.removeFromSuperview()
            activityIndicatorView.stopAnimating()
            Loader.loadIconDictionary[view] = nil
        }
        if let activityBlureView = Loader.loadBlurViewDictionary[view] {
            activityBlureView.removeFromSuperview()
            Loader.loadBlurViewDictionary[view] = nil
        }
	}
}
