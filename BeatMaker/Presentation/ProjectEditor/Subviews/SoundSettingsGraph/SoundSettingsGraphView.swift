//
//  SoundSettingsGraphView.swift
//  BeatMaker
//
//  Created by Ирина Печик on 22.03.2024.
//

import SwiftUI

enum SoundSettingsGraphEvent {
    case tappedOnGraph(x: CGPoint)
}

struct SoundSettingsGraphViewState {
    var selectedPoint: CGPoint
    var pitch: CGFloat
    var volume: CGFloat

}

struct SoundSettingsViewParamsState {
    var graphHeight: CGFloat
    var graphWidth: CGFloat
}

protocol SoundSettingsGraphViewModeling: ObservableObject {
    var state: SoundSettingsGraphViewState { get set}
    var viewState: SoundSettingsViewParamsState {get set}
    func mapValueToX() -> CGFloat
    func mapValueToY() -> CGFloat
    func mapXToValue(_ x: CGFloat) -> CGFloat
    func mapYToValue(_ y: CGFloat) -> CGFloat
    func changeParams(currentPoint: CGPoint)
    func makeVibration()
}

struct SoundSettingsGraphView<ViewModel: SoundSettingsGraphViewModeling>: View{
    @StateObject var soundSettingsGraphViewModel: ViewModel
    @State private var duration: Double = 0.6
    @State private var resetWorkItem: DispatchWorkItem?
    @State private var animate: Bool = false
    @State private var circlePosition: CGPoint = .zero
    
    var body: some View {
        VStack {
//            VStack {
                // Отображаем координаты выбранной точки у самой точки
//                Text("Тон: \(Int(soundSettingsGraphViewModel.state.selectedPoint.x)), Громкость: \(Int(soundSettingsGraphViewModel.state.selectedPoint.y))")
//                    .font(customFont: .subtitle, size: 15)
//                    .padding(5)
//                    .background(Color.white)
//                    .cornerRadius(5)
                
                
                ZStack {
                    // Рисуем координатную ось
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: soundSettingsGraphViewModel.viewState.graphHeight/2))
                        path.addLine(to: CGPoint(x: soundSettingsGraphViewModel.viewState.graphWidth, y: soundSettingsGraphViewModel.viewState.graphHeight/2))
                        
                        path.move(to: CGPoint(x: soundSettingsGraphViewModel.viewState.graphWidth/2, y: 0))
                        path.addLine(to: CGPoint(x: soundSettingsGraphViewModel.viewState.graphWidth/2, y: soundSettingsGraphViewModel.viewState.graphHeight))
                    }.stroke(Color(red: 122/255, green: 138/255, blue: 169/255), lineWidth: 1)
                    
                    // Подписи к осям
                    Text(L10n.ProjectEditor.pitch)
                        .font(customFont: .subtitle, size: 15)
                        .position(x: soundSettingsGraphViewModel.viewState.graphWidth - 30, y: soundSettingsGraphViewModel.viewState.graphHeight/2 + 20)
                    Text(L10n.ProjectEditor.volume)
                        .font(customFont: .subtitle, size: 15)
                        .position(x: soundSettingsGraphViewModel.viewState.graphWidth/2 - 50, y: 15)
                    if animate {
                        Circle()
                            .fill(RadialGradient(gradient: Gradient(colors: [Color(red: 4/255, green: 18/255, blue: 150/255), Color(red: 246/255, green: 248/255, blue: 254/255)]), center: .center, startRadius: 2, endRadius: 7))
                            .frame(width: 13, height: 13)
                            .scaleEffect(9)
                            .opacity(0.5)
                            .position(circlePosition)
                            .transition(.opacity)
                    }
                }
                .frame(width: soundSettingsGraphViewModel.viewState.graphWidth, height: soundSettingsGraphViewModel.viewState.graphHeight)
                .background(Color.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onTapGesture { value in
                    // Генерация вибрации
                    soundSettingsGraphViewModel.makeVibration()
                    
                    soundSettingsGraphViewModel.changeParams(currentPoint: value)
                    resetWorkItem?.cancel()
                    
                    circlePosition = value
                    withAnimation {
                        animate = true
                    }
                    let workItem = DispatchWorkItem {
                        animate = false
                    }
                    self.resetWorkItem = workItem
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: workItem)
                }
                .onAppear {
                    // Устанавливаем начальное положение точки в соответствии с начальными значениями Pitch и Volume
                    soundSettingsGraphViewModel.state.selectedPoint = CGPoint(x: 0, y: 0)
                }
//            }
        }
    }
}

struct SoundSettingsGraph_Previews: PreviewProvider {
    static var previews: some View {
        SoundSettingsGraphView(soundSettingsGraphViewModel: SoundSettingsGraphViewModel(handle: { point in }))
    }
}
