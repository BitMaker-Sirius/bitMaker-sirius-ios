//
//  PlayTrackView.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

struct PlayProjectView<ViewModel: PlayProjectViewModel>: View {
    let projectId: String
    @ObservedObject var viewModel: ViewModel
    
    init(projectId: String, viewModel: ViewModel) {
        self.projectId = projectId
        self.viewModel = viewModel
    }
    
    @State private var sliderValue: CGFloat = .zero {
        didSet {
            
        }
    }
    
    var body: some View {
        ZStack {
            switch viewModel.state.indicatorViewState {
            case .display:
                ZStack {
                    Color.backgroundColor.edgesIgnoringSafeArea(.all)
                    
                    VStack(alignment: .center, spacing: 0) {
                        HStack {
                            Button {
                                viewModel.handle(.backTap)
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .foregroundColor(Color.onBackgroundColor)
                            }
                            
                            Spacer()
                            
                            Text(viewModel.state.project?.name ?? "")
                                .bold()
                            
                            Spacer()
                            
                            Button {
                                viewModel.handle(.editTap)
                            } label: {
                                Image(systemName: "pencil")
                                    .font(.title2)
                                    .foregroundColor(Color.onBackgroundColor)
                            }
                        }
                        .padding(.horizontal, 15)
                        
                        Spacer()
                        
                        Text(viewModel.state.project?.name ?? "")
                            .padding(.top, 12)
                        
                        Spacer()
                        
                        HStack(alignment: .center, spacing: 12) {
                            Text(viewModel.state.formatTime)
                                .frame(width: 50, height: 20, alignment: .leading)
                            ProgressView(value: viewModel.state.currentTime, total: viewModel.state.totalTime)
                                .progressViewStyle(LinearProgressViewStyle())
                                .padding()
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
                                    Image(systemName: "backward.end.circle")
                                        .font(.system(size: 40))
                                        .foregroundColor(Color.onBackgroundColor)
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.handle(.playTap)
                            }) {
                                (viewModel.state.isPlaying ? Image(systemName: "stop.fill") : Image(systemName: "play.fill"))
                                    .font(.system(size: 60))
                                    .foregroundColor(Color.onBackgroundColor)
                            }
                            
                            Spacer()
                            
                            // warning stable fields
                            if viewModel.state.isList {
                                Button {
                                    viewModel.handle(.nextTap)
                                } label: {
                                    Image(systemName: "forward.end.circle")
                                        .font(.system(size: 40))
                                        .foregroundColor(Color.onBackgroundColor)
                                }
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 15)
                }
            case .loading:
                ProgressView()
            case .error:
                HStack {
                    Button {
                        viewModel.handle(.backTap)
                    } label: {
                        Image(systemName: "arrowshape.backward.circle")
                            .font(.system(size: 40))
                    }
                    
                    Button {
                        viewModel.handle(.onLoadData(projectId: projectId))
                    } label: {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(.system(size: 40))
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.handle(.onLoadData(projectId: projectId))
        }
    }
}
