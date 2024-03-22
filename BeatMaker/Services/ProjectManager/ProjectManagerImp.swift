//
//  ProjectManagerImp.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

final class ProjectManagerImp: ProjectManager {
    init(project: Project?, dataStorage: ProjectDataStorage) {
        self.project = project
        self.dataStorage = dataStorage
    }
    
    let project: Project?
    let dataStorage: ProjectDataStorage
    
    func addTrack(_ track: Track) {
        
    }
    
    func removeTrack(by: UUID) {
        
    }
    
    func export(completion: @escaping (() -> Data)) {
        
    }
}
