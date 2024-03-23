//
//  MainScreenView.swift
//  BeatMaker
//
//  Created by 1 on 21.03.2024.
//

import SwiftUI

enum AnimationProperties {
    static let animationSpeed: Double = 4
    static let timeDuration: Double = 3
    static let blurRadius: Double = 130
}

struct MainScreenView<ViewModel: MainScreenViewObservable>: View {
    @StateObject
    var mainScreenViewModel: ViewModel
    
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    @State private var screenBounds: CGRect = .zero
    @State private var boundsPosition: CGSize = .zero
    
    let heightLimit: CGFloat = 100
    
//    @State private var dragOffset = CGSize.zero
//    @State private var lastOffset: CGFloat = 0
//    
//    private var offset: CGFloat {
//        let minOffset: CGFloat = 200.0
//        let maxOffset: CGFloat = 600.0
//        let offset: CGFloat
////        case .leading:
//            offset = lastOffset + dragOffset.height
////            lastOffset = offset - dragOffset.height
//
////        case .trailing:
////            width = lastOffset - dragOffset.width
//        return offset
//    }
    
    private enum GtadientColors {
        static var all: [Color] {
            [
                Color(.blue),
                Color(.yellow),
                Color(.systemGreen).opacity(100)
            ]
        }
        
        static var backgroundColor: Color {
            Color(
                #colorLiteral(
                    red: 0.003799867816,
                    green: 0.01174801588,
                    blue: 0.07808648795,
                    alpha: 1
                )
            )
        }
    }
    
    private struct MovingCircle: Shape {
        var originOffset: CGPoint
        
        var animatableData: CGPoint.AnimatableData {
            get {
                originOffset.animatableData
            }
            
            set {
                originOffset.animatableData = newValue
            }
        }
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            let adjustedX = rect.width * originOffset.x
            let adjustedY = rect.height * originOffset.y
            let smallestDimension = min(rect.width, rect.height)
            
            path.addArc(
                center: CGPoint(x: adjustedX, y: adjustedY),
                radius: smallestDimension,
                startAngle: .zero,
                endAngle: .degrees(360), clockwise: true
            )
            
            return path
        }
    }
    
    @State private var timer = Timer.publish(
        every: AnimationProperties.timeDuration,
        on: .main,
        in: .common
    )
        .autoconnect()
    
    @ObservedObject private var animator = CircleAnimator(
        colors: GtadientColors.all
    )
    
    var body: some View {
        ZStack {
            
            ZStack {
                ZStack {
                    ForEach(animator.circles) { circle in
                        MovingCircle(originOffset: circle.position)
                            .foregroundStyle(circle.color)
                    }
                }
                .blur(radius: AnimationProperties.blurRadius)
                
                Button(
                    action: {
                        mainScreenViewModel.handle(.tapCreateTrackButton)
                    }
                ) {
                    HStack {
                        Image(systemName: "arrowtriangle.right.fill")
                            .foregroundColor(.black)
                            .padding(.leading)
                        Text("Новый трек")
                            .bold()
                            .foregroundStyle(.black)
                            .padding()
                        
                    }
                    .background(Color.white)
                    .cornerRadius(30)
                }
                .padding(.bottom, 300)
                
                    VStack {
                        Text("Мои треки")
                            .font(.largeTitle)
                            .bold()
                            .padding(.top, 20)
                            .padding(.leading, -150)
                        Spacer()
                        
                        ForEach(1..<11) { index in
                            TrackRow(trackNumber: index)
                        }
                    }
                    .onAppear() {
                           currentPosition = .zero
                           newPosition = .zero
                            setTravelLimits()
                            limitTravel()
                          }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.top, UIScreen.main.bounds.height / 2)
                    .offset(y: currentPosition.height)
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged { value in
                            currentPosition = CGSize(width: 0, height: value.translation.height + newPosition.height)
                            limitTravel()
                        }
                        .onEnded(
                            { value in
                                currentPosition = CGSize(width: 0, height: value.translation.height + newPosition.height)
                                limitTravel()
                                newPosition = currentPosition
                            }
                        )
                    )
            }
            .background(GtadientColors.backgroundColor)
            .onDisappear {
                timer.upstream.connect().cancel()
            }
            .onAppear {
                animateCircles()
                timer = Timer.publish(
                    every: AnimationProperties.timeDuration,
                    on: .main,
                    in: .common
                )
                .autoconnect()
            }
            .onReceive(timer) { _ in
                animateCircles()
            }
        }
        .frame(height: UIScreen.main.bounds.height)
    }
    
    func setTravelLimits() {
        screenBounds = UIScreen.main.bounds
        boundsPosition.width = screenBounds.width
        boundsPosition.height = (screenBounds.height / 2) - heightLimit
      }
      
      func limitTravel() {
        currentPosition.height = currentPosition.height > boundsPosition.height ? boundsPosition.height: currentPosition.height
       currentPosition.height = currentPosition.height < -boundsPosition.height ? -boundsPosition.height: currentPosition.height
        currentPosition.width = currentPosition.width > boundsPosition.width ? boundsPosition.width: currentPosition.width
        currentPosition.width = currentPosition.width < -boundsPosition.width ? -boundsPosition.width: currentPosition.width
      }
    
    private func animateCircles() {
        withAnimation(.easeInOut(duration: AnimationProperties.timeDuration), { animator.animate() })
    }
}

struct MainScreenPreviews: PreviewProvider {
    static var previews: some View {
        MainScreenView(mainScreenViewModel: MainScreenViewModel())
    }
}

struct TrackRow: View {
    var trackNumber: Int
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 50, height: 50)
                    .padding()
                Text("😎")
                    .frame(width: 35, height: 35, alignment: .center)
                    .padding()
            }
            Text("Трек \(trackNumber)")
                .padding()
            Spacer()
            Image(systemName: "play.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.black)
                .padding(.trailing, 50)
        }
        .padding(.leading)
    }
}

private class CircleAnimator: ObservableObject {
    class Circle: Identifiable {
        var position: CGPoint
        let id = UUID().uuidString
        let color: Color
        
        internal init(position: CGPoint, color: Color) {
            self.position = position
            self.color = color
        }
    }
    
    @Published private(set) var circles: [Circle] = []
    
    init(colors: [Color]) {
        circles = colors.map(
            { color in
                Circle(
                    position: CircleAnimator.generateRandomPosition(),
                    color: color
                )
            }
        )
    }
    
    func animate() {
        objectWillChange.send()
        for circle in circles {
            circle.position = CircleAnimator.generateRandomPosition()
        }
    }
    
    static func generateRandomPosition() -> CGPoint {
        CGPoint(
            x: CGFloat.random(in: 0...1),
            y: CGFloat.random(in: 0...1)
        )
    }
}
