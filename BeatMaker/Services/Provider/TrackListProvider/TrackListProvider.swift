//
//  SoundListProvider.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

protocol TrackListProvider {
    /// Это свойство слушают  вью модели
    var trackList: State<[Track]> { get }
    
    // Прописать методы, которые взаимодействуют с track list
}
