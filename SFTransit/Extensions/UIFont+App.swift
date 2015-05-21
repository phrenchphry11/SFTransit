//
//  UIFont+App.swift
//  SFTransit
//
//  Created by Amie Kweon on 5/20/15.
//  Copyright (c) 2015 Holly French. All rights reserved.
//

import UIKit

extension UIFont {

    enum LatoStyle : String{
        case Regular =  "Lato-Regular"
        case Bold = "Lato-Bold"
        case Medium = "Lato-Medium"
    }

    class func getLato(style: LatoStyle, fontSize : CGFloat = 14.0) -> UIFont{
        return UIFont(name: style.rawValue, size: fontSize)!
    }
}
