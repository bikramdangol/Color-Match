//
//  ViewController.swift
//  Color Match
//
//  Created by Bikram Dangol on 8/13/16.
//  Copyright © 2016 AppCoders. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var circularButton: CircularButton!
    @IBOutlet var colorCodeView: UIView!
    var selectedButton: CircularButton = CircularButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let numberOfColors = 6
        let widthOfScreen = self.view.frame.width
        let circleDiameter = widthOfScreen/CGFloat(numberOfColors)
        print("Circle diameter is : \(circleDiameter)")
        let colors:[UIColor] = [UIColor.red,UIColor.green,UIColor.yellow,UIColor.blue,UIColor.cyan,UIColor.magenta]
        colorCodeView.frame = CGRect(x: 0, y: self.view.frame.height - circleDiameter, width: self.view.frame.width, height: circleDiameter)
        
        print("Color view height is : \(colorCodeView.frame.height)")
        
        for i in 0..<6
        {
            let circularButton = CircularButton()
            circularButton.borderColor = UIColor.white
            circularButton.fillColor = colors[i]
            circularButton.frame = CGRect(x: CGFloat(i) * circleDiameter, y: 0, width: circleDiameter, height: circleDiameter)
            circularButton.addTarget(self, action: #selector(ViewController.selectColor(_:)), for:.touchUpInside)
            self.colorCodeView.addSubview(circularButton)
        }
        
    }
    
    func selectColor(_ sender:CircularButton)
    {
        selectedButton.borderColor = UIColor.white
        sender.borderColor = UIColor.black
        selectedButton = sender
        self.circularButton.fillColor = sender.fillColor
        print(sender.fillColor)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

