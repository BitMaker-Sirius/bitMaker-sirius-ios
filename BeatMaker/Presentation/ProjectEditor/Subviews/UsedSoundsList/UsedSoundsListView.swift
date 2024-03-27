//
//  UsedSoundsListView.swift
//  BeatMaker
//
//  Created by Тася Галкина on 25.03.2024.
//

import Foundation
import SwiftUI

enum UsedTreckViewEvent {
    case tapButton
}

struct UsedTreckViewState {
    var shouldDeleteTreck: Bool = false
    var isDelete: String = "trash.fill"
    var choosenSoundId: String? = nil
    var usedSoundsArray: [Track] = []
}

protocol UsedTreckViewModeling: ObservableObject {
    var state: UsedTreckViewState {get }
    func shouldDeleteTreck(id: String)
    func updateTracks(_ tracks: [Track])
}

struct UsedTreckView<ViewModel: UsedTreckViewModeling>: View {
    
    @ObservedObject
    var viewModel: ViewModel
    
    
    var body: some View {
        VStack {
            VStack {
                if viewModel.state.usedSoundsArray.isEmpty {
                    Text("Записанных звуков нет")
                } else {
                    ScrollView {
                        ForEach(viewModel.state.usedSoundsArray, id: \.self) { track in
                            HStack {
                                TrackView(sound: track.sound ?? Sound(audioFileId: nil, name: "hype"))
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(height: 35)
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 0)
                                    
                                    HStack {
                                        ForEach(0..<8) {_ in
                                            RoundedRectangle(cornerRadius: 5)
                                                .frame(width: 10, height: 35)
                                                .foregroundColor(.black)
                                            Spacer()
                                        }
                                    }
                                }
                                .padding(.leading, 5)
                                .padding(.trailing, 5)
                                
                                
                                Button(action: {
                                    print("trash")
                                    viewModel.shouldDeleteTreck(id: track.id)
                                }) {
                                    HStack {
                                        Image(systemName: "trash")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(Color.onBackgroundColor)
                                    }
                                }
                                
                            }
                            .onTapGesture {
                                
                            }
                        }
                    }
                }
            }
            .padding()
            .frame(idealHeight: 0, maxHeight: 300)
            .background(Color.backgroundColorForScreen)
            .cornerRadius(15)
            .shadow(radius: 2)
            Spacer()
        }
    }
}

struct UsedTreckView_Previews: PreviewProvider {
    static var previews: some View {
        UsedTreckView(viewModel: UsedTreckViewModel())
    }
}
