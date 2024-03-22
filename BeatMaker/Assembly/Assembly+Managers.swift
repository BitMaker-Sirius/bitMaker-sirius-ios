//
//  Assembly+Managers.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

extension Assembly {
    func networkManager() -> NetworkManager {
        NetworkManagerImp()
    }
    
    func projectManager(_ project: Project?) -> ProjectManager {
        ProjectManagerImp(project: project, dataStorage: projectDataStorage())
    }
}
