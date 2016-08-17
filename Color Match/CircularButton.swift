//
//  CircularButton.swift
//  Color Match
//
//  Created by Bikram Dangol on 8/13/16.
//  Copyright © 2016 AppCoders. All rights reserved.
//

import UIKit

public enum CircularButtonType {
    case Hollow
    case ColorSelection
    case ColorPlaced
    case Hint
}

class CircularButton: UIButton {

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
    
    @IBInspectable var circularButtonType: CircularButtonType = .Hollow {
        didSet(oldType) {
            if circularButtonType != oldType {
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
        
        let maximumPossibleRadius = minimumLength/2 - borderWidth
        
        if borderColor == UIColor.black {
            // For blak border stroke
            let path = UIBezierPath(arcCenter: CGPoint(x:bounds.width/2, y:bounds.height/2), radius: maximumPossibleRadius, startAngle: 0, endAngle: 360, clockwise: true)
            path.lineWidth = borderWidth
            borderColor.setStroke()
            path.stroke()
        }
        
        var locations: [CGFloat]
        let colorspace = CGColorSpaceCreateDeviceRGB()
        var colors = [CGColor]()
        var startPoint = CGPoint()
        var endPoint = CGPoint()
        let context = UIGraphicsGetCurrentContext()
        if let context = context{
            // Make small hole
            if circularButtonType == .Hollow{
                startPoint.x = centerX * 0.9
                startPoint.y = centerY * 1.3
                endPoint.x = centerX
                endPoint.y = centerY
                let startRadius: CGFloat = 0
                let endRadius: CGFloat = maximumPossibleRadius/2
                locations = [0.0, 0.7, 1.0]
                colors = [UIColor.lightGray.cgColor, UIColor.lightGray.cgColor, UIColor.brown.cgColor]
                let gradient = CGGradient(colorsSpace: colorspace, colors: colors, locations: locations)
                context.drawRadialGradient (gradient!, startCenter: startPoint,
                                             startRadius: startRadius, endCenter: endPoint, endRadius: endRadius,
                                             options: CGGradientDrawingOptions(rawValue: UInt32(0)))
            } else if circularButtonType == .ColorSelection {
                // Normal circle
                startPoint.x = centerX/1.2
                startPoint.y = centerY/1.2
                endPoint.x = centerX
                endPoint.y = centerY
                let startRadius: CGFloat = 0
                let endRadius: CGFloat = maximumPossibleRadius * 0.75 //- borderWidth/2
                locations = [0.0, 1.0]
                colors = [UIColor.white.cgColor, fillColor.cgColor]
                let gradient = CGGradient(colorsSpace: colorspace, colors: colors, locations: locations)
                context.drawRadialGradient (gradient!, startCenter: startPoint,
                                             startRadius: startRadius, endCenter: endPoint, endRadius: endRadius,
                                             options: CGGradientDrawingOptions(rawValue: UInt32(0)))
            } else if circularButtonType == .ColorPlaced {
                // Normal circle
                startPoint.x = centerX/1.2
                startPoint.y = centerY/1.2
                endPoint.x = centerX
                endPoint.y = centerY
                let startRadius: CGFloat = 0
                let endRadius: CGFloat = maximumPossibleRadius * 0.65 //- borderWidth/2
                locations = [0.0, 1.0]
                colors = [UIColor.white.cgColor, fillColor.cgColor]
                let gradient = CGGradient(colorsSpace: colorspace, colors: colors, locations: locations)
                context.drawRadialGradient (gradient!, startCenter: startPoint,
                                            startRadius: startRadius, endCenter: endPoint, endRadius: endRadius,
                                            options: CGGradientDrawingOptions(rawValue: UInt32(0)))
            }

        } else {
            print("No Context....")
        }
        
    }
}
