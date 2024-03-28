//
//  SpeechVizualizationView.swift
//  BeatMaker
//
//  Created by Тася Галкина on 28.03.2024.
//

import Foundation
import SwiftUI
import Charts

enum ConstantsBar {
    static let updateInterval = 0.03
    static let barAmount = 40
    static let magnitudeLimit: Float = 32
}

struct SpeechVizualizationView<ViewModel: PlayProjectViewModel>: View {
    let audioProcessing = SpeechVizualizationViewModelImp.shared
    
    let projectId: String
    @ObservedObject var viewModel: ViewModel
    
    init(projectId: String, viewModel: ViewModel) {
        self.projectId = projectId
        self.viewModel = viewModel
    }
    
    let timer = Timer.publish(
        every: ConstantsBar.updateInterval,
        on: .main,
        in: .common
    ).autoconnect()

    
    @State var isRecord = false
    @State var isPlaying = false
    @State var data: [Float] = Array(repeating: 0, count: ConstantsBar.barAmount)
        .map { _ in Float.random(in: 1 ... ConstantsBar.magnitudeLimit) }

    var body: some View {
        VStack {
            VStack(spacing: 0) {
                chartSoundView
                chartSoundView
                    .scaleEffect(x: -1)
                    .rotationEffect(.degrees(180))
            }
        }
    }
    
    var chartSoundView: some View {
        Chart(Array(data.enumerated()), id: \.0) { index, magnitude in
            BarMark(
                x: .value("Frequency", String(index)),
                y: .value("Magnitude", magnitude)
            )
            .cornerRadius(5)
            .foregroundStyle(
                Color(
                    hue: 0.65 - Double((magnitude / ConstantsBar.magnitudeLimit) / 10),
                    saturation: 0.4,
                    brightness: 1,
                    opacity: 0.7
                )
            )
            .shadow(color: Color(
                hue: 0.65 - Double((magnitude / ConstantsBar.magnitudeLimit) / 10),
                saturation: 0.4,
                brightness: 1,
                opacity: 0.7
            ), radius: 10)
        }
        .onReceive(timer, perform: updateData)
        .chartYScale(domain: 0 ... ConstantsBar.magnitudeLimit)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(height: 100)
    }

    func updateData(_: Date) {
        if viewModel.state.isPlaying  {
            withAnimation(.easeOut(duration: 0.08)) {
                data = audioProcessing.fftMagnitudes.map {
                    min($0, ConstantsBar.magnitudeLimit)
                }
            }
        }
    }

    func playButtonTapped() {
        if viewModel.state.isPlaying  {
            audioProcessing.player.pause()
        } else {
            audioProcessing.player.play()
        }
                isPlaying.toggle()
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        SpeechVizualizationView()
//    }
//}

