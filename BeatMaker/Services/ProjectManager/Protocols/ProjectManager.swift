//
//  SamplingService.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import AVFoundation

protocol ProjectManager {
    func addTrack(_ track: Track)
    func removeTrack(by: UUID)
    
    func export(completion: @escaping (() -> Data))
}
