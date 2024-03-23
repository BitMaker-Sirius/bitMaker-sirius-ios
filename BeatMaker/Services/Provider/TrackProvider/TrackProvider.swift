//
//  TrackProvider.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

protocol TrackProvider {
    /// Это свойство слушают  вью модели
    var track: StateObject<Track> { get }
    
    // Прописать методы, которые взаимодействуют с track
}
