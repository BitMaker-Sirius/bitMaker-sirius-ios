//
//  ProjectListProviderImp.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

final class ProjectListProviderImp: ProjectListProvider {
    var projectList: State<[Project]>
    
    init(projectList: [Project]) {
        self.projectList = State(wrappedValue: projectList)
    }
}
