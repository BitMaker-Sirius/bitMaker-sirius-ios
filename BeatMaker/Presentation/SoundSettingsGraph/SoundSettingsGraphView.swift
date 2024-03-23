//
//  SoundSettingsGraphView.swift
//  BeatMaker
//
//  Created by Ирина Печик on 22.03.2024.
//

import SwiftUI

struct SoundSettingsGraphView: View {
    @State private var selectedPoint: CGPoint = .zero
    
    @State private var pitch: CGFloat = 0
    @State private var volume: CGFloat = 10
    
    // Фиксируем размеры графика
    let graphWidth: CGFloat = 330
    let graphHeight: CGFloat = 330

    var body: some View {
        VStack {
            // Отображаем координаты выбранной точки у самой точки
            if selectedPoint != .zero {
                Text("Pitch: \(Int(selectedPoint.x)), Volume: \(Int(selectedPoint.y))")
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
                }.stroke(Color.black, lineWidth: 1)
                
                
                
                // Подписи к осям
                Text("Pitch")
                    .position(x: graphWidth - 30, y: graphHeight/2 + 20)
                Text("Volume")
                    .position(x: graphWidth/2 - 50, y: 15)
                
                // Рисуем выбранную точку с анимацией
                Circle()
                    .fill(Color.red)
                    .frame(width: 10, height: 10)
                    .position(x: mapValueToX(selectedPoint.x),
                              y: mapValueToY(selectedPoint.y))
                    .animation(.easeInOut, value: selectedPoint)
            }
            .frame(width: graphWidth, height: graphHeight)
            .background(.white)
            .onTapGesture { value in
                pitch = min(max(mapXToValue(value.x), -2400), 2400)
                volume = min(max(mapYToValue(value.y), 0), 20)
                self.selectedPoint = CGPoint(x: pitch, y: volume)
                // На сколько нужно отсрочить возврат точки?
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    pitch = 0
                    volume = 10
                    self.selectedPoint = CGPoint(x: pitch, y: volume)
                }
            }
            .onAppear {
                // Устанавливаем начальное положение точки в соответствии с начальными значениями Pitch и Volume
//                selectedPoint = CGPoint(x: 0, y: 10) // Например, начальные значения Pitch=0 и Volume=10
                selectedPoint = CGPoint(x: pitch, y: volume)
//                selectedPoint = CGPoint(x: 0, y: (Int(graphHeight/2)))
            }
        }
    }
    
    func mapValueToX(_ value: CGFloat) -> CGFloat {
        return (value + 2400) / 4800 * graphWidth
    }
    
    func mapValueToY(_ value: CGFloat) -> CGFloat {
        return graphHeight - ((value - 1) / 19 * graphHeight)
    }
    
    func mapXToValue(_ x: CGFloat) -> CGFloat {
        return x / graphWidth * 4800 - 2400
    }
    
    func mapYToValue(_ y: CGFloat) -> CGFloat {
        return (graphHeight - y) / graphHeight * 19 + 1
    }
}
//
//struct SoundSettingsGraph_Previews: PreviewProvider {
//    static var previews: some View {
//        SoundSettingsGraphView()
//    }
//}
