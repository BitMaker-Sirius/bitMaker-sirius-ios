//
//  PlayTrackView.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

enum PlayProjectViewEvent {
    case playTap
    case nextTap
    case prevTap
    case editTap
    case likeTap
    case backTap
}

struct PlayProjectViewState {
    var project: Project
    var isPlaying: Bool = false
    var currentTime: Double = 0
    var totalTime: Double
    var liked: Bool
    var formatTime: String
    var isList: Bool
}

protocol PlayProjectViewModeling: ObservableObject {
    var state: PlayProjectViewState { get }

    func handle(_ event: PlayProjectViewEvent)
}

struct PlayProjectView<ViewModel: PlayProjectViewModeling>: View {
    let projectId: String
    @StateObject var viewModel: ViewModel
    
    @State
    private var sliderValue: CGFloat = .zero {
        didSet {

        }
    }
    
    var body: some View {
        ZStack {
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center) {
                    Button(action: {
                        viewModel.handle(.backTap)
                    }) {
                        Image.backArrow.resizable().frame(width: 20, height: 20)
                            .offset(x: 2)
                            .padding(8).background(Color.backgroundColor)
                            .cornerRadius(20)
                            .shadow(color: Color.onBackgroundColor, radius: 5)
                    }
                    
                    Spacer()
                    
                    Button {
                        viewModel.handle(.editTap)
                    } label: {
                        Image.options.resizable().frame(width: 16, height: 16)
                            .padding(12).background(Color.backgroundColor)
                            .cornerRadius(20)
                            .shadow(color: Color.onBackgroundColor, radius: 5)
                    }
                }.padding(.horizontal, 24).padding(.top, 12)
                
                Spacer()
                
                Text(viewModel.state.project.name)
                    .padding(.top, 12)
                
                Spacer()
                
                HStack(alignment: .center, spacing: 12) {
                    Text(viewModel.state.formatTime)
                       .frame(width: 50, height: 20, alignment: .leading)
                    Slider(value: $sliderValue, in: 0...viewModel.state.totalTime, step: 1)
                        .animation(.linear(duration: 0.1), value: viewModel.state.currentTime)
                        
                    Button {
                        viewModel.handle(.likeTap)
                    } label: {
                        (viewModel.state.liked ? Image("heart-filled_icon") : Image("heart_icon"))
                            .resizable().frame(width: 20, height: 20)
                    }
                }.padding(30)
                
                HStack(alignment: .center) {
                    if viewModel.state.isList {
                        Button {
                            viewModel.handle(.prevTap)
                        } label: {
                            Image.next.resizable().frame(width: 18, height: 18)
                                .rotationEffect(Angle(degrees: 180))
                                .padding(24).background(Color.backgroundColor)
                                .clipShape(Circle())
                                .shadow(color: Color.onBackgroundColor, radius: 5)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        viewModel.handle(.playTap)
                    } label: {
                        (viewModel.state.isPlaying ? Image.pause : Image.play)
                            .resizable().frame(width: 24, height: 27)
                            .padding(34).background(Color.onBackgroundColor)
                            .clipShape(Circle())
                            .shadow(color: Color.onBackgroundColor, radius: 5)
                    }
                    
                    Spacer()
                    
                    // warning stable fields
                    if viewModel.state.isList {
                        Button {
                            viewModel.handle(.nextTap)
                        } label: {
                            Image.next.resizable().frame(width: 18, height: 18)
                                .padding(24).background(Color.backgroundColor)
                                .clipShape(Circle())
                                .shadow(color: Color.onBackgroundColor, radius: 5)
                        }
                    }
                }.padding(.horizontal, 32)
            }.padding(.bottom, 24)
        }
        .navigationBarBackButtonHidden()
    }
}