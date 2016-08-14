//
//  CircularButton.swift
//  Color Match
//
//  Created by Bikram Dangol on 8/13/16.
//  Copyright © 2016 AppCoders. All rights reserved.
//

import UIKit

class CircularButton: UIButton {
    //0.559005 0.932134 1.00065 1
    
    //let defaultFillColor = UIColor(colorLiteralRed: 0.559005, green: 0.932134, blue: 1.00065, alpha: 1)
    //  = UIColor(colorLiteralRed: 127/255, green: 234/255, blue: 255/255, alpha: 1)
    @IBInspectable var fillColor: UIColor = UIColor.clear {
        didSet(oldColor) {
            if fillColor != oldColor {
                self.setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet(oldColor) {
            if borderColor != oldColor {
                self.setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable var endColor: UIColor = UIColor.white
    
    override func draw(_ rect: CGRect) {
        let minimumLength = min(bounds.width, bounds.height)
        let borderWidth: CGFloat = minimumLength * 0.1
        
        let radius = (minimumLength - borderWidth)/2
        let path = UIBezierPath(arcCenter: CGPoint(x:bounds.width/2, y:bounds.height/2), radius: (minimumLength - borderWidth)/2, startAngle: 0, endAngle: 360, clockwise: true)
        
        path.lineWidth = borderWidth
        borderColor.setStroke()
        //fillColor.setFill()
        path.stroke()
        //path.fill()
        
        let context = UIGraphicsGetCurrentContext()
        let locations: [CGFloat] = [0.0, 1.0]
        
        let colors = [UIColor.white.cgColor,
                      fillColor.cgColor]
        
        let colorspace = CGColorSpaceCreateDeviceRGB()
        
        let gradient = CGGradient(colorsSpace: colorspace,
                                  colors: colors, locations: locations)
        
        var startPoint = CGPoint()
        var endPoint = CGPoint()
        startPoint.x = radius/1.2
        startPoint.y = radius/1.2
        endPoint.x = minimumLength/2
        endPoint.y = minimumLength/2
        let startRadius: CGFloat = 0
        let endRadius: CGFloat = radius
        
        context!.drawRadialGradient (gradient!, startCenter: startPoint,
                                     startRadius: startRadius, endCenter: endPoint, endRadius: endRadius,
                                     options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        
        
    }
}
