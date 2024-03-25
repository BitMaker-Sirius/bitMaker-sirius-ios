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
    var shouldMovePoint: Bool
    var selectedPoint: CGPoint
    var pitch: CGFloat
    var volume: CGFloat

}

protocol SoundSettingsGraphViewModeling: ObservableObject {
    var state: SoundSettingsGraphViewState { get set}
    func handle(_ event: SoundSettingsGraphEvent)
    func mapValueToX() -> CGFloat
    func mapValueToY() -> CGFloat
    func mapXToValue(_ x: CGFloat) -> CGFloat
    func mapYToValue(_ y: CGFloat) -> CGFloat
    func changeParams(currentPoint: CGPoint)
}

struct SoundSettingsGraphView<ViewModel: SoundSettingsGraphViewModeling>: View {
    @ObservedObject var soundSettingsGraphViewModel: ViewModel

    @State private var duration: Double = 3
    @State var resetWorkItem: DispatchWorkItem?

    // Фиксируем размеры графика
    let graphWidth: CGFloat = 330
    let graphHeight: CGFloat = 330
    
    var body: some View {
        VStack {
            // Отображаем координаты выбранной точки у самой точки
            if soundSettingsGraphViewModel.state.selectedPoint != .zero {
                Text("Pitch: \(Int(soundSettingsGraphViewModel.state.selectedPoint.x)), Volume: \(Int(soundSettingsGraphViewModel.state.selectedPoint.y))")
                    .font(customFont: .accentTitle, size: 15)
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(5)
            }
            ZStack {
                // Рисуем координатную ось
                Path { path in
                    path.move(to: CGPoint(x: 0, y: graphHeight/2))
                    path.addLine(to: CGPoint(x: graphWidth, y: graphHeight/2))
                    
                    path.move(to: CGPoint(x: graphWidth/2, y: 0))
                    path.addLine(to: CGPoint(x: graphWidth/2, y: graphHeight))
                }.stroke(Color(red: 122/255, green: 138/255, blue: 169/255), lineWidth: 1)
                
                
                // Подписи к осям
                Text("Pitch")
                    .font(customFont: .subtitle, size: 15)
                    .position(x: graphWidth - 30, y: graphHeight/2 + 20)
                Text("Volume")
                    .font(customFont: .subtitle, size: 15)
                    .position(x: graphWidth/2 - 50, y: 15)
                
                // Рисуем выбранную точку с анимацией
                Circle()
                    .fill(Color(red: 122/255, green: 138/255, blue: 169/255))
                    .frame(width: 10, height: 10)
                    .position(x: soundSettingsGraphViewModel.mapValueToX(),
                              y: soundSettingsGraphViewModel.mapValueToY())
                    .animation(.easeInOut, value: soundSettingsGraphViewModel.state.selectedPoint)
            }
            .frame(width: graphWidth, height: graphHeight)
            .background(Color(red: 246/255, green: 248/255, blue: 254/255))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture { value in
                soundSettingsGraphViewModel.changeParams(currentPoint: value)
                resetWorkItem?.cancel()

                // Создаем новый DispatchWorkItem
                let workItem = DispatchWorkItem {
                    var point = CGPoint(x: 0, y: 10)
                    soundSettingsGraphViewModel.state.pitch = 0
                    soundSettingsGraphViewModel.state.volume = 10
                    soundSettingsGraphViewModel.state.selectedPoint = CGPoint(x: 0, y: 10)
                }
                
                // Сохраняем новый DispatchWorkItem для возможной отмены в будущем
                self.resetWorkItem = workItem
                DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: workItem)

            }
            .onAppear {
                // Устанавливаем начальное положение точки в соответствии с начальными значениями Pitch и Volume
                soundSettingsGraphViewModel.state.selectedPoint = CGPoint(x: 0, y: 10)
            }
        }
    }
}

struct SoundSettingsGraph_Previews: PreviewProvider {
    static var previews: some View {
        SoundSettingsGraphView(soundSettingsGraphViewModel: SoundSettingsGraphViewModel())
    }
}
