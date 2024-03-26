//
//  AudioDataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import AVFoundation

final class AudioDataStorageImp: AudioDataStorage {
    func get(by id: String, completion: @escaping (Result<AVAudioFile, DataStorageError>) -> Void) {
        
    }
    
    func getAll(completion: @escaping (Result<[AVAudioFile], DataStorageError>) -> Void) {
        
    }
    
    func save(by id: String?, _ data: AVAudioFile, completion: @escaping (_ id: String?, _ isCompleted: Bool) -> Void) {
        
    }
    
    func delete(by id: String, completion: @escaping (_ isCompleted: Bool) -> Void) {
        
    }
}
