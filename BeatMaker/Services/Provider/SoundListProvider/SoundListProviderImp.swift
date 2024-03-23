//
//  SoundListProviderImp.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

final class SoundListProviderImp: SoundListProvider {
    var soundList: State<[Sound]>
    
    init(soundList: [Sound]) {
        self.soundList = State(wrappedValue: soundList)
    }
}
