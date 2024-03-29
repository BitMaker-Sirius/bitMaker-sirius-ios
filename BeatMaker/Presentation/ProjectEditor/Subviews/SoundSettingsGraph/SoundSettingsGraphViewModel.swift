//
//  SoundSettingsGraphViewModel.swift
//  BeatMaker
//
//  Created by Ирина Печик on 25.03.2024.
//

import SwiftUI

protocol SoundSettingsGraphProviderObserver: AnyObject {
    func handle(pointCoordinatesDidChanged coordinate: CGPoint)
}

class SoundSettingsGraphViewModel: SoundSettingsGraphViewModeling {
    @Published
    var state = SoundSettingsGraphViewState(
        selectedPoint: CGPoint(x: 0, y: 10),
        pitch: 0,
        volume: 10
    )
    
    @Published
    var viewState = SoundSettingsViewParamsState (
        graphHeight: CGFloat(330),
        graphWidth: CGFloat(330)
    )
        
    private let pitchValue: CGFloat = 2400
    private let minVolumeValue: CGFloat = 0
    private let maxVolumeValue: CGFloat = 1
    
    weak var delegate: (any ProjectEditorViewModel)?
    var handle: (CGPoint) -> Void
    init(handle: @escaping (CGPoint) -> Void) {
        self.handle = handle
        self.state = state
        self.viewState = viewState
    }
    
    func changeParams(currentPoint: CGPoint) {
        state.pitch = min(max(mapXToValue(currentPoint.x), -pitchValue), pitchValue)
        state.volume = min(max(mapYToValue(currentPoint.y), minVolumeValue), maxVolumeValue)
        state.selectedPoint = CGPoint(x: state.pitch, y: state.volume)
        handle(state.selectedPoint)
    }
    
    func mapValueToX() -> CGFloat {
        return (state.selectedPoint.x + pitchValue) / (2 * pitchValue) * viewState.graphWidth
    }
    
    func mapValueToY() -> CGFloat {
        return viewState.graphHeight - (state.selectedPoint.y / maxVolumeValue * viewState.graphHeight)
    }
    
    func mapXToValue(_ x: CGFloat) -> CGFloat {
        return x / viewState.graphWidth * (2 * pitchValue) - pitchValue
    }
    
    func mapYToValue(_ y: CGFloat) -> CGFloat {
        return (viewState.graphHeight - y) / viewState.graphHeight * maxVolumeValue
    }
    
    func makeVibration() {
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        impactMed.impactOccurred()
    }
    
}

extension SoundSettingsGraphViewModel: SoundSettingsGraphProviderObserver {
    func handle(pointCoordinatesDidChanged coordinate: CGPoint) {
        state.selectedPoint = coordinate
    }
}
