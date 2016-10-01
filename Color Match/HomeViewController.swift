//
//  HomeViewController.swift
//  Color Match
//
//  Created by Bikram Dangol on 8/15/16.
//  Copyright © 2016 AppCoders. All rights reserved.
//

import UIKit

var isSoundOn:Bool = true

class HomeViewController: UIViewController {

    @IBOutlet var playButton: UIButton!
    @IBAction func playButtonPressed(_ sender: UIButton) {
        
    }
    @IBOutlet var fourButton: UIButton!
    @IBOutlet var fiveButton: UIButton!
    @IBOutlet var eightTriesButton: UIButton!
    @IBOutlet var tenTriesButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        sizeSelected(fourButton)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func soundSwitchChanged(_ sender: UISwitch) {
        isSoundOn = sender.isOn
    }

    @IBAction func sizeSelected(_ sender: UIButton) {
        switch sender.tag
        {
            case 4:
                fourButton.backgroundColor = UIColor.darkGray
                fiveButton.backgroundColor = UIColor.lightGray
                columnSize = 4
                triesSelected(eightTriesButton)
                tenTriesButton.isHidden = true
            case 5:
                fourButton.backgroundColor = UIColor.lightGray
                fiveButton.backgroundColor = UIColor.darkGray
                columnSize = 5
                triesSelected(tenTriesButton)
                tenTriesButton.isHidden = false
            default:
                columnSize = 4
        }
    }
    @IBAction func triesSelected(_ sender: UIButton) {
        switch sender.tag
        {
        case 8:
            eightTriesButton.backgroundColor = UIColor.darkGray
            tenTriesButton.backgroundColor = UIColor.lightGray
            maxTries = 8
        case 10:
            eightTriesButton.backgroundColor = UIColor.lightGray
            tenTriesButton.backgroundColor = UIColor.darkGray
            maxTries = 10
        default:
            maxTries = 8
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
