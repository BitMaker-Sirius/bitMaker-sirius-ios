//
//  SoundListProvider.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

protocol SoundsListProvider {
    func loadData(completion: @escaping (Result<[Sound], DataStorageError>) -> Void)
    
    func add(sound: Sound, completion: @escaping (_ isCompleted: Bool) -> Void)
    
    func delete(by soundId: String, completion: @escaping (_ isCompleted: Bool) -> Void)
}
