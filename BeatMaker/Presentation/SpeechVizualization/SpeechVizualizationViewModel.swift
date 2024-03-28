//
//  SpeechVizualizationViewModel.swift
//  BeatMaker
//
//  Created by Тася Галкина on 28.03.2024.
//

import Foundation
import AVFoundation
import Accelerate

enum SpeechVizualizationViewEvent {
    
}

struct SpeechVizualizationViewState {
    var isPlayng: Bool = false
}

protocol SpeechVizualizationViewModel: ObservableObject {
}

class SpeechVizualizationViewModelImp {
    
    @Published var state = SpeechVizualizationViewState(isPlayng: false)
    static var shared: SpeechVizualizationViewModelImp = .init()
    
    private var engine = AVAudioEngine()
    private var bufferSize = 1024
    
    let player = AVAudioPlayerNode()
    
    var fftMagnitudes: [Float] = []
    
    init() {
        _ = engine.mainMixerNode
        
        engine.prepare()
        try! engine.start()
        
        let audioFile = try! AVAudioFile(forReading: Bundle.main.url(forResource: "mockSound", withExtension: "caf")!)
//        print(Bundle.main.url(forResource: "mockSound", withExtension: "caf"))
        let format = audioFile.processingFormat
        
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: format)
        
        player.scheduleFile(audioFile, at: nil)
        
        let fftSetup = vDSP_DFT_zop_CreateSetup(
            nil,
            UInt(bufferSize),
            vDSP_DFT_Direction.FORWARD
        )
        
        engine.mainMixerNode.installTap(
            onBus: 0,
            bufferSize: UInt32(bufferSize),
            format: nil
        ) { [self] buffer, _ in
            let channelData = buffer.floatChannelData?[0]
            fftMagnitudes = fft(data: channelData!, setup: fftSetup!)
        }
        
    }
    
    func fft(data: UnsafeMutablePointer<Float>, setup: OpaquePointer) -> [Float] {
        var realIn = [Float](repeating: 0, count: bufferSize)
        var imagIn = [Float](repeating: 0, count: bufferSize)
        var realOut = [Float](repeating: 0, count: bufferSize)
        var imagOut = [Float](repeating: 0, count: bufferSize)
        
        for i in 0 ..< bufferSize {
            realIn[i] = data[i]
        }
        
        vDSP_DFT_Execute(setup, &realIn, &imagIn, &realOut, &imagOut)
        
        var magnitudes = [Float](repeating: 0, count: ConstantsBar.barAmount)
        
        realOut.withUnsafeMutableBufferPointer { realBP in
            imagOut.withUnsafeMutableBufferPointer { imagBP in
                var complex = DSPSplitComplex(realp: realBP.baseAddress!, imagp: imagBP.baseAddress!)
                vDSP_zvabs(&complex, 1, &magnitudes, 1, UInt(ConstantsBar.barAmount))
            }
        }
        
        var normalizedMagnitudes = [Float](repeating: 0.0, count: ConstantsBar.barAmount)
        var scalingFactor = Float(1)
        vDSP_vsmul(&magnitudes, 1, &scalingFactor, &normalizedMagnitudes, 1, UInt(ConstantsBar.barAmount))
        
        return normalizedMagnitudes
    }
    
    
}

