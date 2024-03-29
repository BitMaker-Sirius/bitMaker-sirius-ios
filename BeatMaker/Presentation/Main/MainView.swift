//
//  MainView.swift
//  BeatMaker
//
//  Created by 1 on 21.03.2024.
//

import SwiftUI

/// Constants for view
fileprivate enum ConstantsForView {
    static let ImageSize: CGFloat = 40
    static let defaultEmoji = "\u{1f600}"
    static let defaultName = "sound"
}

struct MainView<ViewModel: MainViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.colorScheme) var colorScheme
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    private var startHeight: CGFloat {
        if self.viewModel.state.projectsList.isEmpty {
            return Constants.emptyTrackListHeight
        }
        
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
        if self.viewModel.state.projectsList.isEmpty {
            return Constants.emptyTrackListHeight
        }
        
        return min(
            CGFloat(
                self.viewModel.state.projectsList.count * Constants.trackRowHeight
                + Constants.spacerHeight * (self.viewModel.state.projectsList.count - 1)
                + Constants.listTitleHeight
            ),
            CGFloat(UIScreen.main.bounds.height)
        )
    }
    
    @State var currentHeight: CGFloat = 0.0
    
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
                Text(L10n.Main.newProject)
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
                Text(L10n.Main.myTracks)
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                Button {
                    viewModel.handle(.tapEditing)
                } label: {
                    Text(L10n.Main.edit)
                        .foregroundStyle(viewModel.state.isEditing ? .gray : .blue)
                }
            }
            .padding()
            .backgroundColor(colorScheme)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged { value in
                    let delta = abs(value.translation.height)
                    
                    if value.translation.height >= 0 {
                        viewModel.handle(.scrollDown(delta: delta))
                    } else {
                        viewModel.handle(.scrollUp(delta: delta))
                    }
                }
                .onEnded { value in
                    let delta = abs(value.translation.height)
                    
                    if value.translation.height > 0 {
                        viewModel.handle(.scrollDown(delta: delta))
                    } else {
                        viewModel.handle(.scrollUp(delta: delta))
                    }
                }
            )
            
            if !viewModel.state.projectsList.isEmpty {
                ScrollView {
                    ForEach(viewModel.state.projectsList, id: \.id) { project in
                        Spacer()
                        projectCell(withProject: project)
                        .backgroundColor(colorScheme)
                        Spacer()
                    }
                }
            } else {
                HStack {
                    Text("Самое время сделать трек!")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 90)
                }
                .ignoresSafeArea()
                .padding(.bottom, 0)
            }
        }
        .padding([.leading, .trailing])
        .ignoresSafeArea(edges: .bottom)
        .backgroundColor(colorScheme)
        .onAppear() {
//            currentHeight = startHeight
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        
        .frame(height: viewModel.state.projectsListHeight)

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
    
    private func getActualTrackListHeight() -> CGFloat {
        if self.viewModel.state.projectsList.isEmpty {
            return Constants.emptyTrackListHeight
        }
        
        return min(
            CGFloat(
                self.viewModel.state.projectsList.count * Constants.trackRowHeight
                + Constants.spacerHeight * (self.viewModel.state.projectsList.count - 1)
                + Constants.listTitleHeight
            ),
            CGFloat(UIScreen.main.bounds.height / 2)
        )
    }
    
    private func getImagePath(imageId id: String) -> String {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
         return documentsDirectory.appendingPathComponent("Images")
            .appendingPathComponent("\(String(describing: id)).png").absoluteString
    }
    
    @ViewBuilder
    func projectCell(withProject project: Project) -> some View {
        
        HStack(alignment: .center, spacing: 5) {
            
            Spacer()
            
            if let imageId = project.image {
                Image(uiImage: viewModel.state.allImages[imageId] ?? UIImage(systemName: "rectangle.fill.badge.xmark")!)
                    .resizable()
                    .frame(width: ConstantsForView.ImageSize+20, height: ConstantsForView.ImageSize+20)
                    .cornerRadius(ConstantsForView.ImageSize/2+10)
            } else {
                Image(uiImage: UIImage(systemName: "rectangle.fill.badge.xmark")!)
                    .resizable()
                    .frame(width: ConstantsForView.ImageSize+20, height: ConstantsForView.ImageSize+20)
                    .cornerRadius(ConstantsForView.ImageSize/2+10)
            }

            Spacer()
            HStack() {
                VStack(alignment: .listRowSeparatorLeading) {
                    Text(project.name)
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(Color.onBackgroundColor)
                        .padding(.top, 10)
                    
                    Text("Нажмите для редактирования")
                        .font(.system(size: 14))
                        .fontWeight(.thin)
                        .foregroundColor(Color.onBackgroundColor)
                    
                }
                
                Spacer()
                
                HStack(alignment: .center) {
                    Button {
                        if viewModel.state.isEditing {
                            viewModel.handle(.tapDeleteButton(projectId: project.id))
                        } else {
                            viewModel.handle(.tapListenProject(projectId: project.id))
                        }
                        
                    } label: {
                        Image(systemName: viewModel.state.isEditing ? "trash.circle" : "play.circle")
                            .resizable()
                            .frame(width: ConstantsForView.ImageSize, height: ConstantsForView.ImageSize)
                            .foregroundColor(Color.onBackgroundColor)
                    }
                }
                .frame(width: ConstantsForView.ImageSize, height: ConstantsForView.ImageSize)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 76)
        .foregroundColor(.purple)
        .padding(.vertical, 2)
        .onTapGesture {
            viewModel.handle(.tapEditProject(projectId: project.id))
        }
    }
}

enum Constants {
    static let trackRowHeight = 56
    static let emptyTrackListHeight: CGFloat = 200
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
