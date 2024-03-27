//
//  SoundListView.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

/// Constants for view
fileprivate enum ConstantsForView {
    static let ImageSize: CGFloat = 40
    static let defaultEmoji = "\u{1f600}"
    static let defaultName = "sound"
}

struct SoundsListView<ViewModel: SoundsListViewModel>: View {
    let projectId: String
    @ObservedObject var viewModel: ViewModel
    
    init(projectId: String, viewModel: ViewModel) {
        self.projectId = projectId
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            switch viewModel.state.indicatorViewState {
            case .display:
                VStack {
                    ZStack {
                        HStack {
                            Button {
                                viewModel.handle(.tapBackButton)
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .foregroundColor(Color.onBackgroundColor)
                            }
                            
                            Spacer()
                        }
                        
                        Spacer()

                        Text("Библиотека звуков")
                            .bold()

                        Spacer()
                    }
                    .padding(.horizontal, 15)

                    
                    ScrollView {
                        
                        addNewSoundsButton
                        
                        LazyVStack {
                            ForEach(viewModel.state.soundsList) { sound in
                                soundCell(withSound: sound)
                                    .contextMenu {
                                        Button("Поменять эмодзи", systemImage: "music.note") {
                                            viewModel.handle(.editSoundEmoji)
                                        }
                                        
                                        Button("Поменять название", systemImage: "pencil") {
                                            viewModel.handle(.editSoundName)
                                        }
                                        
                                        Button("Удалить", systemImage: "trash", role: .destructive) {
                                            viewModel.handle(.deleteSound(sound: sound))
                                        }
                                    }
                            }
                        }
                        .padding([.leading, .trailing])
                    }
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
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.handle(.onLoadData(projectId: projectId))
        }
    }
    
    @ViewBuilder
    func soundCell(withSound sound: Sound) -> some View {
        
        HStack {
            Spacer()
            
            Text(sound.emoji ?? ConstantsForView.defaultEmoji)
                .font(.system(size: ConstantsForView.ImageSize))
            
            Spacer()
            
            VStack {
                Text(sound.name)
                Text("Нажмите для добавления")
            }
            
            Spacer()
            
            Button {
                viewModel.handle(SoundsListViewEvent.tapOnCellPlayButton)
            } label: {
                Image(systemName: "play.circle")
                    .resizable()
                    .frame(width: ConstantsForView.ImageSize, height: ConstantsForView.ImageSize)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 75)
        .background(viewModel.state.project?.preparedSounds.contains(sound) == true ? Color.gray.opacity(0.1) : Color.gray.opacity(0.3))
        .clipShape(.rect(cornerRadius: 10))
        .onTapGesture {
            viewModel.handle(SoundsListViewEvent.tapAddToTrackButton(sound: sound))
        }
    }
    
    // button of adding new sound to list of all sounds
     var addNewSoundsButton: some View {
        Button {
            viewModel.handle(SoundsListViewEvent.tapAddNewSoundButton)
        } label: {
            Text("Добавить звуки в библитеку всех звуков")
        }
        .frame(maxWidth: .infinity)
        .frame(height: 75)
        .background(.gray.opacity(0.3))
        .clipShape(.rect(cornerRadius: 10))
        .padding([.leading, .trailing])
    }
}
