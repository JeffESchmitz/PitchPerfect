//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jeff Schmitz on 11/30/15.
//  Copyright © 2015 Jeff Schmitz. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    let backgroundLightBlue = UIColor(red: 0.94, green: 1.00, blue: 1.00, alpha: 1.0)
    let backgroundLightRed = UIColor(red: 1.00, green: 0.89, blue: 0.89, alpha: 1.0)
    let tapToRecordText = "tap to record"
    let recordingInProgressText = "recording in progress..."
    let playSoundsSegueIdentifier = "stopRecording"
    
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
        recordingInProgress.text = tapToRecordText
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        changeViewBackgroundColor(backgroundLightRed)
        stopButton.hidden = false
        recordingInProgress.hidden = false
        recordButton.enabled = false
        recordingInProgress.text = recordingInProgressText
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        // Setup audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            print(error)
        }
        changeViewBackgroundColor(backgroundLightBlue)
        recordingInProgress.text = tapToRecordText
        recordButton.enabled = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            // Save recorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            // navigate to PlaySoundsController scene
            self.performSegueWithIdentifier(playSoundsSegueIdentifier, sender: recordedAudio)
        } else {
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == playSoundsSegueIdentifier {
            let playSoundsViewController:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsViewController.receivedAudio = data
        }
    }

    func changeViewBackgroundColor(color: UIColor) -> Void {
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            self.view.backgroundColor = color
            }, completion: nil)

    }
}

