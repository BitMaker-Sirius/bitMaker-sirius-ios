//
//  ProjectListProviderImp.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

final class ProjectsListProviderImp: ProjectsListProvider {
    // По необходимости подключать и другие стореджи
    let projectDataStorage: any ProjectDataStorage
    
    init(projectDataStorage: any ProjectDataStorage) {
        self.projectDataStorage = projectDataStorage
    }
    
    private var cachedProjectList: [Project] = []
    
    func loadData(completion: @escaping (Result<[Project], DataStorageError>) -> Void) {
        projectDataStorage.getAll() { [weak self] result in
            if case let .success(projectList) = result {
                self?.cachedProjectList = projectList
            }
            
            completion(result)
        }
    }
}
