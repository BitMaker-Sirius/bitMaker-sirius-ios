//
//  VisualizationProjectService.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import Foundation

protocol VisualizationProjectProvider {
    typealias BoolClosure = (_ isCompleted: Bool) -> Void
    
    func play(completion: @escaping BoolClosure)
    func stop(completion: @escaping BoolClosure)
    
    func exportProject(completion: @escaping (Data) -> Void)
}
