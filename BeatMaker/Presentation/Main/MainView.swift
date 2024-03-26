//
//  MainView.swift
//  BeatMaker
//
//  Created by 1 on 21.03.2024.
//

import SwiftUI

struct MainView<ViewModel: MainViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    @State private var screenBounds: CGRect = .zero
    @State private var boundsPosition: CGSize = .zero
    
    @State private var timer = Timer.publish(
        every: AnimationProperties.timeDuration,
        on: .main,
        in: .common
    ).autoconnect()
    
    @ObservedObject private var animator = CircleAnimator(
        colors: GtadientColors.all
    )
    
    private let heightLimit: CGFloat = 100
    
    var body: some View {
        ZStack {
            switch viewModel.state.indicatorViewState {
            case .display:
                ZStack {
                    ZStack {
                        ZStack {
                            ForEach(animator.circles) { circle in
                                MovingCircle(originOffset: circle.position)
                                    .foregroundStyle(circle.color)
                            }
                        }
                        .blur(radius: AnimationProperties.blurRadius)
                        
                        Button {
                            viewModel.handle(.tapCreateProjectButton)
                        } label: {
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
                            
                            if !viewModel.state.projectsList.isEmpty {
                                ForEach(viewModel.state.projectsList, id: \.id) { project in
                                    ProjectRow(
                                        parentViewModel: viewModel,
                                        project: project
                                    )
                                }
                            } else {
                                HStack {
                                    Text("Самое время сделать трек!")
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
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
                            .onEnded { value in
                                currentPosition = CGSize(width: 0, height: value.translation.height + newPosition.height)
                                limitTravel()
                                newPosition = currentPosition
                            }
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
            case .loading:
                ProgressView()
            case .error:
                Button {
                    viewModel.handle(.onLoadData)
                } label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.system(size: 20))
                }
            }
        }
        .onAppear {
            // TODO: Таймер ожидания загрузки
            viewModel.handle(.onLoadData)
        }
    }
    
    private func setTravelLimits() {
        screenBounds = UIScreen.main.bounds
        boundsPosition.width = screenBounds.width
        boundsPosition.height = (screenBounds.height / 2) - heightLimit
    }
      
    private func limitTravel() {
        currentPosition.height = currentPosition.height > boundsPosition.height ? boundsPosition.height : currentPosition.height
        currentPosition.height = currentPosition.height < -boundsPosition.height ? -boundsPosition.height : currentPosition.height
        currentPosition.width = currentPosition.width > boundsPosition.width ? boundsPosition.width : currentPosition.width
        currentPosition.width = currentPosition.width < -boundsPosition.width ? -boundsPosition.width : currentPosition.width
    }
    
    private func animateCircles() {
        withAnimation(.easeInOut(duration: AnimationProperties.timeDuration), {
            animator.animate()
        })
    }
}

// MARK: GtadientColors

fileprivate enum GtadientColors {
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

// MARK: AnimationProperties

fileprivate enum AnimationProperties {
    static let timeDuration: Double = 3
    static let blurRadius: Double = 130
}

// MARK: CircleAnimator

fileprivate final class CircleAnimator: ObservableObject {
    @Published private(set) var circles: [Circle] = []
    
    init(colors: [Color]) {
        circles = colors.map { color in
            Circle(
                position: CircleAnimator.generateRandomPosition(),
                color: color
            )
        }
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

// MARK: Circle

fileprivate final class Circle: Identifiable {
    let id = UUID().uuidString
    var position: CGPoint
    let color: Color
    
    init(position: CGPoint, color: Color) {
        self.position = position
        self.color = color
    }
}

// MARK: MovingCircle

fileprivate struct MovingCircle: Shape {
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
