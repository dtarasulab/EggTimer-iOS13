//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Edited by Dennis Tarasula on March 2, 2024.
//  Copyright © 2019 The App Brewery. All rights reserved.
//
//  Enhancements:
//  1. Added a countdown timer showing the seconds remaining.
//  2. Added a way to set a custom time instead of using the presets.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var customTimeTextField: UITextField!
    
    let eggTimes = ["Soft": 3, "Medium": 4, "Hard": 7]
    
    var hardness = ""
    var totalTime = 0, secondsPassed = 0, secondsRemaining = 0
    var timer = Timer()
    var player: AVAudioPlayer!
    
    @objc func updateTimer() {
        if secondsPassed < totalTime {
            secondsPassed += 1
            secondsRemaining -= 1
            progressBar.progress = Float(secondsPassed) / Float(totalTime)
            countdownLabel.text = String(secondsRemaining)
        } else {
            timer.invalidate()
            titleLabel.text = "DONE!"
            countdownLabel.text = String(0)
            
            let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
        }
    }
    
    func setTimerAndProgressBar(){
        timer.invalidate()
        secondsRemaining = totalTime
        countdownLabel.text = String(secondsRemaining)
        
        progressBar.progress = 0.0
        secondsPassed = 0
        titleLabel.text = hardness
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        hardness = sender.currentTitle!
        totalTime = eggTimes[hardness]!
        setTimerAndProgressBar()
    }
    
    @IBAction func customTimeButtonPressed(_ sender: Any) {
        hardness = "Custom"
        if let input = customTimeTextField.text, let time = Int(input) {
            totalTime = time
        } else {
            print("Error, custom time cannot be null.")
            totalTime = 0
        }
        setTimerAndProgressBar()
    }
}
