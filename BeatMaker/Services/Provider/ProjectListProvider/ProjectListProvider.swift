//
//  ProjectListProvider.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

protocol ProjectListProvider {
    /// Это свойство слушают  вью модели
    var projectList: State<[Project]> { get }
    
    // Прописать методы, которые взаимодействуют с project list
}
