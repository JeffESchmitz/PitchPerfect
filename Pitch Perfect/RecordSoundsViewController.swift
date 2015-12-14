//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jeff Schmitz on 11/30/15.
//  Copyright © 2015 Jeff Schmitz. All rights reserved.

import UIKit
import AVFoundation

final class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // MARK: - UI Interface Builder Outlet fields
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!

    // MARK: - RecordSoundsViewController fields
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var recordingState = RecordingState.Stopped
    
    let backgroundLightBlue = UIColor(red: 0.94, green: 1.00, blue: 1.00, alpha: 1.0)
    let backgroundLightRed = UIColor(red: 1.00, green: 0.89, blue: 0.89, alpha: 1.0)
    let backgroundGray = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
    
    // Old habit of putting strings into one constant section.
    // This is twofold - 1) To avoid "magic strings" in the code. 2) For translation/internationalization later.
    let tapToRecordText = "tap to record"
    let recordingInProgressText = "recording in progress..."
    let recordingName = "my_audio.wav"
    let playSoundsSegueIdentifier = "stopRecording"
    let recordingNotSuccessfulText = "Recording was not successful"
    let pausedRecordingText = "paused... tap to resume"
    let microphoneImageName = "microphone"
    let resumeImageName = "resume"
    let pauseImageName = "pause"
    
    // MARK: - View's overriden functions    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        recordingState = RecordingState.Stopped
        stopButton.hidden = true
        recordButton.enabled = true
        recordingInProgress.text = tapToRecordText
        
        // Change the button's image to initial state showing microphone.
        // This is just to make sure always showing the microphone when the scene appears.
        if let resumeImage = UIImage(named: microphoneImageName) {
            recordButton.setImage(resumeImage, forState: UIControlState.Normal)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == playSoundsSegueIdentifier {
            let playSoundsViewController:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsViewController.receivedAudio = data
        }
    }
    
    // MARK: - UI Interface Builder handler functions
    @IBAction func recordAudio(sender: UIButton) {
        // Cited Reference: I observed this idea of switching on the state of an enum after reviewing VinceChan's PitchPerfect repo - https://github.com/vincechan/PitchPerfect.
        // Initially I tried an if-elseif-else evaluation here and it got messy/problematic and I threw the code away twice.
        // I liked Vince's simple approach and once the RecordingState enum was created, all the code feel into place. Thanks Vince!
        switch recordingState {
        case .Stopped:
            recordAudioAction()
        case .Recording:
            pauseAudio()
        case .Paused:
            resumeRecordingAudio()
        }
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
    
    
    // MARK: - AVAudioRecorderDelegate implementation
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            print(recordingNotSuccessfulText)
            recordButton.enabled = true
            stopButton.hidden = true
            return
        }
        
        // Save recorded audio
        recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
        
        // navigate to PlaySoundsController scene
        performSegueWithIdentifier(playSoundsSegueIdentifier, sender: recordedAudio)
    }
    
    // MARK: - RecordSoundsViewController functions
    func recordAudioAction() -> Void {
        changeViewBackgroundColor(backgroundLightRed)
        stopButton.hidden = false
        recordingInProgress.hidden = false
        recordingInProgress.text = recordingInProgressText
        
        let directoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let pathArray = [directoryPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        // Setup audio session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            // Cited Reference: Fix for low volume on iPhone by Alex Paul - https://github.com/alexpaul/PitchPerfect
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
            try session.setActive(true)
        } catch {
            print(error)
        }
        
        // Initialize and prepare the recorder with empty settings
        do{
            try audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } catch {
            print(error)
        }
        
        // Change the button's image to pause
        if let pausedImage = UIImage(named: pauseImageName) {
            recordButton.setImage(pausedImage, forState: UIControlState.Normal)
        }
        
        // update the state to recording
        recordingState = RecordingState.Recording
    }
    
    func pauseAudio() -> Void {
        changeViewBackgroundColor(backgroundGray)
        audioRecorder.pause()
        recordingInProgress.text = pausedRecordingText
        recordingState = RecordingState.Paused
        
        // Change the button's image to resume
        if let resumeImage = UIImage(named: resumeImageName) {
            recordButton.setImage(resumeImage, forState: UIControlState.Normal)
        }
    }
    
    func resumeRecordingAudio() -> Void {
        changeViewBackgroundColor(backgroundLightRed)
        audioRecorder.record()
        recordingState = RecordingState.Recording
        recordingInProgress.text = recordingInProgressText
        
        // Change the button's image to pause
        if let pausedImage = UIImage(named: pauseImageName) {
            recordButton.setImage(pausedImage, forState: UIControlState.Normal)
        }
    }
    
    func changeViewBackgroundColor(color: UIColor) -> Void {
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            self.view.backgroundColor = color
            }, completion: nil)
    }
    
    // Enum to instruct which state to execute within the RecordSoundsViewController class.
    // NOTE: I chose to keep this enum code inside the RecordSoundsViewController class as it is the only place used.
    enum RecordingState {
        case Recording
        case Paused
        case Stopped
    }
}

