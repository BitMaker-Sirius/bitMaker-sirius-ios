//
//  Assembly+EnvironmentValuesExtension.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 24.03.2024.
//

import SwiftUI

extension EnvironmentValues {
  var assembly: Assembly {
    get { self[AssemblyKey.self] }
    set { self[AssemblyKey.self] = newValue }
  }
}
