//
//  FileManagerProtocol.swift
//  BeatMaker
//
//  Created by Александр Бобрун on 27.03.2024.
//

import Foundation
import UIKit
import AVFoundation

protocol FileManagerProtocol {

    var imageCache:  [String: UIImage] { get set }
    
    func getUIImage(withID id: String, completion: @escaping (Result<UIImage, FileManagersErrors>) -> () )
    func saveUIImage(withID id: String, image: UIImage, completion: @escaping (Result<String?, FileManagersErrors>) -> () )
    
    func readAllImages(completion:  @escaping ([ImageDataStorageEntity]) -> () ) 
    func getAllVAudioFiles(completion: @escaping (Result<[String: AVAudioFile], FileManagersErrors>) -> () )
    func getAudioURl(withId id: String) -> URL 
    func getAvailableFirebaseSoundsList() -> [FirebaseAudioInfo: String]
    func fetchAudioFromURL(url: String, completion: @escaping (Result<Data, FileManagersErrors>) -> ())
    func getAVAudioFile(withID id: String, fromUrl url: URL, completion: @escaping (Result<AVAudioFile, FileManagersErrors>) -> ())
//    func saveAVAudioFile(withID id: String, audio: AVAudioFile, completion: @escaping (Result<String, FileManagersErrors>) -> () )
}
