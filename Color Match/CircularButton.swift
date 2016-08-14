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
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet(oldColor) {
            if borderColor != oldColor {
                self.setNeedsDisplay()
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        let minimumLength = min(bounds.width, bounds.height)
        let borderWidth: CGFloat = minimumLength * 0.1
        let path = UIBezierPath(arcCenter: CGPoint(x:bounds.width/2, y:bounds.height/2), radius: (minimumLength - borderWidth)/2, startAngle: 0, endAngle: 360, clockwise: true)
        
        path.lineWidth = borderWidth
        borderColor.setStroke()
        fillColor.setFill()
        path.stroke()
        path.fill()
        
    }
}
