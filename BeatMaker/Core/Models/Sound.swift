//
//  Sound.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import AVFoundation

struct Sound: Identifiable {
    let id = UUID()
    let audioFile: AVAudioFile
    let name: String
    let emoji: String
}
