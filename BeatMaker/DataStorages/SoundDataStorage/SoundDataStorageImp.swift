//
//  SoundDataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation
import RealmSwift

final class SoundDataStorageImp: SoundDataStorage {
    private let realmManager: Realm?
    
    init(realmManager: Realm?) {
        self.realmManager = realmManager
    }
    
    func get(by id: String, completion: @escaping (Result<Sound, DataStorageError>) -> Void) {
        guard let realmManager else {
            completion(.failure(DataStorageError.storageUnavailable))
            return
        }
        
        guard 
            let soundObject = realmManager.object(ofType: SoundObject.self, forPrimaryKey: id),
            let sound = Sound(from: soundObject)
        else {
            completion(.failure(DataStorageError.dataNotExist))
            return
        }
        
        completion(.success(sound))
    }
    
    func getAll(completion: @escaping (Result<[Sound], DataStorageError>) -> Void) {
        guard let realmManager else {
            completion(.failure(DataStorageError.storageUnavailable))
            return
        }
        
        completion(
            .success(
                realmManager.objects(SoundObject.self)
                    .toArray()
                    .compactMap { Sound(from: $0) }
            )
        )
    }
    
    func save(by id: String?, _ data: Sound, completion: @escaping (_ id: String?, _ isCompleted: Bool) -> Void) {
        guard let realmManager else {
            completion(id, false)
            return
        }
        
        if let id = id {
            realmManager.writeAsync {
                guard let soundObject = SoundObject(from: .init(id: id, sound: data)) else {
                    completion(id, false)
                    return
                }
                        
                realmManager.add(
                    soundObject,
                    update: .all
                )
                
                completion(id, true)
            }
        } else {
            realmManager.writeAsync {
                guard let soundObject = SoundObject(from: data) else {
                    completion(id, false)
                    return
                }
                
                realmManager.add(
                    soundObject,
                    update: .all
                )
                
                completion(data.id, true)
            }
        }
    }
    
    func delete(by id: String, completion: @escaping (_ isCompleted: Bool) -> Void) {
        guard let realmManager else {
            completion(false)
            return
        }
        
        guard let soundObject = realmManager.object(ofType: SoundObject.self, forPrimaryKey: id) else {
            completion(false)
            return
        }
        
        do {
            try realmManager.write {
                realmManager.delete(soundObject)
            }
            
            completion(true)
        } catch {
            completion(false)
        }
    }
}
