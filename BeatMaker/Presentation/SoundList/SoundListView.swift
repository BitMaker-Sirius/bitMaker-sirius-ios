//
//  SoundListView.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

/// some hardcode
enum ConstantsForView {
    static let ImageSize: CGFloat = 40
    static let defaultEmoji = "\u{1f600}"
    static let defaultName = "sound"
}

struct SoundListView<ViewModel: AllSoundsViewModelProtocol>: View {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        
        ScrollView {
            Button {
                viewModel.handle(AllSoundsViewEvent.tapAddNewSoundButton)
            } label: {
                Text("Добавить звуки в библитеку всех звуков")
            }
            .modifier(CellBackground())
            .padding([.leading, .trailing])
            
            LazyVStack{
                ForEach(viewModel.state.allSounds) { sound in
                    soundCell(withSound: sound)
                        .contextMenu {
                            Group {
                                Button("Поменять эмодзи", systemImage: "music.note") {
                                    viewModel.handle(.editSoundEmoji)
                                }
                                
                                Button("Поменять название", systemImage: "pencil") {
                                    viewModel.handle(.editSoundName)
                                }
                                
                                Button("Удалить", systemImage: "trash", role: .destructive) {
                                    viewModel.handle(.deleteSound)
                                }
                            }
                        }
                }
            }
            .padding([.leading, .trailing])
        }
    }
    
    @State private var username: String = ""
    
    @ViewBuilder
    func soundCell(withSound sound: Sound) -> some View {
        
        HStack {
            
            Spacer()
            
            Text(sound.emoji ?? ConstantsForView.defaultEmoji)
                .font(.system(size: ConstantsForView.ImageSize))
            
            Spacer()
            
            VStack {
                Text(sound.name ?? ConstantsForView.defaultName)
                Text("Нажмите для добавления")
            }
            
            Spacer()
            
            Button {
                viewModel.handle(AllSoundsViewEvent.tapOnCellPlayButton)
            } label: {
                Image(systemName: "play.circle")
                    .resizable()
                    .frame(width: ConstantsForView.ImageSize, height: ConstantsForView.ImageSize)
            }
            
            Spacer()
        }
        .modifier(CellBackground())
        .onTapGesture {
            viewModel.handle(AllSoundsViewEvent.tapOnCell)
        }
    }
    
    struct CellBackground: ViewModifier {
        func body(content: Content) -> some View {
            content
                .frame(maxWidth: .infinity)
                .frame(height: 75)
                .background(.gray.opacity(0.3))
                .background(.gray.opacity(0.3))
                .clipShape(.rect(cornerRadius: 10))
        }
    }
}

//struct AllSoundsView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        NavigationStack {
//            AllSoundsView(viewModel: AllSoundsViewModel(addedToTrackSounds: []))
//                .navigationBarTitle("Библиотека всех доступных звуков")
//                .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}


//struct SoundListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SoundListView(editorViewModel: TrackEditorViewModel())
//    }
//}
