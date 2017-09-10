//
//  ViewController.swift
//  core_motion
//
//  Created by Liseth Cardozo Sejas, Shantini Vyas, Jonathan Poso, and Vinney Le
//  on 9/8/17.
//  Copyright © 2017 Liseth Cardozo Sejas, Shantini Vyas, Jonathan Poso, and
//  Vinney Le. All rights reserved.
//

import UIKit

import CoreMotion

class ViewController: UIViewController {
    // Shantini
    var motionManager: CMMotionManager?
    var expected:[Double] = [100, 60, 60]
    
    @IBOutlet weak var rotateLabel: UILabel!
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var rotationImageInstruction: UIImageView!
    
    var rotationSelection: Int = Int()  // generated in ViewDidLoad
    
    
    // Shantini
    func StartAlarm(Manager: CMMotionManager, Expected: [Double]){
        let myq = OperationQueue() //declares a new queue
        var count = 0
        var lazy = 0
      //  self.rotationRate.text = String("Hello!")
        
        Manager.startDeviceMotionUpdates(to: myq){ //callback function from starting the updates and adding them to the queue
            (data: CMDeviceMotion?, error: Error?) in //data that is expected tp come in from the device motion updates
            if let mydata = data {
                let rotation = mydata.rotationRate
                var rotationArray: [Double] = []
                let rx = abs(self.degrees(radians: rotation.x))
                let ry = abs(self.degrees(radians: rotation.y))
                let rz = abs(self.degrees(radians: rotation.z))
                rotationArray.append(rx)
                rotationArray.append(ry)
                rotationArray.append(rz)
                
                if lazy > 10 {
                    count = 0
                    lazy = 0
                }
                if rotationArray[self.rotationSelection] < Expected[self.rotationSelection]{
                    print("going too slow")
                    lazy += 1
                }
                else{
                    count+=1
                }
                
                print(rotationArray[self.rotationSelection])
                
                print(count)
                print (lazy)
                if count > 10{
                    print("YAY!")
                    self.rotateLabel.text = "G O O D   M O R N I N G"
                    Manager.stopDeviceMotionUpdates()
                }
            }
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Shantini
        motionManager = CMMotionManager()
        if let manager = motionManager {
            print("We have a motion manager \(manager)")
            if manager.isDeviceMotionAvailable {
                print("We can detect motion!")
                let myq = OperationQueue()
                manager.deviceMotionUpdateInterval = 1
                manager.startDeviceMotionUpdates(to: myq){
                    (data: CMDeviceMotion?, error: Error?) in
                    if data != nil {
                        self.StartAlarm(Manager: manager, Expected: self.expected)
                    }
                }
            }
            else { print("We cannot detect motion") }
        }
        else { print("No manager") }
        
        // Programmatically create red gradient background
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor( red:0.557, green:0.000, blue:0.000, alpha:1.000).cgColor,UIColor( red:1.000, green:0.000, blue:0.000, alpha:1.000).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        self.view.layer.insertSublayer(gradient, at: 0)
        
        // randomly select rotation axis on load
        let randomNumber = Int(arc4random_uniform(3))
        var aroundAxis: String = ""
        rotationSelection = randomNumber     // this sets var rotation to an integer used in func StartAlarm
        if randomNumber == 0 {
            aroundAxis = "around PITCH axis (forward/ backward)"
            rotationImageInstruction.image = UIImage(named: "pitchAxis")
        } else if randomNumber == 1 {
            aroundAxis = "around ROLL axis (left/ right)"
            rotationImageInstruction.image = UIImage(named: "rollAxis")
        } else {
            aroundAxis = "around YAW axis (clockwise/ counterclockwise)"
            rotationImageInstruction.image = UIImage(named: "yawAxis")
        }
        
        rotateLabel.text = "Rotate phone \(aroundAxis) to turn off alarm"
        
    }
    
    func degrees(radians: Double) -> Double {
        return 180/Double.pi * radians
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

