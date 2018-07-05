//
//  UIViewController+KollectinHelper.swift
//  Kollectin
//
//  Created by Pablo on 1/6/16.
//  Copyright © 2016 Pablo. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlert(_ error: HelloOmanError) {
        let alertController = UIAlertController(title: error.title, message: error.detail, preferredStyle: .alert)
        
        let accept = UIAlertAction(title: "Accept", style: .default, handler: nil)
        
        alertController.addAction(accept)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func showErrorAlert(_ title: String?, message: String?) {
        let alertController = UIAlertController(title: title!, message: message!, preferredStyle: .alert)
        
        let accept = UIAlertAction(title: "Accept", style: .default, handler: nil)
        
        alertController.addAction(accept)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func showAlert(_ title: String?, message: String?, button1Text : String, button2Text : String? = nil, button1Handler : ((UIAlertAction) -> Void)? = nil, button2Handler : ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title ?? "", message: message ?? "", preferredStyle: .alert)
        
        let button1 = UIAlertAction(title: button1Text, style: .default, handler: button1Handler)
        
        alertController.addAction(button1)
        
        if button2Text?.isEmpty == false {
        
            let button2 = UIAlertAction(title: button2Text ?? "OK", style: .default, handler: button2Handler)
            
            alertController.addAction(button2)
        }
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    class func topViewController() -> UIViewController {
        var rootVC = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!
        if rootVC.isKind(of: UITabBarController.self) {
            rootVC = (rootVC as! UITabBarController).selectedViewController!
        } else if rootVC.isKind(of: UINavigationController.self) {
            rootVC = (rootVC as! UINavigationController).topViewController!
        }
        while rootVC.presentedViewController != nil {
            rootVC = rootVC.presentedViewController!
            if rootVC.isKind(of: UINavigationController.self) {
                rootVC = (rootVC as! UINavigationController).topViewController!
            }
        }
        return rootVC
    }
    

}
