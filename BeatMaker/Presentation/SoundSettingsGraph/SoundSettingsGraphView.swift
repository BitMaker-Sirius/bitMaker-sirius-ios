//
//  SoundSettingsGraphView.swift
//  BeatMaker
//
//  Created by Ирина Печик on 22.03.2024.
//

import SwiftUI

struct SoundSettingsGraphView: View {
    @State private var selectedPoint: CGPoint = .zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Рисуем координатную ось
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height/2))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height/2))
                    path.move(to: CGPoint(x: geometry.size.width/2, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width/2, y: geometry.size.height))
                }.stroke(Color.black, lineWidth: 1)
                
                // Рисуем выбранную точку
                Circle()
                    .fill(Color.red)
                    .frame(width: 10, height: 10)
                    .position(selectedPoint)
                
                // Отображаем координаты выбранной точки у самой точки
                Text("(\(Int(selectedPoint.x - geometry.size.width/2)), \(Int(geometry.size.height/2 - selectedPoint.y))")
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(5)
                    .position(x: selectedPoint.x, y: selectedPoint.y - 20)
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .foregroundStyle(.clear)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(.white)
//            .gesture(DragGesture()
//                .onChanged { value in
//                    print(value.location)
//                    self.selectedPoint = value.location
//                }
//            )
            .gesture(DragGesture()
                .onEnded { value in
                    self.selectedPoint = value.location
                }
            )
            .onAppear {
                selectedPoint = CGPoint(x: (Int(geometry.size.width/2)), y: (Int(geometry.size.height/2)))
            }
        }
    }
}
//-2400 2400
//1/32 32

#Preview {
    SoundSettingsGraphView()
}
