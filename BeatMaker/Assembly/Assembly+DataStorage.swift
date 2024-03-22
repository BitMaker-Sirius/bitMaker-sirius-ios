//
//  Assembly+DataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

extension Assembly {
    func projectDataStorage() -> ProjectDataStorage {
        .init(service: realmDataStorageService())
    }
    
    func soundDataStorage() -> SoundDataStorage {
        .init(service: fileDataStorageService())
    }
    
    func imageDataStorage() -> ImageDataStorage {
        .init(service: realmDataStorageService())
    }
    
    private func fileDataStorageService() -> FileDataStorageService {
        .init()
    }
    
    private func realmDataStorageService() -> RealmDataStorageService {
        .init()
    }
}
