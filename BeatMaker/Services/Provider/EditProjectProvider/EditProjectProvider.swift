//
//  ProjectProvider.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import Foundation

protocol EditProjectProvider {
    typealias BoolClosure = (_ isCompleted: Bool) -> Void
    
    func play(completion: @escaping BoolClosure)
    func stop(completion: @escaping BoolClosure)
    
    func addPreparedSound(by id: String, completion: @escaping BoolClosure)
    func deletePreparedSound(by id: String, completion: @escaping BoolClosure)
    
    func deleteTrack(by id: String, completion: @escaping BoolClosure)
    func toggleMuteTrack(by id: String, completion: @escaping BoolClosure)
    
    func startSampling(completion: @escaping BoolClosure)
    func startRecording(completion: @escaping BoolClosure)
    
    func saveProject(completion: @escaping BoolClosure)
    func deleteProject(completion: @escaping BoolClosure)
}
