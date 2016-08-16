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
        let borderWidth: CGFloat = minimumLength * 0.05
        
        let centerX = minimumLength/2
        let centerY = minimumLength/2
        
        let radius = minimumLength/2 - borderWidth
        let path = UIBezierPath(arcCenter: CGPoint(x:bounds.width/2, y:bounds.height/2), radius: radius, startAngle: 0, endAngle: 360, clockwise: true)
        
        path.lineWidth = borderWidth
        borderColor.setStroke()
        //fillColor.setFill()
        //path.stroke()
        //path.fill()
        
        let context = UIGraphicsGetCurrentContext()
        let locations: [CGFloat] = [0.0, 1.0]
        
        var colors = [CGColor]()
        if fillColor == UIColor.clear{
            colors = [UIColor.white.cgColor, UIColor.brown.cgColor]
        } else {
            colors = [UIColor.white.cgColor, fillColor.cgColor]
            if borderColor == UIColor.black {
                path.stroke()
            }
        }
        
        let colorspace = CGColorSpaceCreateDeviceRGB()
        
        let gradient = CGGradient(colorsSpace: colorspace,
                                  colors: colors, locations: locations)
        
        var startPoint = CGPoint()
        var endPoint = CGPoint()
        
        if fillColor == UIColor.clear{
            startPoint.x = centerX * 0.9
            startPoint.y = centerY * 1.3
            endPoint.x = centerX
            endPoint.y = centerY
            let startRadius: CGFloat = 0
            let endRadius: CGFloat = radius/2

            context!.drawRadialGradient (gradient!, startCenter: startPoint,
                                         startRadius: startRadius, endCenter: endPoint, endRadius: endRadius,
                                         options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        }else {
            startPoint.x = centerX/1.2
            startPoint.y = centerY/1.2
            endPoint.x = centerX
            endPoint.y = centerY
            let startRadius: CGFloat = 0
            let endRadius: CGFloat = radius * 0.75 //- borderWidth/2
        
            context!.drawRadialGradient (gradient!, startCenter: startPoint,
                                     startRadius: startRadius, endCenter: endPoint, endRadius: endRadius,
                                     options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        }
        
    }
}
