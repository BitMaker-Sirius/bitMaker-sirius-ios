//
//  MainView.swift
//  BeatMaker
//
//  Created by 1 on 21.03.2024.
//

import SwiftUI

struct MainView<ViewModel: MainViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.colorScheme) var colorScheme
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    private var startHeight: CGFloat {
        return min(
            CGFloat(
                self.viewModel.state.projectsList.count * Constants.trackRowHeight
                + Constants.spacerHeight * (self.viewModel.state.projectsList.count - 1)
                + Constants.listTitleHeight
            ),
            CGFloat(UIScreen.main.bounds.height / 2)
        )
    }
    
    private var maxHeight: CGFloat {
        return min(
            CGFloat(
                self.viewModel.state.projectsList.count * Constants.trackRowHeight
                + Constants.spacerHeight * (self.viewModel.state.projectsList.count - 1)
                + Constants.listTitleHeight
            ),
            CGFloat(UIScreen.main.bounds.height)
        )
    }
    
    @State private var currentHeight: CGFloat = 0.0
    
    @State private var timer = Timer.publish(
        every: AnimationProperties.timeDuration,
        on: .main,
        in: .common
    ).autoconnect()
    
    @ObservedObject private var animator = CircleAnimator(
        colors: GtadientColors.all
    )
        
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
                        
                        createTrackButton
                        
                        VStack {
                            Spacer()
                            
                            myTracksList
                        }
                        .ignoresSafeArea(edges: .bottom)
                    }
                    .ignoresSafeArea(edges: .bottom)
                }
                .ignoresSafeArea(edges: .bottom)
                .frame(height: UIScreen.main.bounds.height)
            case .loading:
                ProgressView()
            case .error:
                Button {
                    viewModel.handle(.onLoadData)
                } label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.system(size: 40))
                }
            }
        }
        .onAppear {
            // TODO: Таймер ожидания загрузки
            viewModel.handle(.onLoadData)
        }
    }
    
    private var createTrackButton: some View {
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
    }
    
    private var myTracksList: some View {
        VStack {
            HStack(alignment: .lastTextBaseline) {
                Text("Мои треки")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                Button {
                    viewModel.handle(.tapEditing)
                } label: {
                    Text("редактировать")
                        .foregroundStyle(viewModel.state.isEditing ? .gray : .blue)
                }
            }
            .padding()
            .backgroundColor(colorScheme)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged { value in
                    let delta = abs(value.translation.height)
                    
                    if value.translation.height >= 0 {
                        currentHeight = CGFloat(
                            max(
                                currentHeight - delta,
                                startHeight
                            )
                        )
                    } else {
                        currentHeight = CGFloat(
                            min(
                                currentHeight + delta,
                                maxHeight
                            )
                        )
                    }
                }
                .onEnded { value in
                    let delta = abs(value.translation.height)
                    
                    if value.translation.height > 0 {
                        currentHeight = CGFloat(
                            max(
                                currentHeight - delta,
                                startHeight
                            )
                        )
                    } else {
                        currentHeight = CGFloat(
                            min(
                                currentHeight + delta,
                                maxHeight
                            )
                        )
                    }
                }
            )
            
            if !viewModel.state.projectsList.isEmpty {
                ScrollView {
                    ForEach(viewModel.state.projectsList, id: \.id) { project in
                        ProjectRow(
                            parentViewModel: viewModel,
                            project: project
                        )
                        .frame(height: 56)
                        .backgroundColor(colorScheme)
                    }
                }
            } else {
                HStack {
                    Text("Самое время сделать трек!")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        
        .ignoresSafeArea(edges: .bottom)
        .backgroundColor(colorScheme)
        .onAppear() {
            currentHeight = startHeight
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        
        .frame(height: currentHeight)

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
        .ignoresSafeArea(edges: .bottom)
    }
    
    private func animateCircles() {
        withAnimation(.easeInOut(duration: AnimationProperties.timeDuration), {
            animator.animate()
        })
    }
}

private enum Constants {
    static let trackRowHeight = 56
    static let listTitleHeight = 130
    static let spacerHeight = 8
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
    
    static var backgroundColorDarkTheme: Color {
        Color(
            #colorLiteral(
                red: 1,
                green: 1,
                blue: 1,
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

extension View {
    func backgroundColor(_ colorScheme: ColorScheme) -> some View {
        self.background(
            colorScheme == .dark ?
            GtadientColors.backgroundColor : GtadientColors.backgroundColorDarkTheme
        )
    }
}
