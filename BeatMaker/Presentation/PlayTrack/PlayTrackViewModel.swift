//
//  PlayTrackViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation

class PlayTrackViewModel: ObservableObject {
    let track: Track
    
    @Published var liked = false
    @Published var currentTime: Double = 0
    @Published var isPlaying = false {
        didSet {
            if isPlaying {
                startPlayback()
            } else {
                stopPlayback()
            }
        }
    }
    
    var totalDuration: Double = 100
    private var timer: Timer?
    
    init(track: Track) {
        self.track = track
    }
    
    func startPlayback() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] _ in
            guard let self = self, self.isPlaying else { return }
            DispatchQueue.main.async {
                let nextSliderValue = self.currentTime + 1
                if nextSliderValue <= self.totalDuration {
                    self.currentTime = nextSliderValue
                } else {
                    self.currentTime = 0
                    self.isPlaying = false
                }
            }
        }
    }
    
    func stopPlayback() {
        timer?.invalidate()
        timer = nil
    }
    
    func formatTime() -> String {
        let totalSeconds = Int(currentTime)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
