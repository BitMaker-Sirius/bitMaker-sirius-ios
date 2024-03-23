//
//  SoundListProvider.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

protocol SoundListProvider {
    /// Это свойство слушают  вью модели
    var soundList: State<[Sound]> { get }
    
    // Прописать методы, которые взаимодействуют с sound list
}
