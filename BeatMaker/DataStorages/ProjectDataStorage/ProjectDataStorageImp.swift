//
//  ProjectDataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation
import RealmSwift

final class ProjectDataStorageImp: ProjectDataStorage {
    private let realmManager: Realm?
    
    init(realmManager: Realm?) {
        self.realmManager = realmManager
    }
    
    func get(by id: String, completion: @escaping (Result<Project, DataStorageError>) -> Void) {
        guard let realmManager else {
            completion(.failure(DataStorageError.storageUnavailable))
            return
        }
        
        guard let projectObject = realmManager.object(ofType: ProjectObject.self, forPrimaryKey: id) else {
            completion(.failure(DataStorageError.dataNotExist))
            return
        }
        
        completion(.success(Project(from: projectObject)))
    }
    
    func getAll(completion: @escaping (Result<[Project], DataStorageError>) -> Void) {
        guard let realmManager else {
            completion(.failure(DataStorageError.storageUnavailable))
            return
        }
        
        completion(
            .success(
                realmManager.objects(ProjectObject.self)
                    .toArray()
                    .map { Project(from: $0) }
            )
        )
    }
    
    func save(by id: String?, _ data: Project, completion: @escaping (_ id: String?, _ isCompleted: Bool) -> Void) {
        guard let realmManager else {
            completion(id, false)
            return
        }
        
        if let id = id {
            realmManager.writeAsync {
                realmManager.add(
                    ProjectObject(from: .init(id: id, project: data)),
                    update: .all
                )
                
                completion(id, true)
            }
        } else {
            realmManager.writeAsync {
                let projectObject = ProjectObject(from: data)
                
                realmManager.add(
                    projectObject,
                    update: .all
                )
                
                completion(projectObject.id, true)
            }
        }
    }
    
    func delete(by id: String, completion: @escaping (_ isCompleted: Bool) -> Void) {
        guard let realmManager else {
            completion(false)
            return
        }
        
        guard let projectObject = realmManager.object(ofType: ProjectObject.self, forPrimaryKey: id) else {
            completion(false)
            return
        }
        
        do {
            try realmManager.write {
                realmManager.delete(projectObject)
            }
            
            completion(true)
        } catch {
            completion(false)
        }
    }
}
