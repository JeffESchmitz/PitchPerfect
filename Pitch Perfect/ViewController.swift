//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Jeff Schmitz on 11/30/15.
//  Copyright © 2015 Jeff Schmitz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordingInProgress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingInProgress.hidden = false
        print("in recordAudio")
    }

    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.hidden = true
    }
}

