//
//  Constants.swift
//  Dhukan
//
//  Created by Suganya on 7/18/18.
//  Copyright © 2018 Suganya. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    
    static let BASEURL                 =  "http://dev.dxminds.online/JeweleryNew/index.php?route="
    
    static let IMAGE_BASEURL           = "http://3.213.33.73/JeweleryNew/image/catalog"
    
    static let DEVICE_ID               = UIDevice.current.identifierForVendor!.uuidString
    
    static let FONTNAME: NSString      = "Roboto"
    
    static let FONTNAME_BOLD: NSString = "Roboto-Bold"
    
    static let SCREEN_WIDTH            = UIScreen.main.bounds.size.width
    
    static let SCREEN_HEIGHT           = UIScreen.main.bounds.size.height
    
    static let appDelegate             = UIApplication.shared.delegate as? AppDelegate
    
    static let BasepinkColor          = UIColor(red:0.98, green:0.17, blue:0.61, alpha:1.0)
    
    static let kMainViewController     = UIApplication.shared.delegate?.window??.rootViewController as? MainViewController
    
    static let kNavigationController   = (UIApplication.shared.delegate?.window??.rootViewController as? MainViewController)?.rootViewController as? NavigationController
    
    static let  INTERNET_ERROR         = "No Internet Connection"
    
}
