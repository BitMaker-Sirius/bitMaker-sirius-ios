//
//  SoundListProvider.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

protocol SoundsListProvider {
    func loadData(completion: @escaping (Result<[Sound], DataStorageError>) -> Void)
    
    // Прописать методы, которые взаимодействуют с sound list
}
