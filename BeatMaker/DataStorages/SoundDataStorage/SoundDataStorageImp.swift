//
//  SoundDataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

final class SoundDataStorageImp: SoundDataStorage {
    func get(by id: String, completion: @escaping (Result<Sound, DataStorageError>) -> Void) {
        
    }
    
    func getAll(completion: @escaping (Result<[Sound], DataStorageError>) -> Void) {
        
    }
    
    func save(by id: String?, _ data: Sound, completion: @escaping (_ id: String?, _ isCompleted: Bool) -> Void) {
        
    }
    
    func delete(by id: String, completion: @escaping (_ isCompleted: Bool) -> Void) {
        
    }
}
