//
//  SoundListProviderImp.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

final class SoundsListProviderImp: SoundsListProvider {
    // По необходимости подключать и другие стореджи
    let soundDataStorage: any SoundDataStorage
    
    init(soundDataStorage: any SoundDataStorage) {
        self.soundDataStorage = soundDataStorage
    }
    
    private var cachedSoundList: [Sound] = []
    
    func loadData(completion: @escaping (Result<[Sound], DataStorageError>) -> Void) {
        soundDataStorage.getAll() { [weak self] result in
            if case let .success(soundList) = result {
                self?.cachedSoundList = soundList
            }
            
            completion(result)
        }
    }
    
    func delete(by soundId: String, completion: @escaping (_ isCompleted: Bool) -> Void) {
        soundDataStorage.delete(by: soundId) { isCompleted in
            completion(isCompleted)
        }
    }
    
    func add(sound: Sound, completion: @escaping (_ isCompleted: Bool) -> Void) {
        // Пока замоканное сохранение
        soundDataStorage.save(by: sound.id, sound) { id, isCompleted in
            completion(isCompleted)
        }
    }
    
    func save(soundsList: [Sound], competion: @escaping (_ isCompleted: Bool) -> Void) {
        soundsList.enumerated().forEach { index, sound in
            soundDataStorage.get(by: sound.id) { [weak self] result in
                guard let self else {
                    return
                }
                
                switch result {
                case .success(let storageSound):
                    soundDataStorage.save(by: sound.id, .init(id: sound.id, sound: sound)) { id, isCompleted in
                        if index == soundsList.count - 1 {
                            competion(true)
                        }
                    }
                case .failure(let storageSound):
                    soundDataStorage.save(by: nil, .init(id: sound.id, sound: sound)) { id, isCompleted in
                        if index == soundsList.count - 1 {
                            competion(true)
                        }
                    }
                }
            }
        }
    }
}
