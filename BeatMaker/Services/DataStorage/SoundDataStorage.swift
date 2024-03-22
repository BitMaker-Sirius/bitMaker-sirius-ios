//
//  SoundDataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

final class SoundDataStorage: DataStorage {
    init(service: FileDataStorageService) {
        self.service = service
    }
    
    let service: FileDataStorageService
    
    func get(by id: UUID) -> Sound? {
        nil
    }
    
    func getAll() -> [Sound] {
        []
    }
    
    func add(_ data: Sound) {
        
    }
    
    func remove(by id: UUID) {
        
    }
    
    func update(_ data: Sound) {
        
    }
}
