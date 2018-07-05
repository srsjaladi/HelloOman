//
//  UIFont+KNFonts.swift
//  Kollectin
//
//  Created by Pablo on 1/5/16.
//  Copyright © 2016 Pablo. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    public class func dinProRegular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size)!
    }
    
    public class func dinProLight(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Light", size: size)!
    }
    
    public class func dinProBlack(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Black", size: size)!
    }
    
    public class func dinProBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: size)!
    }
    
    public class func dinProMedium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size)!
    }
}
