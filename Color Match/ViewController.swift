//
//  ViewController.swift
//  Color Match
//
//  Created by Bikram Dangol on 8/13/16.
//  Copyright © 2016 AppCoders. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var circularButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func circularButtonPressed(_ sender: CircularButton) {
        if(sender.fillColor == UIColor.red)
        {
            sender.fillColor = UIColor.green
        }
        else
        {
            sender.fillColor = UIColor.red
        }
    }

}

