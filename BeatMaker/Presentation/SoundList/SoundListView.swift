//
//  SoundListView.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

/// Constants for view
enum ConstantsForView {
    static let ImageSize: CGFloat = 40
    static let defaultEmoji = "\u{1f600}"
    static let defaultName = "sound"
}

struct SoundListView<ViewModel: AllSoundsViewModelProtocol>: View {
    
    @StateObject  var viewModel: ViewModel
    // useless propertie, just for mock
    @State  var username: String = ""
    
    var body: some View {
        
        ScrollView {
            
            addNewSoundsButton
            
            LazyVStack{
                ForEach(viewModel.state.allSounds) { sound in
                    soundCell(withSound: sound)
                        .contextMenu {
                            longTapOnSoundCellMenu
                        }
                }
            }
            .padding([.leading, .trailing])
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
    
    // button of adding new sound to list of all sounds
     var addNewSoundsButton: some View {
        Button {
            viewModel.handle(AllSoundsViewEvent.tapAddNewSoundButton)
        } label: {
            Text("Добавить звуки в библитеку всех звуков")
        }
        .modifier(CellBackground())
        .padding([.leading, .trailing])
    }
    
    // group of buttons from ContextMenu of sound cell
     var longTapOnSoundCellMenu: some View {
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
    
    // modifier of setting background of cell
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
