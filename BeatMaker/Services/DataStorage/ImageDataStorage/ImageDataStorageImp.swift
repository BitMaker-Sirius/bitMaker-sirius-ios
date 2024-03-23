//
//  ImageDataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import SwiftUI

final class ImageDataStorageImp: ImageDataStorage {
    func get(by id: String, completion: @escaping (Result<Image, DataStorageError>) -> Void) {
        
    }
    
    func getAll(completion: @escaping (Result<[Image], DataStorageError>) -> Void) {
        
    }
    
    func save(by id: String?, _ data: Image, completion: @escaping (_ id: String?, _ isCompleted: Bool) -> Void) {
        
    }
    
    func delete(by id: String, completion: @escaping (_ isCompleted: Bool) -> Void) {
        
    }
}
