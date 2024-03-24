//
//  ProjectListProvider.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

protocol ProjectListProvider {
    /// Это свойство меняет провайдер
    var projectList: [Project] { get }
    
    // Прописать методы, которые взаимодействуют с project list
}
