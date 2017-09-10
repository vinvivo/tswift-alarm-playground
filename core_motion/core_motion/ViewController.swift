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

// for accessing CoreMotion data
import CoreMotion

// for playing audio files
import AVFoundation


class ViewController: UIViewController {
//- Core Motion declaration
    var motionManager: CMMotionManager?
    
//- Set minumum rotation rate for turning off alarm [x, y, z] units of radians/second
    var expected:[Double] = [60, 60, 60]
    
//- Audio player declaration
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var rotateLabel: UILabel!
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var rotationImageInstruction: UIImageView!
    
    var rotationSelection: Int = Int()  // generated in ViewDidLoad
    
    
//- StartAlarm
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
                    self.audioPlayer.pause()
                    Manager.stopDeviceMotionUpdates()
                }
            }
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
//----- Start collecting motion data on load
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
        
//----- Gradient background created programmatically
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor( red:0.557, green:0.000, blue:0.000, alpha:1.000).cgColor,UIColor( red:1.000, green:0.000, blue:0.000, alpha:1.000).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        self.view.layer.insertSublayer(gradient, at: 0)
        
//----- randomly select rotation axis on load
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
        
//----- Display instructions in label on UI
        rotateLabel.text = "Rotate phone \(aroundAxis) to turn off alarm"
        
//----- Auto-play audio on load
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "algo_alarm", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
            
            let audioSession = AVAudioSession.sharedInstance()
            
            do{
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            }
            catch{
                //
            }
        }
        catch {
            print(error)
        }

        
    }
    
    func degrees(radians: Double) -> Double {
        return 180/Double.pi * radians
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

