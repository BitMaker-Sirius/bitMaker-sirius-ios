//
//  TrackProvider.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

protocol TrackProvider {
    /// Это свойство меняет провайдер
    var track: Track { get }
    
    // Прописать методы, которые взаимодействуют с track
}
