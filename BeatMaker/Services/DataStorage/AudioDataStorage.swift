//
//  AudioDataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import AVFoundation

final class AudioDataStorage: DataStorage {
    func get(by id: String, completion: @escaping (Result<AVAudioFile, Error>) -> Void) {
        
    }
    
    func getAll(completion: @escaping (Result<[AVAudioFile], Error>) -> Void) {
        
    }
    
    func save(_ data: AVAudioFile, completion: @escaping (_ id: String?) -> Void) {
        
    }
    
    func delete(by id: String, completion: @escaping (_ isCompleted: Bool) -> Void) {
        
    }
    
    func update(by id: String, with data: AVAudioFile, completion: @escaping (_ isCompleted: Bool) -> Void) {
        
    }
}
