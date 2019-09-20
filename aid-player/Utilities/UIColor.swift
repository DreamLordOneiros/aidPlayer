//
//  UIColor.swift
//  aid-player
//
//  Created by Javier Hernández on 8/23/19.
//  Copyright © 2019 Javier Hernández. All rights reserved.
//

import UIKit

extension UIColor {
    static var themeColor: UIColor {
        return UIColor(red: 134.0/255.0, green: 43.0/255.0, blue: 137.0/255.0, alpha: 0.1)
    }
    
    static var softThemeColor: UIColor {
        return themeColor.withAlphaComponent(0.5)
    }
    
    static var softerThemeColor: UIColor {
        return themeColor.withAlphaComponent(0.3)
    }
    
    static var themeBlueColor: UIColor {
        return UIColor(red: 41.0/255.0, green: 94.0/255.0, blue: 107.0/255.0, alpha: 1.0)
    }
    
    static var softThemeBlueColor: UIColor {
        return themeBlueColor.withAlphaComponent(0.5)
    }
}
