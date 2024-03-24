//
//  SoundListProviderImp.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

final class SoundListProviderImp: SoundListProvider {
    var soundList: [Sound]
    
    init(soundList: [Sound]) {
        self.soundList = soundList
    }
}
