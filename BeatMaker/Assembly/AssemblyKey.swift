//
//  EnvironmentValuesExtension.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 24.03.2024.
//

import SwiftUI

struct AssemblyKey: EnvironmentKey {
    // Инициализируется сам при запуске приложения
    static var defaultValue: Assembly = Assembly()
}
