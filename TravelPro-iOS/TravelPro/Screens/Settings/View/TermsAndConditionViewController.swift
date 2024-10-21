//
//  TermsAndConditionViewController.swift
//  TravelPro
//
//  Created by MAC-OBS-25 on 12/07/23.
//

import UIKit
import WebKit

class TermsAndConditionViewController: UIViewController {

    // MARK: - Properties
    
    var secondOpen = Bool()
    var settingsViewModel = SettingsViewModel()

    // MARK: - IBOutlets
    @IBOutlet weak var webView: WKWebView!

    // MARK: - View life cycle
   
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        ViewTermsAndConditionAPICall()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.isOpaque = false
        webView.scrollView.backgroundColor = .clear
//        let userdefault = UserDefaults.standard
//        let isDarkMode : Bool = userdefault.value(forKey: "isDark") as? Bool ?? false
//        if isDarkMode {
//            webView.tintColor = UIColor.white
//        }
    }
    // MARK: - Network Request
    
    func ViewTermsAndConditionAPICall() {
        
        self.settingsViewModel.ViewTermsAndCondition(controller: self, enableLoader: true) { response in
             
            switch response.status?.status {
            case 200:
                guard (response.entity != nil) else {
                    TravelTaxMixPanelAnalytics(action: .termsAndCondition, state: .info, data: MixPanelData(message: "ViewTermsAndConditionAPICall - response.entity = nil"))
                    return
                }
                if let content = response.entity?.content, !content.isEmpty {
                    let bundleURL = Bundle.main.bundleURL
                    self.webView.loadHTMLString(content, baseURL: bundleURL)
                } else {
                    TravelTaxMixPanelAnalytics(action: .termsAndCondition, state: .info, data: MixPanelData(message: "ViewTermsAndConditionAPICall - response.entity?.content Empty or nil"))
                }
                
            default:
                TravelTaxMixPanelAnalytics(action: .termsAndCondition, state: .info, data: MixPanelData(message: "ViewTermsAndConditionAPICall not 200: message - \(response.status?.message ?? "")"))
                utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: response.status?.message ?? "", image: UIImage(named: "Notification") ?? nil,theme: .custom)
            }
           
        } onFailure: { error in
            utilsClass.sharedInstance.NotificatonAlertMessage(title: "TravelTaxDay", subTitle: TextConstant.sharedInstance.SEmpty, body: error, image: UIImage(named: "Notification") ?? nil,theme: .custom)
        }
        
    }

    // MARK: - User interactions
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Extension
extension TermsAndConditionViewController: WKNavigationDelegate, WKUIDelegate {
   
    // MARK: - WKNavigationDelegate and WKUIDelegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        switch navigationAction.navigationType {
        case .linkActivated:
            self.webView.load(navigationAction.request)
        default:
            break
        }
        if !secondOpen {
            secondOpen = true
            // Allow navigation for requests loading external web content resources.
            guard navigationAction.targetFrame?.isMainFrame != false else {
                decisionHandler(.allow)
                return
            }
            decisionHandler(.allow)
        } else {
            if let URLs = navigationAction.request.mainDocumentURL {
                // Allow navigation for requests loading external web content resources.
                guard navigationAction.targetFrame?.isMainFrame != false else {
                    decisionHandler(.allow)
                    return
                }
                UIApplication.shared.open(URLs)
            }
            decisionHandler(.cancel)
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let cssString = "@media (prefers-color-scheme: dark) {body {color: white;}a:link {color: #0096e2;}a:visited {color: #9d57df;}}"
        let jsString = "var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(jsString, completionHandler: nil)

    }
}
