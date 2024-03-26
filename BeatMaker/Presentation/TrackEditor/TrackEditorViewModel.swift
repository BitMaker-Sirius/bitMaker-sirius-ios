//
//  TrackEditorViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation
import SwiftUI
import AVFoundation


final class TrackEditorViewModel: TrackEditorViewModeling {
    
    @Published
    var state = TrackEditorViewState(
        shouldShowPause: false,
        pauseState: "play.fill",
        isChervonDown: false,
        chervonDirection: "chevron.down",
        choosenSoundId: nil,
        soundsArray: [
            Sound(id: "0", audioFileId: nil, name: "baraban", emoji: "\u{1f600}"),
            Sound(id: "1", audioFileId: nil, name: "baraban1", emoji: "\u{1f601}"),
            Sound(id: "2", audioFileId: nil, name: "baraban2", emoji: "\u{1f602}"),
            Sound(id: "3", audioFileId: nil, name: "baraban3", emoji: "\u{1f603}"),
            Sound(id: "4", audioFileId: nil, name: "baraban4", emoji: "\u{1f614}"),
            Sound(id: "5", audioFileId: nil, name: "baraban5", emoji: "\u{1f605}"),
            Sound(id: "6", audioFileId: nil, name: "baraban6", emoji: "\u{1f606}")
        ]
    )
    
    func handle(_ event: PlayTrackViewEvent) {
        switch event {
        case .tapButton:
            state.shouldShowPause.toggle()
            state.pauseState = (state.shouldShowPause ? "pause.fill": "play.fill")
        case .tapChervon:
            state.isChervonDown.toggle()
            state.chervonDirection = (state.isChervonDown ? "chevron.up" : "chevron.down")
        }
    }
    
    func setSelectedSound(at id: String) {
        state.choosenSoundId = id
    }
    
    func areUuidsSimilar(id1: String, id2: String) -> Bool {
        return id1 == id2
    }
    
    var audioPlayer: AVAudioPlayer?

      @Published var isPlaying = false

      init() {
          self.state = state
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

      func playOrPause() {
        guard let player = audioPlayer else { return }

        if player.isPlaying {
            print("pause")
          player.pause()
          isPlaying = false
        } else {
            print("playy")
          player.play()
          isPlaying = true
        }
      }
    
//    init() {
//        self.state = state
//    }
    
    @Published var selectedSounds: [Sound] = []
    
    func addOrRemoveSound(_ sound: Sound) {
        if let index = selectedSounds.firstIndex(where: { $0.name == sound.name }) {
            selectedSounds.remove(at: index)
        } else {
            selectedSounds.append(sound)
        }
    }
    
    func isSoundSelected(_ sound: Sound) -> Bool {
        return selectedSounds.contains(where: { $0.name == sound.name })
    }
}
