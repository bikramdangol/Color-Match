//
//  ViewController.swift
//  Color Match
//
//  Created by Bikram Dangol on 8/13/16.
//  Copyright © 2016 AppCoders. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var colorCodeView: UIView!
    @IBOutlet var backgroundImage: UIImageView!
    var selectedButton: CircularButton = CircularButton()
    let maxTry = 8
    var selectedColor = UIColor.clear
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
        
        // Build color selection row
        for i in 0..<6
        {
            let circularButton = CircularButton()
            circularButton.borderColor = UIColor.white
            circularButton.fillColor = colors[i]
            circularButton.circularButtonType = .ColorSelection
            circularButton.frame = CGRect(x: CGFloat(i) * circleDiameter, y: 0, width: circleDiameter, height: circleDiameter)
            circularButton.addTarget(self, action: #selector(ViewController.selectColor(_:)), for:.touchUpInside)
            self.colorCodeView.addSubview(circularButton)
        }
        
        // Put divider
        let transparentRow = UIView(frame: CGRect(x: 0, y: self.view.frame.height - circleDiameter, width: self.view.frame.width , height: circleDiameter * 0.1))
        let darkLine = UIView(frame: CGRect(x: 0, y: self.view.frame.height - circleDiameter, width: self.view.frame.width , height: 2))
        let lightLine = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 2 - circleDiameter, width: self.view.frame.width , height: 2))
        let darkBrownLine = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 2 - circleDiameter - (circleDiameter * 0.1), width: self.view.frame.width , height: circleDiameter * 0.1))
        transparentRow.alpha = 0.5
        transparentRow.backgroundColor = UIColor.white
        self.view.addSubview(transparentRow)
        darkLine.backgroundColor = UIColor.brown
        self.view.addSubview(darkLine)
        
        lightLine.backgroundColor = UIColor.white
        lightLine.alpha = 0.3
        self.view.addSubview(lightLine)
        
        darkBrownLine.backgroundColor = UIColor.brown
        darkBrownLine.alpha = 0.6
        self.view.addSubview(darkBrownLine)
        
        // Fill board
        for i in 1...8
        {
            let tryRow = UIView(frame: CGRect(x: 0, y: self.view.frame.height - CGFloat(i + 1) * circleDiameter, width: self.view.frame.width - 2 * circleDiameter, height: circleDiameter))
            self.view.addSubview(tryRow)
            for j in 0..<4
            {
                let circularButton = CircularButton()
                circularButton.borderColor = UIColor.white
                circularButton.fillColor = UIColor.clear
                circularButton.frame = CGRect(x: CGFloat(j) * circleDiameter, y: 0, width: circleDiameter, height: circleDiameter)
                circularButton.addTarget(self, action: #selector(ViewController.dropColor(_:)), for:.touchUpInside)
                tryRow.addSubview(circularButton)
            }
        }
        
    }
    
    func selectColor(_ sender:CircularButton)
    {
        selectedButton.borderColor = UIColor.white
        sender.borderColor = UIColor.black
        selectedButton = sender
        selectedColor = sender.fillColor
        print(sender.fillColor)
    }
    
    func dropColor(_ sender:CircularButton)
    {
        sender.fillColor = selectedColor
        sender.circularButtonType = .ColorPlaced
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

