//
//  AudioDataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import AVFoundation

final class AudioDataStorageImp: AudioDataStorage {
    
    func get(by id: String, completion: @escaping (Result<AudioDataStorageEntity, DataStorageError>) -> Void) {
        
        let filePath = getFilePath(withId: id)
            
        do {
            let _ = try Data(contentsOf: filePath)
            completion(.success(AudioDataStorageEntity(id: id, soundUrl: filePath)))
        } catch {
            completion(.failure(DataStorageError.dataNotExist))
        }
    }
    
    func getAll(completion: @escaping (Result<[AudioDataStorageEntity], DataStorageError>) -> Void) {
        
        let filePath = getPath()
        
        var allSoundsDataArray: [AudioDataStorageEntity] = []
        
        do {
            let allSoundDataUrls = try FileManager.default.contentsOfDirectory(at: filePath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for fileUrl in allSoundDataUrls {
                let soundId = fileUrl.deletingPathExtension().lastPathComponent
                get(by: soundId) { result in
                    switch result {
                    case .success(let soundEntity):
                        allSoundsDataArray.append(soundEntity)
                    case .failure(_):
                        print("AUDIODATASTORAGE: can't get UIImage \(soundId) from file storage")
                    }
                }
            }
            completion(.success(allSoundsDataArray))
        } catch {
            completion(.failure(DataStorageError.storageUnavailable))
        }
        
    }
    
    func save(by id: String?, _ data: AudioDataStorageEntity, completion: @escaping (_ id: String?, _ isCompleted: Bool) -> Void) {
        
        createPathIfDontExists()
        
        let soundId = (id != nil) ? id : UUID().uuidString
        let filePath = getFilePath(withId: soundId!)
            
        do {
            try Data(contentsOf: data.soundUrl).write(to: filePath)
        } catch {
            print("AUDIODATASTORAGE: can't write UIImage \(String(describing: soundId)) to Files")
            completion(nil, false)
            return
        }
        
        completion(soundId, true)
        
    }
    
    func delete(by id: String, completion: @escaping (_ isCompleted: Bool) -> Void) {
        
        let filePath = getFilePath(withId: id)
            
        do {
            try FileManager.default.removeItem(at: filePath)
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    private func getPath() -> URL {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent("Sounds")
    }
    
    private func getFilePath(withId id: String) -> URL {
        getPath().appendingPathComponent("\(String(describing: id)).mp3")
    }
    
    private func createPathIfDontExists() {
        
        let path = getPath().path()
       
        guard FileManager.default.fileExists(atPath: path) else {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("AUDIODATASTORAGE: can't create new directory for Sounds")
            }
            return
        }
    }
}
