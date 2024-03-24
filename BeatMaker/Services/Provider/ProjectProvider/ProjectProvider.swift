//
//  ProjectProvider.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

protocol ProjectProvider {
    /// Это свойство меняет провайдер
    var project: Project { get }
    
    // Прописать методы, которые взаимодействуют с project
}
