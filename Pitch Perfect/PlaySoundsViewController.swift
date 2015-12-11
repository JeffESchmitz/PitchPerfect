//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jeff Schmitz on 12/6/15.
//  Copyright © 2015 Jeff Schmitz. All rights reserved.

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // MARK: - PlaySoundsViewController fields
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    @IBOutlet weak var stopButton: UIButton!
    
    // MARK: - View's overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopButton.enabled = false
       
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        } catch {
            print(error)
        }
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        
        do {
            try audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl)
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Interface Builder handler functions
    @IBAction func stopPlayingAudio(sender: UIButton) {
        audioPlayer.stop()
        stopButton.enabled = false
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithVariableEffect(AudioEffect.Slow)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithVariableEffect(AudioEffect.Fast)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariableEffect(AudioEffect.Chipmunk)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariableEffect(AudioEffect.DarthVader)
    }
    
    // MARK: - PlaySoundsViewController functions
    func playAudioWithVariableEffect(audioEffect: AudioEffect) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        switch audioEffect {
        case .Slow:
            fallthrough
        case .Fast:
            playAudioWithVariableRate(audioEffect.rawValue)
        case .Chipmunk:
            fallthrough
        case .DarthVader:
            playAudioWithVariablePitch(audioEffect.rawValue)
        }
        
        stopButton.enabled = true
    }
    
    func playAudioWithVariableRate(rate: Float) -> Void {
        audioPlayer.enableRate = true
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch {
            print(error)
        }
        
        audioPlayerNode.play()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

enum AudioEffect: Float {
    case Slow = 0.5
    case Fast = 1.5
    case Chipmunk = 1000
    case DarthVader = -1000
}