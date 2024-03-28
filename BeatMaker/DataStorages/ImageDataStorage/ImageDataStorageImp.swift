//
//  ImageDataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import UIKit

final class ImageDataStorageImp: ImageDataStorage {
    
    func get(by id: String, completion: @escaping (Result<ImageDataStorageEntity, DataStorageError>) -> Void) {
        
        let filePath = getFilePath(withId: id)
            
        do {
            let data = try Data(contentsOf: filePath)
            if let image = UIImage(data: data) {
                completion(.success(ImageDataStorageEntity(id: id, image: image)))
            } else {
                completion(.failure(DataStorageError.unknown))
            }
        } catch {
            completion(.failure(DataStorageError.dataNotExist))
        }
    }
    
    func getAll(completion: @escaping (Result<[ImageDataStorageEntity], DataStorageError>) -> Void) {
        
        let filePath = getPath()
        
        var allImagesArray: [ImageDataStorageEntity] = []
        
        do {
            let allImageDataUrls = try FileManager.default.contentsOfDirectory(at: filePath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for fileUrl in allImageDataUrls {
                let imageId = fileUrl.deletingPathExtension().lastPathComponent
                get(by: imageId) { result in
                    switch result {
                    case .success(let imageEntity):
                        allImagesArray.append(imageEntity)
                    case .failure(_):
                        print("IMAGEDATASTORAGE: can't get UIImage \(imageId) from file storage")
                    }
                }
            }
            completion(.success(allImagesArray))
        } catch {
            completion(.failure(DataStorageError.storageUnavailable))
        }
        
    }
    
    func save(by id: String?, _ data: ImageDataStorageEntity, completion: @escaping (_ id: String?, _ isCompleted: Bool) -> Void) {
        
        createPathIfDontExists()
        
        guard let imageData = data.image.pngData() else {
            print("IMAGEDATASTORAGE: can't decode UIImage to Data")
            completion(nil, false)
            return
        }
        
        let imageId = (id != nil) ? id : UUID().uuidString
        let filePath = getFilePath(withId: imageId!)
            
        do {
            try imageData.write(to: filePath)
        } catch {
            print("IMAGEDATASTORAGE: can't write UIImage \(String(describing: imageId)) to Files")
            completion(nil, false)
            return
        }
        
        completion(imageId, true)
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
        return documentsDirectory.appendingPathComponent("Images")
    }
    
    private func getFilePath(withId id: String) -> URL {
        getPath().appendingPathComponent("\(String(describing: id)).png")
    }
    
    private func createPathIfDontExists() {
        
        let path = getPath().path()
       
        guard FileManager.default.fileExists(atPath: path) else {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("IMAGEDATASTORAGE: can't create new directory for Images")
            }
            return
        }
    }
}
