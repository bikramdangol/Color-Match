//
//  CircularButton.swift
//  Color Match
//
//  Created by Bikram Dangol on 8/13/16.
//  Copyright © 2016 AppCoders. All rights reserved.
//

import UIKit

class CircularButton: UIButton {

    @IBInspectable var fillColor: UIColor = UIColor.green {
        didSet(oldColor) {
            if fillColor != oldColor {
                self.setNeedsDisplay()
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
        
    }
}
