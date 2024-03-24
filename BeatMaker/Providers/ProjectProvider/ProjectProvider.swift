//
//  ProjectProvider.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

protocol ProjectProvider {
    func loadData(by id: String, completion: @escaping (Result<Project, DataStorageError>) -> Void)
    
    // Прописать методы, которые взаимодействуют с project
}
