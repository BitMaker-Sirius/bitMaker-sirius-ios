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

                        Text(L10n.SoundsList.title)
                            .bold()

                        Spacer()
                    }
                    .padding(.horizontal, 15)

                    
                    ScrollView {
                        
//                        addNewSoundsButton
                        
                        LazyVStack {
                            ForEach(viewModel.state.allAvailableSounds, id: \.self) { sound in
                                soundCell(withSound: sound)
//                                    .contentShape(ContentShapeKinds.contextMenuPreview,
//                                                  Capsule(style: .continuous)
//                                    )
//                                    .contextMenu {
//                                        Button("Поменять эмодзи", systemImage: "music.note") {
//                                            viewModel.handle(.editSoundEmoji)
//                                        }
//                                        
//                                        Button("Поменять название", systemImage: "pencil") {
//                                            viewModel.handle(.editSoundName(sound: sound))
//                                        }
////                                        Button("Удалить", systemImage: "trash", role: .destructive) {
////                                            viewModel.handle(.deleteSound(sound: sound))
////                                        } 
//                                    }
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
        
        HStack(alignment: .center, spacing: 5) {
            
            Spacer()
            
            Text(sound.emoji ?? ConstantsForView.defaultEmoji)
                .font(.system(size: ConstantsForView.ImageSize))
            Spacer()
            HStack() {
                VStack(alignment: .listRowSeparatorLeading) {
                    Text(sound.name)
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(Color.onBackgroundColor)
                        .padding(.top, 10)
                    
                    Text(sound.storageUrl != nil ? (viewModel.state.project?.preparedSounds.contains(sound) == true ? "Нажмите для удаления" : "Нажмите для добавления") : "Загрузите звук")
                        .font(.system(size: 14))
                        .fontWeight(.thin)
                        .foregroundColor(Color.onBackgroundColor)
                    
                }
                
                Spacer()
                
                HStack(alignment: .center) {
                    Button {
                        if let url = sound.storageUrl {
                            viewModel.handle(SoundsListViewEvent.tapOnCellPlayButton(url: url))
                        } else {
                            viewModel.handle(SoundsListViewEvent.tapOnCellDownloadButton(sound: sound))
                        }
                        
                    } label: {
                        Image(systemName: viewModel.state.allAvailableSounds.first(where: { $0.id == sound.id })?.storageUrl != nil ? "play.circle" : "icloud.and.arrow.down")
                            .resizable()
                            .frame(width: sound.storageUrl != nil ?  ConstantsForView.ImageSize : 30, height: sound.storageUrl != nil ?  ConstantsForView.ImageSize : 30)
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
        .overlay(
            Capsule(style: .continuous)
                .stroke(viewModel.state.project?.preparedSounds.contains(sound) == true ? Color.backgroundColor : .clear, lineWidth: 3)
                )
        .onTapGesture {
            if sound.storageUrl != nil {
                viewModel.handle(SoundsListViewEvent.tapOnCell(sound: sound))
            }
        }
        .padding(.vertical, 2)
    }
}
