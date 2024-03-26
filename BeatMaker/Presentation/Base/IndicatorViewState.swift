//
//  BaseViewState.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 25.03.2024.
//

import Foundation

enum IndicatorViewState {
    /// View готова к отображению
    case display
    /// View загружается
    case loading
    /// View обрабатывает ошибку
    case error
}
