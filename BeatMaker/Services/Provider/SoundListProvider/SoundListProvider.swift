//
//  SoundListProvider.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

protocol SoundListProvider {
    /// Это свойство меняет провайдер
    var soundList: [Sound] { get }
    
    // Прописать методы, которые взаимодействуют с sound list
}
