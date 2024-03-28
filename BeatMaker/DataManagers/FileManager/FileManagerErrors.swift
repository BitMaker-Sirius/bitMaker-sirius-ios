//
//  FileManagerErrors.swift
//  BeatMaker
//
//  Created by Александр Бобрун on 27.03.2024.
//

import Foundation

enum FileManagersErrors: Error {
    
    case noDataInStorageError
    case dataFromNetworkError
    case dataConvertError
    case saveError
}
