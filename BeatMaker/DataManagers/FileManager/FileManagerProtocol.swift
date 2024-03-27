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

    func getUIImage(withID id: String, completion: @escaping (Result<UIImage, FileManagersErrors>) -> () )
    func saveUIImage(withID id: String, image: UIImage, completion: @escaping (Result<String?, FileManagersErrors>) -> () )
    
    func getAllVAudioFiles(completion: @escaping (Result<[String: AVAudioFile], FileManagersErrors>) -> () )
//    func saveAVAudioFile(withID id: String, audio: AVAudioFile, completion: @escaping (Result<String, FileManagersErrors>) -> () )
}
