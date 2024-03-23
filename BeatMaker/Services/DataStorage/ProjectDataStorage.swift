//
//  ProjectDataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

final class ProjectDataStorage: DataStorage {
    func get(by id: String, completion: @escaping ((Result<Project, Error>) -> Void)) {
        
    }
    
    func getAll(completion: @escaping ((Result<[Project], Error>) -> Void)) {
        
    }
    
    func save(_ data: Project, completion: @escaping ((_ id: String?) -> Void)) {
        
    }
    
    func delete(by id: String, completion: @escaping ((_ isCompleted: Bool) -> Void)) {
        
    }
    
    func update(by id: String, with data: Project, completion: @escaping ((_ isCompleted: Bool) -> Void)) {
        
    }
}
