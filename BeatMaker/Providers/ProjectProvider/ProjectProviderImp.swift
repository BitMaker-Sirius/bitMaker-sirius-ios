//
//  EditProjectProviderImp.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

final class ProjectProviderImp: ProjectProvider {
    // По необходимости подключать и другие стореджи
    let projectDataStorage: any ProjectDataStorage
    
    init(projectDataStorage: any ProjectDataStorage) {
        self.projectDataStorage = projectDataStorage
    }
    
    private var cachedProject: Project?
    
    func loadData(by id: String, completion: @escaping (Result<Project, DataStorageError>) -> Void) {
        projectDataStorage.get(by: id) { [weak self] result in
            if case let .success(project) = result {
                self?.cachedProject = project
            }
            
            completion(result)
        }
    }
    
    func saveData(project: Project, completion: @escaping (_ isCompleted: Bool) -> Void) {
        projectDataStorage.save(by: project.id, project) { id, isCompleted in
            completion(isCompleted)
        }
    }
    
    func create(project: Project, completion: @escaping (_ project: Project, _ isCompleted: Bool) -> Void) {
        // Пока замоканное сохранение
        projectDataStorage.save(by: nil, project) { id, isCompleted in
            guard let id else {
                completion(project, false)
                return
            }
            
            completion(.init(id: id, project: project), isCompleted)
        }
    }
}
