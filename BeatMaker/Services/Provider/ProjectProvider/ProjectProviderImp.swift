//
//  EditProjectProviderImp.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

final class ProjectProviderImp: ProjectProvider {
    var project: Project
    
    init(project: Project) {
        self.project = project
    }
}
