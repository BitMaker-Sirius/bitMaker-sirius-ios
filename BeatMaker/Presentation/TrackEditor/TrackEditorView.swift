//
//  TrackEditorView.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

struct TrackEditorView<ViewModel: TrackEditorViewModeling>: View {
    // Если передали nil, то создание трека, иначе редактирование
    var projectId: String?
    @StateObject var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss
    
    let tactCount: Int = 10
    var tickHeight: CGFloat = 20
    var tickWidth: CGFloat = 1
    var barHeight: CGFloat = 1
    
    @State  var progressValue: Float = 0.5
    @State private var isVisualize: Bool = false
    @State private var isShowingUsedTreckView = false
    @State private var isShowingAllTreckListView = false
    @State private var isBlurEnabled = false
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        
        VStack {
            ProgressView(value: progressValue)
                .progressViewStyle(LinearProgressViewStyle(tint: Color.onBackgroundColor))
                .padding(.horizontal, 40)
                .padding(.top, 15)
            
            VStack {
                HStack {
                    Button(action: {
                        isShowingUsedTreckView.toggle()
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
                    
                    SoundSettingsGraphView(soundSettingsGraphViewModel: SoundSettingsGraphViewModel())
                        .allowsHitTesting(!isShowingUsedTreckView)
                        .shadow(color: Color.onBackgroundColor.opacity(0.1), radius: 2, x: 0, y: 4)

                    HStack {
                        Text("Звуки")
                            .bold()
                        
                        Spacer()
                        
                        Button(action: {
                        }) {
                            Text("редактировать")
                                .fontWeight(.thin)
                                .foregroundColor(Color.onBackgroundColor)
                        }
                        .allowsHitTesting(!isShowingUsedTreckView)
                    }
                    .padding(.horizontal, 15)
                    .padding(.top, 15)
                    .padding(.bottom, 5)
                    
                    ZStack {
                        Rectangle()
                            .frame(height: 100)
                            .foregroundColor(Color.backgroundColor)
                            .cornerRadius(12)
                            .padding(.horizontal, 15)
                            .shadow(color: Color.onBackgroundColor.opacity(0.1), radius: 2, x: 0, y: 4)
                        
                        
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.state.soundsArray, id: \.self) {sound in
                                ButtomSoundView(sound: sound) {
                                    viewModel.setSelectedSound(at: sound.id)
                                }
                                .shadow(color: viewModel.areUuidsSimilar(id1: sound.id, id2: viewModel.state.choosenSoundId ?? "") ? Color.onBackgroundColor.opacity(1) : Color.onBackgroundColor.opacity(0), radius: 8, x: 0, y: 0)
                            }
                            .padding(.top, 5)
                        }
                        .allowsHitTesting(!isShowingUsedTreckView)
                        .padding(.horizontal, 25)
                    }
                    
                    Spacer()
                    HStack {
                        Button(action: {
                        }) {
                            Image(systemName: "stop.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.onBackgroundColor)
                            
                        }
                        Spacer()
                        
                        Button(action: {
                            viewModel.handle(.tapButton)
                        }) {
                            Image(systemName: viewModel.state.pauseState)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.onBackgroundColor)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            isShowingAllTreckListView.toggle()
                        }) {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 40)
                                .foregroundColor(Color.onBackgroundColor)
                        }
                        
                    }
                    .allowsHitTesting(!isShowingUsedTreckView)
                    .padding(.horizontal, 70)
                    .padding(.bottom, 15)
                }
                .blur(radius: isShowingUsedTreckView ? 3 : 0).animation(.default)
                
                if isShowingUsedTreckView {
                    UsedTreckView(viewModel: UsedTreckViewModel())
                        .onTapGesture {
                            
                        }
                        .padding(.horizontal, 50)
                }
            }
            .background(Color.backgroundColorForScreen)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                if self.isShowingUsedTreckView == true {
                    viewModel.handle(.tapChervon)
                }
                self.isShowingUsedTreckView = false
                
            }
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(Color.onBackgroundColor)
        } ,
                            trailing: Button(action: {
            isVisualize.toggle()
        }) {
            Text("Визуализация")
                .foregroundColor(Color.onBackgroundColor)
        } )
        .navigationDestination(isPresented: $isVisualize) {
            PlayProjectView(projectId: "0", viewModel: PlayProjectViewModel(project: Project(metronomeBpm: 120, name: "HYPEEEE")))
        }
        .navigationDestination(isPresented: $isShowingAllTreckListView) {
            SoundListView(viewModel: SoundListViewModel(editorViewModel: TrackEditorViewModel(), addedToTrackSounds: []))
        }
    }
}

#Preview {
    TrackEditorView(viewModel: TrackEditorViewModel())
}

//TODO: поставить заглушки на другие звуки во время записи
