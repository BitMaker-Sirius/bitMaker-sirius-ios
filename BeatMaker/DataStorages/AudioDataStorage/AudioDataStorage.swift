//
//  AudioDataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import AVFoundation

protocol AudioDataStorage: DataStorage where DataType == AVAudioFile {}
