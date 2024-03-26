//
//  SoundSettingsGraphViewModel.swift
//  BeatMaker
//
//  Created by Ирина Печик on 25.03.2024.
//

import Foundation
import AVFoundation

protocol SoundSettingsGraphProviderObserver: AnyObject {
    func handle(pointCoordinatesDidChanged coordinate: CGPoint)
}

class SoundSettingsGraphViewModel: SoundSettingsGraphViewModeling {
    let graphWidth: CGFloat = 330
    let graphHeight: CGFloat = 330
    
    @Published
    var state = SoundSettingsGraphViewState(
        selectedPoint: CGPoint(x: 0, y: 10),
        pitch: 0,
        volume: 10
    )
    
    var audioPlayer: AVAudioPlayer?
    var sengine: AVAudioEngine?
    
    init() {
        self.state = state
    }
    
    func changeParams(currentPoint: CGPoint) {
        state.pitch = min(max(mapXToValue(currentPoint.x), -2400), 2400)
        state.volume = min(max(mapYToValue(currentPoint.y), 0), 20)
        state.selectedPoint = CGPoint(x: state.pitch, y: state.volume)
        if let sound = Bundle.main.path(forResource: "piano2", ofType: "mp3") {
          do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
          } catch {
            print("AVAudioPlayer could not be instantiated.")
          }
        } else {
          print("Audio file could not be found.")
        }
    }
    
    func mapValueToX() -> CGFloat {
        return (state.selectedPoint.x + 2400) / 4800 * graphWidth
    }
    
    func mapValueToY() -> CGFloat {
        return graphHeight - (state.selectedPoint.y / 20 * graphHeight)
    }
    
    func mapXToValue(_ x: CGFloat) -> CGFloat {
        return x / graphWidth * 4800 - 2400
    }
    
    func mapYToValue(_ y: CGFloat) -> CGFloat {
        return (graphHeight - y) / graphHeight * 19 + 1
    }
    
    func playAudio() { // volume до 1
        do {
            //
            var pitchEffectValue1 = (state.pitch + 2401) / 2400
            var volumeEffectValue1 = state.volume /*/ 20*/
            guard let player = audioPlayer else { return }
            player.volume = Float(volumeEffectValue1)
            player.rate = 0.1/*Float(state.pitch )*/
            player.play()
        }
    }
    
}

extension SoundSettingsGraphViewModel: SoundSettingsGraphProviderObserver {
    func handle(pointCoordinatesDidChanged coordinate: CGPoint) {
        state.selectedPoint = coordinate
    }
}
