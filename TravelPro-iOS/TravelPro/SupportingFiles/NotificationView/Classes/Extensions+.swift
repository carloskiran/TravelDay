//Copyright (c) 2018 pikachu987 <pikachu77769@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.  
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import UIKit

extension UILabel {
    func height(_ width: CGFloat) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = self.numberOfLines
        label.text = self.text
        label.font = self.font
        label.sizeToFit()
        return label.frame.height
    }
}

extension NSLayoutConstraint {
    enum Identifier: String {
        case top = "top"
        case bottom = "bottom"
        case leading = "leading"
        case trailing = "trailing"
        case centerX = "centerX"
        case centerY = "centerY"
        case left = "left"
        case right = "right"
        case width = "width"
        case height = "height"
    }
    
    @discardableResult
    func priority(_ rawValue: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(rawValue)
        return self
    }
    
    @discardableResult
    func identifier(_ identifier: String) -> NSLayoutConstraint {
        self.identifier = identifier
        return self
    }
    
    @discardableResult
    func identifier(_ identifier: Identifier) -> NSLayoutConstraint {
        self.identifier = identifier.rawValue
        return self
    }
    
    func equalIdentifier(_ identifier: String) -> Bool {
        guard let value = self.identifier else { return false }
        return value == identifier
    }
    
    func equalIdentifier(_ identifier: Identifier) -> Bool {
        guard let value = self.identifier else { return false }
        return value == identifier.rawValue
    }
}

extension UIView {
    @discardableResult
    func removeConstraint(_ identifier: String) -> NSLayoutConstraint? {
        if let constraint = self.constraints.identifier(identifier) {
            self.removeConstraint(constraint)
            return constraint
        } else {
            return nil
        }
    }
    
    @discardableResult
    func removeConstraint(_ identifier: NSLayoutConstraint.Identifier) -> NSLayoutConstraint? {
        if let constraint = self.constraints.identifier(identifier) {
            self.removeConstraint(constraint)
            return constraint
        } else {
           return nil
       }
    }
    
    func constraints(identifierType: NSLayoutConstraint.Identifier) -> [NSLayoutConstraint] {
        return self.constraints(identifier: identifierType.rawValue)
    }
    
    func constraints(identifier: String) -> [NSLayoutConstraint] {
        let constraint = self.constraints.compactMap { (constraint) -> NSLayoutConstraint? in
            guard let constraintIdentifier = constraint.identifier, constraintIdentifier == identifier else { return nil }
            return constraint
        }
        return constraint
    }
    
 
}

extension Array where Element == NSLayoutConstraint {
    func identifier(_ identifier: String) -> NSLayoutConstraint? {
        return self.filter({ $0.equalIdentifier(identifier) }).first
    }
    
    func identifier(_ identifier: NSLayoutConstraint.Identifier) -> NSLayoutConstraint? {
        return self.filter({ $0.equalIdentifier(identifier) }).first
    }
}

extension UIViewController {
    func designUIViewLayout(view: UIView)  {

        view.layer.cornerRadius = view.frame.size.height / 0.5
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Constant.sharedInstance.appOrangeColor.cgColor
        view.layer.masksToBounds = true
    }
    public typealias OnActionHandler = (_ actionValue: String?) -> Void
    func goBack(_ controller: AnyClass? = nil) {
        if let ctrl = controller {
            let viewControllers: [UIViewController] = navigationController!.viewControllers as [UIViewController]
            for aViewController in viewControllers {
                if aViewController.isKind(of: ctrl) {
                    navigationController?.popToViewController(aViewController, animated: true)
                    return
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    func showAlertWithActions(

            title: String? = "", message: String? = "", actionTitle: [String]? = ["Ok"],

            actionStyle: [UIAlertAction.Style]? = [.default], actionCompletionHandler: OnActionHandler? = nil

        ) {

            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

            for (title, style) in zip(actionTitle!, actionStyle!) {

                alert.addAction(

                    UIAlertAction(

                        title: title, style: style,

                        handler: { _ in

                            if actionCompletionHandler != nil {

                                actionCompletionHandler!(title)

                            }

                        }

                    ))

            }

            present(alert, animated: true, completion: nil)

        }
}

extension UILabel {
    /**
     * @desc anime text like if someone write it
     * @param {String} text,
     * @param {TimeInterval} characterDelay,
     */
    func animate(newText: String, interval: TimeInterval = 0.07, lineSpacing: CGFloat = 1.2, letterSpacing: CGFloat = 1.1) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.2
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .center
        var pause: TimeInterval = 0
        self.text = ""
        var charIndex = 0.0
        for letter in newText {
            Timer.scheduledTimer(withTimeInterval: interval * charIndex + pause, repeats: false) { (_) in
                self.text?.append(letter)
                let attributedString = NSMutableAttributedString(string: self.text ?? "")
                attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
                attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSRange(location: 0, length: attributedString.length - 1))
                self.attributedText = attributedString
            }
            charIndex += 1
            if(letter == "," || letter == ".") {
                pause += 0.5
            }
        }
    }
    
    // MARK: - UILABEL EXTEXTENSION
    func config(text: String, textColor: UIColor, font: UIFont) {
        self.text = text
        self.textColor = textColor
        self.font = font
    }
}
