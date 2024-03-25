//
//  SoundSettingsGraphViewModel.swift
//  BeatMaker
//
//  Created by Ирина Печик on 25.03.2024.
//

import Foundation

protocol SoundSettingsGraphProviderObserver: AnyObject {
    func handle(pointCoordinatesDidChanged coordinate: CGPoint)
}

class SoundSettingsGraphProvider {
    weak var observer: SoundSettingsGraphProviderObserver?
    var selectedPoint: CGPoint
    var pitch: CGFloat = 0
    var volume: CGFloat = 10
    
    init(selectedPoint: CGPoint, pitch: CGFloat, volume: CGFloat) {
        self.pitch = pitch
        self.selectedPoint = selectedPoint
        self.volume = volume
        self.observer?.handle(pointCoordinatesDidChanged: selectedPoint)
    }
}

class SoundSettingsGraphViewModel: SoundSettingsGraphViewModeling {
    let graphWidth: CGFloat = 330
    let graphHeight: CGFloat = 330
    
    @Published
    var state = SoundSettingsGraphViewState(
        shouldMovePoint: false,
        selectedPoint: CGPoint(x: 0, y: 10),
        pitch: 0,
        volume: 10
    )
    
    private lazy var soundSettingsGraphProvider: SoundSettingsGraphProvider = {
        let provider = SoundSettingsGraphProvider(selectedPoint: state.selectedPoint, pitch: state.pitch, volume: state.volume)
        provider.observer = self
        return provider
    }()
    
    init() {
        self.state = state
        state.pitch = soundSettingsGraphProvider.pitch
        state.volume = soundSettingsGraphProvider.volume
        state.selectedPoint = soundSettingsGraphProvider.selectedPoint
    }

    func handle(_ event: SoundSettingsGraphEvent) {
        switch event {
        case .tappedOnGraph:
            state.shouldMovePoint = true
            // А тут что????????
        }
    }
    
    func changeParams(currentPoint: CGPoint) {
        state.pitch = min(max(mapXToValue(currentPoint.x), -2400), 2400)
        state.volume = min(max(mapYToValue(currentPoint.y), 0), 20)
        state.selectedPoint = CGPoint(x: state.pitch, y: state.volume)
    }
    
    func mapValueToX() -> CGFloat {
        return (state.selectedPoint.x + 2400) / 4800 * graphWidth
    }
    
    func mapValueToY() -> CGFloat {
        return graphHeight - (state.selectedPoint.y / 20 * graphHeight)
    }
    
    func mapXToValue(_ x: CGFloat) -> CGFloat {
        return x / graphWidth * 4800 - 2400
    }
    
    func mapYToValue(_ y: CGFloat) -> CGFloat {
        return (graphHeight - y) / graphHeight * 19 + 1
    }
    
}

extension SoundSettingsGraphViewModel: SoundSettingsGraphProviderObserver {
    func handle(pointCoordinatesDidChanged coordinate: CGPoint) {
        state.selectedPoint = coordinate
    }
}
