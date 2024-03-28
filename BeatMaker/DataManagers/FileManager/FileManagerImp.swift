//
//  FileManagerImp.swift
//  BeatMaker
//
//  Created by Александр Бобрун on 27.03.2024.
//

import Foundation
import UIKit
import AVFoundation

struct FirebaseAudioInfo: Hashable {
    let name: String
    let emoji: String
}

final class FileManagerImp: FileManagerProtocol {
    
    var imageCache: [String: UIImage] = [:]
    var audioCache: [String: AVAudioFile] = [:]
    
    private let networkService: NetworkManager
    private let audioDataStorage: any AudioDataStorage
    private let imageDataStorage: any ImageDataStorage
    
    private let bundleSounds: [String] = [
        "iphone-sms",
        "s6-edge-sms",
    ]
    
    private let firebaseSoundsStringURLs: [FirebaseAudioInfo: String] = [
        FirebaseAudioInfo(name: "bell", emoji: "\u{1f6ce}"): "https://firebasestorage.googleapis.com/v0/b/sirius-bitbeat.appspot.com/o/bell.mp3?alt=media&token=8ab5f9d0-7d7e-4d14-b1a5-313b70ecaf55",
        FirebaseAudioInfo(name: "kick", emoji: "\u{1f94a}"): "https://firebasestorage.googleapis.com/v0/b/sirius-bitbeat.appspot.com/o/kick.mp3?alt=media&token=6a420876-bf5b-48e4-99eb-59e2fde5635c",
        FirebaseAudioInfo(name: "pulse", emoji: "\u{1f916}"): "https://firebasestorage.googleapis.com/v0/b/sirius-bitbeat.appspot.com/o/pulse.mp3?alt=media&token=824237fd-264b-4af7-b459-beada300de10",
        FirebaseAudioInfo(name: "duck quack", emoji: "\u{1f986}"): "https://firebasestorage.googleapis.com/v0/b/sirius-bitbeat.appspot.com/o/quack.mp3?alt=media&token=f90b1583-fbe9-48ee-a16b-b6821dce9e5b",
        FirebaseAudioInfo(name: "snap", emoji: "\u{1fa87}"): "https://firebasestorage.googleapis.com/v0/b/sirius-bitbeat.appspot.com/o/snap.mp3?alt=media&token=61cd6ca6-4464-43ac-9572-159ca14319ba",
        FirebaseAudioInfo(name: "snare", emoji: "\u{1f941}"): "https://firebasestorage.googleapis.com/v0/b/sirius-bitbeat.appspot.com/o/snare.mp3?alt=media&token=ff4ceafc-25a9-45f1-b6f6-fb00f6c809a5"
    ]
    
    init(networkService: NetworkManager, audioDataStorage: any AudioDataStorage, imageDataStorage: any ImageDataStorage) {
        
        self.networkService = networkService
        self.audioDataStorage = audioDataStorage
        self.imageDataStorage = imageDataStorage
    }
    
    func getAudioURl(withId id: String) -> URL {
        
        if bundleSounds.contains(id) {
            return Bundle.main.url(forResource: id, withExtension: "mp3")!
        } else {
            return audioDataStorage.getFilePath(withId: id)
        }
    }
    
    func saveUIImage(withID id: String, image: UIImage, completion: @escaping (Result<String?, FileManagersErrors>) -> () ) {
        
        imageDataStorage.save(by: id, ImageDataStorageEntity(id: id, image: image)) { newId, isCompleted in
            guard isCompleted, let newId = newId else {
                completion(.failure(FileManagersErrors.saveError))
                return
            }
            completion(.success(newId))
            self.imageCache[newId] = image //bad
        }
    }
    
    func getUIImage(withID id: String, completion: @escaping (Result<UIImage, FileManagersErrors>) -> ()) {
        
        if let image = imageCache[id] {
            completion(.success(image))
            print("was taken from cach")
            return

        } else {
            
            readUIImage(withID: id) { [weak self] readResult in
                switch readResult {
                case .success(let readImage):
                    self?.imageCache[id] = readImage
                    completion(.success(readImage))
                    return
                    
                case .failure(let readError):
                    print("\(readError): no data in storage")
                }
            }
            
            fetchRandomUIImage(withID: id) { fetchResult in
                switch fetchResult {
                case .success(let fetchImage):
                    completion(.success(fetchImage))
                    print("image was fetched")
                    self.saveUIImage(withID: id, image: fetchImage) { saveResult in //bad
                        print("image was saved ")
                        switch saveResult {
                        case .success(let newId):
                            print("image was saved with \(String(describing: newId))")
                        case .failure(let saveError):
                            print("\(saveError): save error")
                        }
                    }
                    
                case .failure(let fetchError):
                    completion(.failure(fetchError))
                }
            }
        }
    }
 
    // TODO: -
    func saveAVAudioFile(withID id: String, audio: AVAudioFile, completion: @escaping (Result<String?, FileManagersErrors>) -> () ) {
//        audioDataStorage.save(by: id, audio: AudioDataStorageEntity(id: id, soundUrl: <#T##URL#>)) { newId, isCompleted in
//            guard isCompleted, let newId = newId else {
//                completion(.failure(FileManagersErrors.saveError))
//                return
//            }
//            completion(.success(newId))
//            self.audioCache[newId] = audio //bad
//        }
    }
    
    func getAVAudioFile(withID id: String, fromUrl url: URL, completion: @escaping (Result<AVAudioFile, FileManagersErrors>) -> ()) {
        
        if let audio = audioCache[id] {
            completion(.success(audio))
            print("was taken from cach")
            return

        } else {
            
            readAVAudioFile(withID: id) {readResult in
                switch readResult {
                case .success(let readImage):
                    completion(.success(readImage))
                    return
                    
                case .failure(let readError):
                    print("\(readError): no data in storage")
                }
            }
            
            fetchAudioFromURL(url: url.absoluteString) { fetchResult in
                switch fetchResult {
                case .success(let fetchAudioData):
                    
                    self.saveAVAudioFileFromData(withId: id, data: fetchAudioData) { saveResult in // bad
                        switch saveResult {
                        case .success(let newId):
                            print("sound was saved with \(newId)")
                        case .failure(let saveError):
                            print("\(saveError): save error")
                        }
                    }
                    
                    self.readAVAudioFile(withID: id) {readResult in // bad
                        switch readResult {
                        case .success(let readImage):
                            completion(.success(readImage))
                            return
                            
                        case .failure(let readError):
                            print("\(readError): no data in storage")
                        }
                    }
                    
                case .failure(let fetchError):
                    completion(.failure(fetchError))
                }
            }
        }
    }
    
    func getAllVAudioFiles(completion: @escaping (Result<[String: AVAudioFile], FileManagersErrors>) -> ()) {
        
        if audioCache.isEmpty { // other logic of checking
            fetchAllSoundsToStorage { result in
                completion(result)
            }
        }
    }

    private func fetchRandomUIImage(withID id: String, completion: @escaping (Result<UIImage, FileManagersErrors>) -> ()) {
        
        networkService.fetchRandomImageFromApi { networkResult in
            switch networkResult {
            case .success(let data):
                if let image =  UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(FileManagersErrors.dataConvertError))
                }
                
            case .failure(_):
                completion(.failure(FileManagersErrors.dataFromNetworkError))
            }
        }
    }
    
    private func readUIImage(withID id: String, completion: @escaping (Result<UIImage, FileManagersErrors>) -> () ) {
        
        imageDataStorage.get(by: id) { storageGetResult in
            switch storageGetResult {
            case .success(let imageEntity):
                completion(.success(imageEntity.image))
                self.imageCache[id] = imageEntity.image //bad
                
            case .failure(_):
                completion(.failure(FileManagersErrors.noDataInStorageError))
            }
        }
    }
    
    func fetchAudioFromURL(url: String, completion: @escaping (Result<Data, FileManagersErrors>) -> ()) {
        
        networkService.fetchData(fromStringURL: url) { networkResult in
            switch networkResult {
            case .success(let data):
                completion(.success(data))
            case .failure(_):
                completion(.failure(FileManagersErrors.dataFromNetworkError))
            }
        }
    }
    
    private func readAVAudioFile(withID id: String, completion: @escaping (Result<AVAudioFile, FileManagersErrors>) -> () ) {
        
        audioDataStorage.get(by: id) { storageGetResult in
            switch storageGetResult {
            case .success(let audioEntity):
                do {
                    let audio = try AVAudioFile(forReading: audioEntity.soundUrl)
                    completion(.success(audio))
                    self.audioCache[id] = audio //bad
                } catch {
                    completion(.failure(FileManagersErrors.dataConvertError))
                }
            case .failure(_):
                completion(.failure(FileManagersErrors.noDataInStorageError))
            }
        }
    }
    
    func fetchSoundToStorage(withUrl: String, completion: @escaping (Result<[URL], FileManagersErrors>) -> ()) {
        
        
    }
    
    func getAvailableFirebaseSoundsList() -> [FirebaseAudioInfo: String] {
        return firebaseSoundsStringURLs
    }
    
    func fetchAllSoundsToStorage(completion: @escaping (Result<[String: AVAudioFile], FileManagersErrors>) -> ()) {
        
        for key in firebaseSoundsStringURLs.keys {
            if let stringURL = firebaseSoundsStringURLs[key] {
                fetchAudioFromURL(url: stringURL) { result in
                    switch result {
                    case .success(let data):
                        let soundId = UUID().uuidString
                        self.saveAVAudioFileFromData(withId: soundId, data: data) { saveResult in
                            switch saveResult{
                            case .success(_):
                                print("saved")
                            case .failure(let error):
                                print("\(error): cant save mp3 from url \(stringURL)")
                            }
                        }
                        self.readAVAudioFile(withID: soundId) { readResult in
                            switch readResult{
                            case .success(let audio):
                                self.audioCache[soundId] = audio
                            case .failure(let error):
                                print("\(error): cant get mp3 from url \(stringURL)")
                            }
                        }
                    case .failure(let error):
                        print("\(error): cant fetch from url \(stringURL)")
                    }
                }
            }
        }
        completion(.success(audioCache))
    }
    
    private func saveAVAudioFileFromData(withId id: String, data: Data, completion: @escaping (Result<URL, FileManagersErrors>) -> ()) {
        
        audioDataStorage.save(by: id, data) { newId, isCompleted in
            if isCompleted {
                print("audio with id: \(id) was succesfully saved in file storage with id \(String(describing: newId))")
            } else {
                print("audio with id: \(id) wasn't saved in file storage")
            }
        }
    }
    
    func getAVAudioFile(withID id: String, completion: @escaping (Result<AVAudioFile, FileManagersErrors>) -> ()) {

        if let audio = audioCache[id] {
            completion(.success(audio))
            return
            
        } else {
            readAVAudioFile(withID: id) { readResult in
                switch readResult {
                case .success(let readAudio):
                    completion(.success(readAudio))
                    return

                case .failure(let readError):
                    print("\(readError): no data in storage")
                    completion(.failure(.noDataInStorageError))
                }
            }
        }
    }
}
