//
//  ProjectListProvider.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import Foundation

protocol ProjectListProvider {
    typealias BoolClosure = ((_ isCompleted: Bool) -> Void)
    
    func getAllProjects(completion: @escaping (([Project]) -> Void))
    
    func play(completion: @escaping BoolClosure)
    func stop(completion: @escaping BoolClosure)
    
    func createNewProject(completion: @escaping ((_ id: String) -> Void))
    func editName(by id: String, with name: String, completion: @escaping BoolClosure)
    
    func deleteProject(by id: String, completion: @escaping BoolClosure)
}
