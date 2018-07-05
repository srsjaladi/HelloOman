//
//  UIColor+KNColors.swift
//  Kollectin
//
//  Created by Pablo on 1/5/16.
//  Copyright © 2016 Pablo. All rights reserved.
//

import Foundation
import UIKit

private struct Strings {
	static let NEUTRAL = "NEUTRAL"
	static let COOL = "COOL"
	static let WARM = "WARM"
	static let KOLLECTIN = "KOLLECTIN"
}

public struct Palette {
    var id: Int
	var name: String
	var startColor: UIColor
	var endColor: UIColor
}

extension UIColor {
	
    func colorWithHexString (_ hex:String) -> UIColor {
        
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
//        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
	
	func getPaletteByNumber(_ id: Int) -> Palette {
		switch id {
		case 1:
            return Palette(id: 1, name: Strings.NEUTRAL, startColor: UIColor.neutralStartColor(), endColor: UIColor.neutralEndColor())
		case 2:
			return Palette(id: 2, name: Strings.WARM, startColor: UIColor.coolStartColor(), endColor: UIColor.coolEndColor())
		case 3:
			return Palette(id: 3, name: Strings.COOL, startColor: UIColor.warmStartColor(), endColor: UIColor.warmEndColor())
		default:
			return Palette(id: 5, name: Strings.KOLLECTIN, startColor: UIColor.kollectinNewStartColor(), endColor: UIColor.kollectinNewEndColor())
		}
	}
	
	
	//Static colors
    public class func sandyBrownColor() -> UIColor {
        return UIColor(red: 239.0/255.0, green: 108.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
    
    public class func filterRedColor() -> UIColor {
        return UIColor(red: 233.0/255.0, green: 138.0/255.0, blue: 133.0/255.0, alpha: 1.0)
    }
    
    public class func pinkishGreyColor() -> UIColor {
        return UIColor(red: 197/255.0, green: 197/255.0, blue: 197/255.0, alpha: 1.0)
    }
	
	public class func oldPinkColor() -> UIColor {
		return UIColor(red: 239.0/255.0, green: 230.0/255.0, blue: 191.0/255.0, alpha: 1.0)
	}
    
    public class func warmGrey() -> UIColor {
        return UIColor(red: 40/255.0, green: 45/255.0, blue: 51/255.0, alpha: 1.0)
    }
    
    public class func coolGrey() -> UIColor {
        return UIColor(red: 152/255.0, green: 150/255.0, blue: 164/255.0, alpha: 1.0)
    }
    
    public class func brownishGrey() -> UIColor {
        return UIColor(red: 99/255.0, green: 99/255.0, blue: 99/255.0, alpha: 1.0)
    }
    
    public class func whiteGrey() -> UIColor {
        return UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
    }
    
    public class func darkPeach() -> UIColor {
        return UIColor(red: 230/255.0, green: 115/255.0, blue: 115/255.0, alpha: 1.0)
    }
    
    public class func diamond() -> UIColor {
        return UIColor(red: 89/255.0, green: 104/255.0, blue: 179/255.0, alpha: 1.0)
    }
    
    public class func greenyBlue() -> UIColor {
        return UIColor(red: 89/255.0, green: 179/255.0, blue: 148/255.0, alpha: 1.0)
    }
    
    public class func whiteThree() -> UIColor {
        return UIColor(red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 1.0)
    }
	
	public class func fontGrey() -> UIColor {
		return UIColor(red: 108/255.0, green: 110/255.0, blue: 112/255.0, alpha: 1.0)
	}
	
	//NORMAL
	public class func neutralStartColor() -> UIColor {
		return UIColor(red: 0x65/0xFF, green: 0x65/0xFF, blue: 0x65/0xFF, alpha: 1.0)
	}
	
	public class func neutralEndColor() -> UIColor {
		return UIColor(red: 0xFF/0xFF, green: 0xC1/0xFF, blue: 0xAF/0xFF, alpha: 1.0)
	}
	
	//COOL
	public class func coolStartColor() -> UIColor {
		return UIColor(red: 0x52/0xFF, green: 0x3A/0xFF, blue: 0x61/0xFF, alpha: 1.0)
	}
	
	public class func coolEndColor() -> UIColor {
		return UIColor(red: 0x88/0xFF, green: 0xAE/0xFF, blue: 0xD5/0xFF, alpha: 1.0)
	}
	
	//WARM
	public class func warmStartColor() -> UIColor {
		return UIColor(red: 0x79/0xFF, green: 0xCC/0xFF, blue: 0xCC/0xFF, alpha: 1.0)
	}
	
	public class func warmEndColor() -> UIColor {
		return UIColor(red: 0xFB/0xFF, green: 0x94/0xFF, blue: 0x79/0xFF, alpha: 1.0)
	}
	
	//KOLLECTIN
	public class func kollectinStartColor() -> UIColor {
		return UIColor(red: 0xD9/0xFF, green: 0xA9/0xFF, blue: 0x9B/0xFF, alpha: 1.0)
	}
	
	public class func kollectinEndColor() -> UIColor {
		return UIColor(red: 0x98/0xFF, green: 0x96/0xFF, blue: 0xA4/0xFF, alpha: 1.0)
	}
	
	//NewColor
    
    public class func kollectinNewStartColor() -> UIColor {
        return UIColor(red: 250.0/255.0, green: 131.0/255.0, blue: 147.0/255.0, alpha: 1.0)
    }
    
    public class func kollectinNewEndColor() -> UIColor {
        return UIColor(red: 254.0/255.0, green: 182.0/255.0, blue: 139.0/255.0, alpha: 1.0)
    }
	

}
