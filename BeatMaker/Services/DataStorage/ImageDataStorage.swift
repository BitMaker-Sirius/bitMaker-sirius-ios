//
//  ImageDataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import SwiftUI

final class ImageDataStorage: DataStorage {
    init(service: RealmDataStorageService) {
        self.service = service
    }
    
    let service: RealmDataStorageService
    
    func get(by id: UUID) -> Image? {
        nil
    }
    
    func getAll() -> [Image] {
        []
    }
    
    func add(_ data: Image) {
        
    }
    
    func remove(by id: UUID) {
        
    }
    
    func update(_ data: Image) {
        
    }
}
