//
//  UIView+Extensions.swift
//  Kollectin
//
//  Created by Umair Ali on 5/11/17.
//  Copyright © 2017 Pablo. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable var cornerRadius : CGFloat {get {
    
            return layer.cornerRadius
        }
        
        set {
        
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor.init(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UITextField {
    
    /// set icon of 20x20 with left padding of 8px
    func setLeftIcon(_ icon: UIImage, textField: UITextField) {
        
        let leftImageView = UIImageView()
        leftImageView.contentMode = .scaleAspectFit
        let leftView = UIView()
        leftView.frame = CGRect(x: 20, y: 0, width: 25, height: 20)
        leftImageView.frame = CGRect(x: 0, y: 0, width: 15, height: 20)
        leftImageView.image = icon
        leftView.addSubview(leftImageView)
        textField.leftViewMode = UITextFieldViewMode.always
        textField.leftViewMode = .always
        textField.leftView = leftView
    }
}

extension String {
    func isEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$",
                                             options: [.caseInsensitive])
        return regex.firstMatch(in: self, options:[],
                                range: NSMakeRange(0, utf16.count)) != nil
    }
    
}

