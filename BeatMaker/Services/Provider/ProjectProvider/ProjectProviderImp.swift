//
//  EditProjectProviderImp.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

final class ProjectProviderImp: ProjectProvider {
    var project: StateObject<Project>
    
    init(project: Project) {
        self.project = StateObject(wrappedValue: project)
    }
}
