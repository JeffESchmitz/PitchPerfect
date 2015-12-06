//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Jeff Schmitz on 11/30/15.
//  Copyright © 2015 Jeff Schmitz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let backgroundLightBlue = UIColor(red: 0.94, green: 1.00, blue: 1.00, alpha: 1.0)
    let backgroundLightRed = UIColor(red: 1.00, green: 0.89, blue: 0.89, alpha: 1.0)
    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        stopButton.hidden = true
        recordButton.enabled = true
    }
    @IBAction func recordAudio(sender: UIButton) {
        print("in recordAudio")
        changeViewBackgroundColor(backgroundLightRed)
        recordingInProgress.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
    }

    @IBAction func stopRecording(sender: UIButton) {
        changeViewBackgroundColor(backgroundLightBlue)
        recordingInProgress.hidden = true
        recordButton.enabled = true
    }

    func changeViewBackgroundColor(color: UIColor) -> Void {
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            self.view.backgroundColor = color
            }, completion: nil)

    }
}

