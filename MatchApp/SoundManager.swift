//
//  SoundManager.swift
//  MatchApp
//
//  Created by Taijaun Pitt on 04/03/2023.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer: AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(effect: SoundEffect) {
        
        var soundFilename = ""
        
        switch effect {
            
            case .flip:
                soundFilename = "cardflip"
            case .match:
                soundFilename = "dingcorrect"
            case .nomatch:
                soundFilename = "dingwrong"
            case .shuffle:
                soundFilename = "shuffle"
            
        }
        // Get the path to the resource
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: ".wav")
        
        // check that its not nil
        // if (condition) bundlepath != nil continue, else return
        guard bundlePath != nil else {
            return
        }
        
        let url = URL(filePath: bundlePath!)
        
        // throws error so must do try/catch/do
        do {
            // Create the audio player
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            //play the sound effect
            audioPlayer?.play()
        }
        catch {
            print("Couldn't create an audio player")
            return
        }
        
        
        
    }
    
    
}
