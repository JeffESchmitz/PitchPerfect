//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jeff Schmitz on 12/6/15.
//  Copyright © 2015 Jeff Schmitz. All rights reserved.

import UIKit
import AVFoundation

final class PlaySoundsViewController: UIViewController {
    
    // MARK: - PlaySoundsViewController fields
    var audioPlayer:AVAudioPlayer!
    var audioPlayerNode:AVAudioPlayerNode!
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
    
    // MARK: - UI Interface Builder handler functions
    @IBAction func stopPlayingAudio(sender: UIButton) {
        audioPlayerNode.stop()
        audioPlayer.stop()
        stopButton.enabled = false
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(AudioEffect.Slow)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(AudioEffect.Fast)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudio(AudioEffect.Chipmunk)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudio(AudioEffect.DarthVader)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playAudio(AudioEffect.Echo)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playAudio(AudioEffect.Reverb)
    }
    
    // MARK: - PlaySoundsViewController functions
    func playAudio(audioEffect: AudioEffect) {
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
            let changePitchEffect = AVAudioUnitTimePitch()
            changePitchEffect.pitch = audioEffect.rawValue
            playAudioWithEffect(changePitchEffect)
        case .Echo:
            let echoEffect = AVAudioUnitDelay()
            echoEffect.delayTime = Double(audioEffect.rawValue)
            playAudioWithEffect(echoEffect)
        case .Reverb:
            let reverbEffect = AVAudioUnitReverb()
            reverbEffect.wetDryMix = audioEffect.rawValue
            playAudioWithEffect(reverbEffect)
        }
        
        stopButton.enabled = true
    }
    
    func playAudioWithVariableRate(rate: Float) -> Void {
        audioPlayer.enableRate = true
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

    func playAudioWithEffect(effect: AVAudioNode) {
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effect)
        
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch {
            print(error)
        }
        
        audioPlayerNode.play()
    }
}

// Enum to encapsulate the effects utilized within the PlaySoundsViewController class.
// NOTE: I chose to keep this enum code inside the PlaySoundsViewController class as it is the only place used.
enum AudioEffect: Float {
    case Slow = 0.5
    case Fast = 1.5
    case Chipmunk = 1000
    case DarthVader = -1000
    case Echo = 0.54
    case Reverb = 70
}