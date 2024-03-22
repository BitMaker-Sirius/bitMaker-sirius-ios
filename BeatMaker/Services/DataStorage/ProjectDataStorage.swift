//
//  ProjectDataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

final class ProjectDataStorage: DataStorage {
    init(service: RealmDataStorageService) {
        self.service = service
    }
    
    let service: RealmDataStorageService
    
    func get(by id: UUID) -> Project? {
        nil
    }
    
    func getAll() -> [Project] {
        []
    }
    
    func add(_ data: Project) {
        
    }
    
    func remove(by id: UUID) {
        
    }
    
    func update(_ data: Project) {
        
    }
}
