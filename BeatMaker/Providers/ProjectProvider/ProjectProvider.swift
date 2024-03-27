//
//  ProjectProvider.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

protocol ProjectProvider {
    func loadData(by id: String, completion: @escaping (Result<Project, DataStorageError>) -> Void)
    func saveData(project: Project, completion: @escaping (_ isCompleted: Bool) -> Void)
    
    func create(project: Project, completion: @escaping (_ project: Project, _ isCompleted: Bool) -> Void)
}
