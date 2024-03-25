//
//  ProjectDataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

final class ProjectDataStorageImp: ProjectDataStorage {
    func get(by id: String, completion: @escaping (Result<Project, DataStorageError>) -> Void) {
        
    }
    
    func getAll(completion: @escaping (Result<[Project], DataStorageError>) -> Void) {
        
    }
    
    func save(by id: String?, _ data: Project, completion: @escaping (_ id: String?, _ isCompleted: Bool) -> Void) {
        
    }
    
    func delete(by id: String, completion: @escaping (_ isCompleted: Bool) -> Void) {
        
    }
}
