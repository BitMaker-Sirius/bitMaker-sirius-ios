//
//  SoundDataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

final class SoundDataStorage: DataStorage {
    func get(by id: String, completion: @escaping (Result<Sound, Error>) -> Void) {
        
    }
    
    func getAll(completion: @escaping (Result<[Sound], Error>) -> Void) {
        
    }
    
    func save(_ data: Sound, completion: @escaping (_ id: String?) -> Void) {
        
    }
    
    func delete(by id: String, completion: @escaping (_ isCompleted: Bool) -> Void) {
        
    }
    
    func update(by id: String, with data: Sound, completion: @escaping (_ isCompleted: Bool) -> Void) {
        
    }
}
