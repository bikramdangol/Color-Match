//
//  ViewController.swift
//  Color Match
//
//  Created by Bikram Dangol on 8/13/16.
//  Copyright © 2016 AppCoders. All rights reserved.
//

import UIKit
import AudioToolbox

var columnSize = 4
var maxTries = 8

class ViewController: UIViewController {

    @IBOutlet var colorSelectionView: UIView!
    @IBOutlet var backgroundImage: UIImageView!
    var colorCodeRowView:UIView!
    var selectedButton: CircularButton = CircularButton()
    
    
    let numberOfColors = 6
    let colors:[UIColor] = [UIColor.red,UIColor.green,UIColor.yellow,UIColor.blue,UIColor.cyan,UIColor.magenta]
    var circleDiameter: CGFloat = 0.0
    var selectedColor = UIColor.clear
    
    var exactPosition:Int = 0;
    
    var originalX: CGFloat = 0.0
    var originalY: CGFloat = 0.0
    var indexOfNearestTargetButton: Int = -1
    var indexOfCurrentTargetButton: Int = -1
    var indexOfPreviousTargetButton: Int = -1
    var previousDragPositionX: CGFloat = 0.0
    var currentRow:Int = 0
    var previousSelectedButton:CircularButton = CircularButton()
    
    struct ColorPieceInformation {
        var center: CGPoint
        var color: UIColor
        var colorButton: CircularButton
    }
    
    enum GameStatus
    {
        case inProgress
        case won
        case lose
    }
    
    var colorPickArea:[ColorPieceInformation] = [ColorPieceInformation](repeating: ColorPieceInformation(center: CGPoint(x: 0.0, y: 0.0), color: UIColor.white, colorButton:CircularButton()), count: 6)
    
    var colorDropAreaRow:[ColorPieceInformation] = [ColorPieceInformation](repeating: ColorPieceInformation(center: CGPoint(x: 0.0, y: 0.0), color: UIColor.white, colorButton:CircularButton()), count: columnSize)
    var colorCodeRow:[ColorPieceInformation] = [ColorPieceInformation](repeating: ColorPieceInformation(center: CGPoint(x: 0.0, y: 0.0), color: UIColor.white, colorButton:CircularButton()), count: columnSize)
    var hintAreaRow:[ColorPieceInformation] = [ColorPieceInformation](repeating: ColorPieceInformation(center: CGPoint(x: 0.0, y: 0.0), color: UIColor.white, colorButton:CircularButton()), count: columnSize)
    var colorDropArea:Array = Array<Array<ColorPieceInformation>>()
    var hintArea:Array = Array<Array<ColorPieceInformation>>()
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    func fillColorDropArea()
    {
        for _ in 0..<maxTries
        {
            colorDropArea.append(colorDropAreaRow)
        }
    }
    
    func fillHintArea()
    {
        for _ in 0..<maxTries
        {
            hintArea.append(hintAreaRow)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initGame()
    }
    
    func initGame()
    {
        let numberOfColors = 6
        let widthOfScreen = self.view.frame.width
        circleDiameter = widthOfScreen/CGFloat(numberOfColors)
        print("Circle diameter is : \(circleDiameter)")
        
        colorSelectionView.frame = CGRect(x: 0, y: self.view.frame.height - circleDiameter, width: self.view.frame.width, height: circleDiameter)
        
        print("Color view height is : \(colorSelectionView.frame.height)")
        //default fill
        fillColorDropArea()
        fillHintArea()
        // Build color selection row
        for i in 0..<6
        {
            let circularButton = CircularButton()
            circularButton.borderColor = UIColor.white
            circularButton.fillColor = colors[i]
            circularButton.circularButtonType = .ColorSelection
            circularButton.frame = CGRect(x: CGFloat(i) * circleDiameter, y: 0, width: circleDiameter, height: circleDiameter)
            //circularButton.addTarget(self, action: #selector(ViewController.selectColor(_:)), for:.touchUpInside)
            circularButton.addTarget(self, action: #selector(ViewController.selectColor(_:)), for:.touchDown)
            
            //Pan
            let pan = UIPanGestureRecognizer(target: self, action: #selector(ViewController.panButton(pan:)))
            circularButton.addGestureRecognizer(pan)
            circularButton.isUserInteractionEnabled = true
            
            self.colorSelectionView.addSubview(circularButton)
            self.colorSelectionView.layer.zPosition = 1
            //Hold color information
            let center:CGPoint = CGPoint(x: CGFloat(i) * circleDiameter + circleDiameter/2, y: circleDiameter/2)
            let colorPieceInformation:ColorPieceInformation = ColorPieceInformation(center: center, color: colors[i], colorButton: circularButton)
            colorPickArea[i] = colorPieceInformation
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
        // Create color code
        createColorCode()
        
        let dropCircleDiameter = circleDiameter * 4 / CGFloat(columnSize)
        
        
        // Fill board
        for i in 0..<maxTries
        {
            let tryRow:UIView
            if i == 0
            {
                tryRow = UIView(frame: CGRect(x: 0, y: self.view.frame.height - CGFloat(2) * circleDiameter, width: self.view.frame.width - 2 * circleDiameter, height: dropCircleDiameter))
            }
            else
            {
                tryRow = UIView(frame: CGRect(x: 0, y: self.view.frame.height - CGFloat(2) * circleDiameter - CGFloat(i) * dropCircleDiameter, width: self.view.frame.width - 2 * circleDiameter, height: dropCircleDiameter))
            }
            
            //tryRow.backgroundColor = UIColor.darkGray
            self.view.addSubview(tryRow)
            for j in 0..<columnSize
            {
                let circularButton = CircularButton()
                circularButton.borderColor = UIColor.white
                circularButton.fillColor = UIColor.clear
                circularButton.tag = i * columnSize + j
                circularButton.frame = CGRect(x: CGFloat(j) * dropCircleDiameter, y: 0, width: dropCircleDiameter, height: dropCircleDiameter)
                //circularButton.addTarget(self, action: #selector(ViewController.dropColor(_:)), for:.touchUpInside)
                tryRow.addSubview(circularButton)
                //Hold color information default values
                let center:CGPoint = CGPoint(x: CGFloat(j) * dropCircleDiameter + dropCircleDiameter/2, y: dropCircleDiameter/2)
                let colorPieceInformation:ColorPieceInformation = ColorPieceInformation(center: center, color: UIColor.clear, colorButton: circularButton)
                colorDropArea[i][j] = colorPieceInformation
            }
            
            // Hint board goes here
            // let hintRow = UIView(frame: CGRect(x: self.view.frame.width - 2 * circleDiameter, y: self.view.frame.height - CGFloat(i + 2) * circleDiameter, width: 2 * circleDiameter, height: circleDiameter))
            //self.view.addSubview(hintRow)
            for j in 0..<columnSize
            {
                let circularButton = CircularButton()
                circularButton.borderColor = UIColor.white
                circularButton.fillColor = UIColor.clear
                circularButton.circularButtonType = .Hint
                circularButton.frame = CGRect(x: tryRow.frame.width + CGFloat(j) * circleDiameter * 2.0 / CGFloat(columnSize + 1), y: 0, width: dropCircleDiameter, height: dropCircleDiameter)
                //circularButton.addTarget(self, action: #selector(ViewController.dropColor(_:)), for:.touchUpInside)
                tryRow.addSubview(circularButton)
                //Hold hint information default values
                let center:CGPoint = CGPoint(x: CGFloat(i) * dropCircleDiameter + dropCircleDiameter/2, y: dropCircleDiameter/2)
                let colorPieceInformation:ColorPieceInformation = ColorPieceInformation(center: center, color: UIColor.clear, colorButton: circularButton)
                hintArea[i][j] = colorPieceInformation
                
            }
            
        }
        
        activateTheFirstRow()
    }
    
    func createColorCode()
    {
        let colorCodeCircleDiameter = circleDiameter * 4 / CGFloat(columnSize)
        colorCodeRowView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - circleDiameter, width: self.view.frame.width - 2 * circleDiameter, height: circleDiameter))
        self.view.addSubview(colorCodeRowView)
        for column in 0..<columnSize
        {
            let randomColorCode = Int(arc4random_uniform(UInt32(numberOfColors)))
            
            let circularButton = CircularButton()
            circularButton.borderColor = UIColor.white
            circularButton.fillColor = colors[randomColorCode]
            circularButton.circularButtonType = .ColorPlaced
            circularButton.frame = CGRect(x: CGFloat(column) * colorCodeCircleDiameter, y: (circleDiameter - colorCodeCircleDiameter) / 2, width: colorCodeCircleDiameter, height: circleDiameter)
            colorCodeRowView.addSubview(circularButton)
            
            //Hold color code information
            let center:CGPoint = CGPoint(x: CGFloat(column) * colorCodeCircleDiameter + colorCodeCircleDiameter/2, y: colorCodeCircleDiameter/2)
            let colorPieceInformation:ColorPieceInformation = ColorPieceInformation(center: center, color: colors[randomColorCode], colorButton: circularButton)
            colorCodeRow[column] = colorPieceInformation
            
            colorCodeRowView.isHidden = true

        }

    }
    
    func activateTheFirstRow()
    {
        activateARow(whoseRowNumberIs: 0)
    }
    
    func activateARow(whoseRowNumberIs row:Int)
    {
        var circularButton:CircularButton
        for column in 0..<columnSize
        {
            circularButton = (colorDropArea[row][column] as ColorPieceInformation).colorButton
            circularButton.addTarget(self, action: #selector(ViewController.dropColor(_:)), for:.touchUpInside)
        }
        currentRow = row
    }
    
    func deactivateARow(whoseRowNumberIs row:Int)
    {
        var circularButton:CircularButton
        for column in 0..<columnSize
        {
            circularButton = (colorDropArea[row][column] as ColorPieceInformation).colorButton
            circularButton.removeTarget(self, action: #selector(ViewController.dropColor(_:)), for:.touchUpInside)
        }
    }
    
    //Pan
    
    func panButton(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: view)
        let button = pan.view! as! CircularButton
        print(button.center.x)
        print("Button Y: \(button.center.y)")
        if originalX == 0.0 {
            originalX = button.center.x
            originalY = button.center.y
        }
        button.center = CGPoint(x: originalX + translation.x, y: originalY + translation.y - button.bounds.width/2)
        print("pan begin. translation (x, y) is (\(translation.x), \(translation.y)")
        if -translation.y > button.bounds.width/4
        {
            if indexOfNearestTargetButton == -1
            {
                indexOfNearestTargetButton = getNearestTargetButtonIndex(from : button)
                indexOfCurrentTargetButton = indexOfNearestTargetButton
                indexOfPreviousTargetButton = indexOfCurrentTargetButton
                (colorDropArea[currentRow][indexOfCurrentTargetButton] as ColorPieceInformation).colorButton.isTarget = true
                previousDragPositionX = button.center.x
                
            }
            let targetRowY = getTargetRowY()
            let deltaY = abs(targetRowY) - abs(button.center.y + (button.superview?.frame.origin.y)!)
            print("deltaY = \(deltaY) and circleDiameter is: \(circleDiameter)")
            if abs(deltaY) < circleDiameter
            {// When panned color is close to the target, get target index of the nearest one.
                // Need to fix this.
                indexOfCurrentTargetButton = getNearestTargetButtonIndex(from: button)
                (colorDropArea[currentRow][indexOfPreviousTargetButton] as ColorPieceInformation).colorButton.isTarget = false
                (colorDropArea[currentRow][indexOfCurrentTargetButton] as ColorPieceInformation).colorButton.isTarget = true
                previousDragPositionX = button.center.x
                indexOfPreviousTargetButton = indexOfCurrentTargetButton
            }
            else
            {// When panned color is not close to the target, select target index with slight movement.
                let deltaX = button.center.x - previousDragPositionX
                print("DeltaX is : \(deltaX)")
                let requiredMoveSteps = Int(deltaX/(circleDiameter/3.0))
                if abs(requiredMoveSteps) > 0
                {
                    indexOfCurrentTargetButton += requiredMoveSteps
                    if indexOfCurrentTargetButton >= columnSize
                    {
                        indexOfCurrentTargetButton = columnSize - 1
                    }
                    else if indexOfCurrentTargetButton < 0
                    {
                        indexOfCurrentTargetButton = 0
                    }
                    (colorDropArea[currentRow][indexOfPreviousTargetButton] as ColorPieceInformation).colorButton.isTarget = false
                    (colorDropArea[currentRow][indexOfCurrentTargetButton] as ColorPieceInformation).colorButton.isTarget = true
                    previousDragPositionX = button.center.x
                    indexOfPreviousTargetButton = indexOfCurrentTargetButton
                    
                }
            }
            
            
        }
        else if indexOfCurrentTargetButton >= 0
        {
            resetTargetInformation()
            previousDragPositionX = 0.0
        }
        if pan.state == .began {
            
            //buttonCenter = pan.center // store old button center
        } /*else if pan.state == .Ended || pan.state == .Failed || pan.state == .Cancelled {
         button.center = buttonCenter // restore button center
         } else {
         let location = pan.locationInView(view) // get pan location
         button.center = location // set button to where finger is
         }*/
        if pan.state == .cancelled
        {
            // While dragging, if home button is pressed the pan state will be cancelled.
            resetTargetInformation()
            previousDragPositionX = 0.0

            button.center.x = originalX
            button.center.y = originalY
            originalX = 0.0
            originalY = 0.0
            selectColor(button)
        }
        if pan.state == UIGestureRecognizerState.ended {
            button.center.x = originalX
            button.center.y = originalY
            originalX = 0.0
            originalY = 0.0
            selectColor(button)
            if indexOfCurrentTargetButton >= 0
            {
                let targetButton:CircularButton = (colorDropArea[currentRow][indexOfCurrentTargetButton] as ColorPieceInformation).colorButton
                
                targetButton.isTarget = false
                indexOfNearestTargetButton = -1
                indexOfCurrentTargetButton = -1
                indexOfPreviousTargetButton = -1
                previousDragPositionX = 0.0
                
                dropColor(targetButton)
            }
        }
    }
    
    func resetTargetInformation()
    {
        (colorDropArea[currentRow][indexOfCurrentTargetButton] as ColorPieceInformation).colorButton.isTarget = false
        indexOfNearestTargetButton = -1
        indexOfCurrentTargetButton = -1
        indexOfPreviousTargetButton = -1
    }
    
    func getTargetRowY() -> CGFloat
    {
        return (colorDropArea[currentRow][0] as ColorPieceInformation).center.y
    }
    
    func getNearestTargetButtonIndex(from selectedButton:CircularButton) -> Int
    {
        var shortestDistance = self.view.bounds.width
        var indexOfNearestTargetButton = 0
        for (index, colorPieceInformation) in colorDropArea[currentRow].enumerated()
        {
            if abs((colorPieceInformation.center.x) - selectedButton.center.x) < shortestDistance
            {
                shortestDistance = abs((colorPieceInformation.center.x) - selectedButton.center.x)
                indexOfNearestTargetButton = index
            }
        }
        return indexOfNearestTargetButton
    }
    
    func selectColor(_ sender:CircularButton)
    {
        previousSelectedButton.circularButtonType = .ColorSelection
        if isSoundOn
        {
            AudioServicesPlaySystemSound(1104);
        }
        //selectedButton.borderColor = UIColor.white
        sender.circularButtonType = .ColorSelectionPressed
        //sender.borderColor = UIColor.black
        selectedButton = sender
        selectedColor = sender.fillColor
        print(sender.fillColor)
        previousSelectedButton = sender
    }
    
    func dropColor(_ sender:CircularButton)
    {
        
        if selectedColor != UIColor.clear{
            if isSoundOn
            {                
                if sender.fillColor == UIColor.clear
                {
                    AudioServicesPlaySystemSound(1104);
                }
                else
                {
                    AudioServicesPlaySystemSound(1055);
                }
            }
            sender.fillColor = selectedColor
            sender.circularButtonType = .ColorPlaced
            saveColorInformationInBoard(sender)
        }
        let currentRow = sender.tag / columnSize
        if isAllColumnsFilled(inRow: currentRow)
        {
            if isSoundOn
            {                
                AudioServicesPlaySystemSound(1054);
            }
            deactivateARow(whoseRowNumberIs: currentRow)
            
            provideHint(forRow: currentRow)
            let gameStatus:GameStatus = getGameStatus(at: currentRow)
            switch gameStatus
            {
                case .inProgress:
                    activateARow(whoseRowNumberIs: currentRow + 1)
                case .won:
                    showColorCode()
                    showAlert(withTitle: "Congratulations", andWithMessage:"You won! Would you like to play again?")
                case .lose:
                    showColorCode()
                    showAlert(withTitle: "Game Over", andWithMessage:"You lose! Would you like to play again?")
            }
        }
    }
    
    func showAlert(withTitle title: String, andWithMessage message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Play again", style: UIAlertActionStyle.default, handler: restartGame))
        alert.addAction(UIAlertAction(title: "Exit", style: UIAlertActionStyle.destructive, handler: goBack))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func restartGame(action:UIAlertAction)
    {
        resetGame()
    }
    
    func resetGame()
    {
        //reset color drop area and hint area
        for row in 0..<maxTries
        {
            for column in 0..<columnSize
            {
                (colorDropArea[row][column] as ColorPieceInformation).colorButton.fillColor = UIColor.clear
                (colorDropArea[row][column] as ColorPieceInformation).colorButton.circularButtonType = .Hollow
                
                (hintArea[row][column] as ColorPieceInformation).colorButton.fillColor = UIColor.clear
            }
        }
        
        // hide and set color code
        colorCodeRowView.isHidden = true
        for column in 0..<columnSize
        {
            let randomColorCode = Int(arc4random_uniform(UInt32(numberOfColors)))
            (colorCodeRow[column] as ColorPieceInformation).colorButton.fillColor = colors[randomColorCode]
        }
        // show color selection row
        colorSelectionView.isHidden = false
        
        activateTheFirstRow()
    }
    
    func goBack(action:UIAlertAction)
    {
        self.dismiss(animated: true) { }
    }
    
    func showColorCode()
    {
        colorCodeRowView.isHidden = false
        colorSelectionView.isHidden = true
    }
    
    func getGameStatus(at currentRow:Int) -> GameStatus
    {
        let gameStatus:GameStatus
        if exactPosition == columnSize
        {
            gameStatus = .won
        }
        else if currentRow == maxTries - 1
        {
            gameStatus = .lose
        }
        else
        {
            gameStatus = .inProgress
        }
        return gameStatus
    }
    
    func provideHint(forRow currentRow:Int)
    {
        exactPosition = 0;
        var colorMatch:Int = 0;
        var exactPositionArray:Array = [false,false,false,false,false];
        var colorMatchArray:Array = [false,false,false,false,false];
        for i in 0..<columnSize
        {
            if (colorCodeRow[i] as ColorPieceInformation).color == (colorDropArea[currentRow][i] as ColorPieceInformation).color
            {
                exactPosition += 1;
                exactPositionArray[i] = true;
                colorMatchArray[i] = true;
            }
        }
        
        for i in 0..<columnSize
        {
            for j in 0..<columnSize
            {
                if(!exactPositionArray[i] && !colorMatchArray[j] && (colorCodeRow[i] as ColorPieceInformation).color == (colorDropArea[currentRow][j] as ColorPieceInformation).color)
                {
                    colorMatch += 1;
                    colorMatchArray[j] = true;
                    break;
                }
            }
        }
        
        for i in 0..<exactPosition
        {
            (hintArea[currentRow][i] as ColorPieceInformation).colorButton.fillColor = UIColor.black
        }
        
        for j in exactPosition..<colorMatch+exactPosition
        {
            (hintArea[currentRow][j] as ColorPieceInformation).colorButton.fillColor = UIColor.white

        }
        
    }
    
    func isAllColumnsFilled(inRow row:Int) -> Bool
    {
        var isAllColumnsFilled = true
        for column in 0..<columnSize
        {
            if (colorDropArea[row][column] as ColorPieceInformation).colorButton.fillColor == UIColor.clear
            {
                isAllColumnsFilled = false
            }
        }
        return isAllColumnsFilled
    }
    
    func saveColorInformationInBoard(_ sender:CircularButton)
    {
        let center:CGPoint = CGPoint(x: sender.center.x, y: sender.center.y)
        let colorPieceInformation:ColorPieceInformation = ColorPieceInformation(center: center, color: sender.fillColor, colorButton: sender)
        colorDropArea[sender.tag / columnSize][sender.tag % columnSize] = colorPieceInformation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

