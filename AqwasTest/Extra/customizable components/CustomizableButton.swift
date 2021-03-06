//
//  CustomizableButton.swift
//  Alloha
//
//  Created by يعرب المصطفى on 11/2/16.
//  Copyright © 2016 yarob. All rights reserved.
//

import UIKit

@IBDesignable class CustomizableButton: UIButton {
    
    var shadowRadiusSteps:Float = 20.0
    @IBInspectable var radius : CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = radius;
        }
    }
    
    @IBInspectable var yShadow:CGFloat = 0
        {
        didSet{
            layer.shadowOffset = CGSize(width: 0, height: yShadow)
        }
    }
    
    @IBInspectable var shadowOpacity:Float = 0
        {
        didSet{
            layer.shadowOpacity = shadowOpacity/shadowRadiusSteps
        }
    }
    
    
    @IBInspectable var shadowRadius:CGFloat = 0
        {
        didSet{
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var cornerRad:CGFloat = 0
        {
        didSet{
            self.layer.cornerRadius = cornerRad
        }
    }

}
