//
//  ImageDataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import SwiftUI

final class ImageDataStorage: DataStorage {
    func get(by id: String, completion: @escaping (Result<Image, Error>) -> Void) {
        
    }
    
    func getAll(completion: @escaping (Result<[Image], ErrorType>) -> Void) {
        
    }
    
    func save(_ data: Image, completion: @escaping (_ id: String?) -> Void) {
        
    }
    
    func delete(by id: String, completion: @escaping (_ isCompleted: Bool) -> Void) {
        
    }
    
    func update(by id: String, with data: Image, completion: @escaping (_ isCompleted: Bool) -> Void) {
        
    }
}
