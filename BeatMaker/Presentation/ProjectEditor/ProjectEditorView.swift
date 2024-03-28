//
//  TrackEditorView.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

struct ProjectEditorView<ViewModel: ProjectEditorViewModel>: View {
    // Если передали nil, то создание трека, иначе редактирование
    let projectId: String?
    @ObservedObject var viewModel: ViewModel
    
    init(projectId: String?, viewModel: ViewModel) {
        self.projectId = projectId
        self.viewModel = viewModel
    }
    
    let tactCount: Int = 9
    var tickHeight: CGFloat = 20
    var tickWidth: CGFloat = 1
    var barHeight: CGFloat = 1
    
    @State private var proxyProjectName: String = ""
    @State private var proxyIsNeedProjectRenameAlert: Bool = false
    @State private var isVisualize: Bool = false
    @State private var isShowingUsedTrackView = false
    @State private var isShowingAllTrackListView = false
    @State private var isBlurEnabled = false
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        GeometryReader { _ in
            switch viewModel.state.indicatorViewState {
            case .display:
                VStack {
                    HStack {
                        Button {
                            viewModel.handle(.tapBackButton)
                            proxyIsNeedProjectRenameAlert = viewModel.state.isNeedProjectRenameAlert
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 30))
                                .foregroundColor(Color.onBackgroundColor)
                        }
                        
                        TextField(L10n.ProjectEditor.projectNamePlaceholder, text: $proxyProjectName)
                            .onChange(of: proxyProjectName, { oldValue, newValue in
                                viewModel.handle(.onChangeName(projectName: proxyProjectName))
                            })
                            .font(.system(size: 20))
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                        
                        Spacer()
                        
                        Button {
                            viewModel.handle(.tapVisualizationButton)
                            proxyIsNeedProjectRenameAlert = viewModel.state.isNeedProjectRenameAlert
                        } label: {
                            Image(systemName: "waveform")
                                .font(.system(size: 30))
                                .foregroundColor(Color.onBackgroundColor)
                        }
                    }
                    .padding(.horizontal, 15)
                    
                    ProgressView(value: viewModel.state.currentTime, total: viewModel.state.totalTime)
                        .progressViewStyle(LinearProgressViewStyle(tint: viewModel.state.isRecording ? .red : Color.onBackgroundColor))
                        .padding(.horizontal, 40)
                        .padding(.top, 15)
                    
                    VStack {
                        HStack {
                            Button(action: {
                                isShowingUsedTrackView.toggle()
                                isBlurEnabled.toggle()
                                viewModel.handle(.tapChervon)
                            }) {
                                Image(systemName: viewModel.state.chervonDirection)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.onBackgroundColor)
                            }
                            .padding(.leading,10)
                            
                            Spacer()
                            
                            ZStack {
                                HStack {
                                    ForEach(1..<tactCount) { _ in
                                        Rectangle()
                                            .frame(width: tickWidth, height: tickHeight)
                                            .foregroundColor(Color.onBackgroundColor)
                                        Spacer()
                                    }
                                    
                                    Rectangle()
                                        .frame(width: tickWidth, height: tickHeight)
                                        .foregroundColor(Color.onBackgroundColor)
                                }
                                
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(Color.onBackgroundColor)
                            }
                            .padding(.leading, 4)
                            .padding(.trailing, 40)
                        }
                        .padding(.bottom, 10)
                    }
                    
                    ZStack {
                        VStack {
                            SoundSettingsGraphView(soundSettingsGraphViewModel: SoundSettingsGraphViewModel(handle: viewModel.handleCoordinateChange))
                                .allowsHitTesting(!isShowingUsedTrackView)
                                .shadow(color: Color.onBackgroundColor.opacity(0.1), radius: 2, x: 0, y: 4)
                            
                            HStack {
                                Text(L10n.ProjectEditor.allSounds)
                                    .bold()
                                
                                Spacer()
                            }
                            .padding(.horizontal, 15)
                            .padding(.top, 15)
                            .padding(.bottom, 5)
                            
                            
                                
                                LazyVGrid(columns: columns) {
                                    ForEach(viewModel.state.project?.preparedSounds ?? viewModel.state.soundsArray, id: \.self) {sound in
                                        ButtomSoundView(sound: sound) {
                                            viewModel.setSelectedSound(at: sound.id)
                                        }
                                        .shadow(color: viewModel.areUuidsSimilar(id1: sound.id, id2: viewModel.state.choosenSoundId ?? "") ? Color.onBackgroundColor.opacity(0.6) : Color.onBackgroundColor.opacity(0), radius: 12, x: 0, y: 0)
                                        .scaleEffect(viewModel.areUuidsSimilar(id1: sound.id, id2: viewModel.state.choosenSoundId ?? "") ? 1.1 : 1)
                                    }
                                    .padding(.top, 5)
                                    Button(action: {
                                        viewModel.handle(.tapAddSounds)
                                    }) {
                                        Image(systemName: "plus")
                                            .font(.system(size: 35))
                                            .foregroundColor(Color.onBackgroundColor)
                                    }
                                    .padding(7)
                                    .background(Color.backgroundColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(color: Color.onBackgroundColor, radius: 1)
                                    .offset(y: 3)
                                }
                                .padding(25)
                                .background(Color.backgroundColor)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .allowsHitTesting(!isShowingUsedTrackView)
                                .padding(.horizontal, 25)
                            
                            
                            Spacer()
                            
                            HStack {
                                Button(action: {
                                    viewModel.handle(.recordTap)
                                }) {
                                    Image(systemName: "record.circle")
                                        .font(.system(size: 40))
                                        .foregroundColor(viewModel.state.isRecording ? .red : Color.onBackgroundColor)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.handle(.tapPlay)
                                }) {
                                    Image(systemName: viewModel.state.pauseState)
                                        .font(.system(size: 60))
                                        .foregroundColor(Color.onBackgroundColor)
                                }
                                .frame(width: 50, height: 50)
                                
                                Spacer()
                            }
                            .allowsHitTesting(!isShowingUsedTrackView)
                            .padding(.horizontal, 40)
                            .padding(.bottom, 15)
                        }
                        .blur(radius: isShowingUsedTrackView ? 3 : 0)
                        
                        if isShowingUsedTrackView {
                            UsedTrackView(viewModel: viewModel.state.usedTrackViewModel, totalTime: viewModel.state.totalTime)
                                .onTapGesture {
                                    
                                }
                        }
                    }
                    .background(Color.backgroundColorForScreen)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        if self.isShowingUsedTrackView == true {
                            viewModel.handle(.tapChervon)
                        }
                        self.isShowingUsedTrackView = false
                    }
                }
                .onAppear {
                    guard let projectName = viewModel.state.project?.name else {
                        return
                    }
                    
                    proxyProjectName = projectName
                }
            case .loading:
                ProgressView()
            case .error:
                HStack {
                    Button {
                        viewModel.handle(.tapBackButton)
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
        .alert(L10n.ProjectEditor.Alert.changeProjectName, isPresented: $proxyIsNeedProjectRenameAlert) {
            TextField(L10n.ProjectEditor.projectNamePlaceholder, text: $proxyProjectName)
                .onChange(of: proxyProjectName, { oldValue, newValue in
                    viewModel.handle(.onChangeName(projectName: proxyProjectName))
                })
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            
            Button(L10n.ProjectEditor.Alert.accept) { viewModel.handle(.onCheckName) }
        }
        .ignoresSafeArea(.keyboard)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.handle(.onLoadData(projectId: projectId))
        }
    }
}

//TODO: поставить заглушки на другие звуки во время записи
