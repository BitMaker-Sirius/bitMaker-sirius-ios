//
//  SoundPlaybackService.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import AVFoundation

final class SoundPlaybackServiceImp: SoundPlaybackService {
    private var audioEngine: AVAudioEngine
    private var playerNodes: [AVAudioPlayerNode]
    private var timePitchEffects: [AVAudioUnitTimePitch]
    
    init() {
        audioEngine = AVAudioEngine()
        playerNodes = []
        timePitchEffects = []
    }
    
    func playSound(url: URL, atTime time: TimeInterval, volume: Float, pitch: Float) {
        let player = AVAudioPlayerNode()
        let timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        player.volume = volume
        
        audioEngine.attach(player)
        audioEngine.attach(timePitch)
        
        audioEngine.connect(player, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.mainMixerNode, format: nil)
        
        do {
            let file = try AVAudioFile(forReading: url)
            let timeInSamples = AVAudioFramePosition(time * file.fileFormat.sampleRate)
            let audioFormat = file.processingFormat
            let audioFrameCount = AVAudioFrameCount(file.length)
            let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
            try file.read(into: buffer!)
            
            player.scheduleBuffer(buffer!, at: AVAudioTime(sampleTime: timeInSamples, atRate: Double(file.fileFormat.sampleRate)), options: [], completionHandler: nil)
            
            if !audioEngine.isRunning {
                try audioEngine.start()
            }
            
            player.play()
            
            playerNodes.append(player)
            timePitchEffects.append(timePitch)
        } catch {
            print("Error playing sound: \(error)")
        }
    }
    
    func stopAllSounds() {
        playerNodes.forEach { player in
            player.stop()
            audioEngine.detach(player)
        }
        timePitchEffects.forEach { effect in
            audioEngine.detach(effect)
        }
        playerNodes.removeAll()
        timePitchEffects.removeAll()
        audioEngine.stop()
        audioEngine.reset()
    }
}
