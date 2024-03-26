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

class SoundSettingsGraphViewModel: SoundSettingsGraphViewModeling {
    let graphWidth: CGFloat = 330
    let graphHeight: CGFloat = 330
    
    @Published
    var state = SoundSettingsGraphViewState(
        selectedPoint: CGPoint(x: 0, y: 10),
        pitch: 0,
        volume: 10
    )
    
    init() {
        self.state = state
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
