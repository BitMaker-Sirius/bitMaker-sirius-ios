//
//  UsedSoundsListView.swift
//  BeatMaker
//
//  Created by Тася Галкина on 25.03.2024.
//

import Foundation
import SwiftUI

enum UsedTrackViewEvent {
    case tapButton
}

struct UsedTrackViewState {
    var shouldDeleteTrack: Bool = false
    var isDelete: String = "trash.fill"
    var choosenSoundId: String? = nil
    var usedTacksArray: [Track] = []
}

protocol UsedTrackViewModeling: ObservableObject {
    var state: UsedTrackViewState {get }
    func shouldDeleteTrack(id: String)
    func updateTracks(_ tracks: [Track])
}

struct UsedTrackView<ViewModel: UsedTrackViewModeling>: View {
    
    @ObservedObject
    var viewModel: ViewModel
    let totalTime: Double
    
    var body: some View {
        VStack {
            VStack {
                if viewModel.state.usedTacksArray.isEmpty {
                    Text("Записанных звуков нет")
                } else {
                    ScrollView {
                        ForEach(viewModel.state.usedTacksArray, id: \.self) { track in
                            HStack {
                                TrackView(sound: track.sound ?? Sound(audioFileId: nil, name: "hype"))
                                
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 5)
                                            .frame(height: 35)
                                            .foregroundColor(.gray.opacity(0.3))
                                        
                                            ForEach(track.points, id: \.self) { point in
                                                RoundedRectangle(cornerRadius: 5)
                                                    .frame(width: 5, height: 35)
                                                    .foregroundColor(.black)
                                                    .offset(x: CGFloat(point.startTime / totalTime) * (geometry.size.width), y: 0)
                                            }
                                        
                                    
                                    }
                                }
                                .frame(height: 35)
                                .padding(.horizontal, 5)
                                
                                
                                Button(action: {
                                    print("trash")
                                    viewModel.shouldDeleteTrack(id: track.id)
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
            .frame(minHeight: 10)
            .background(Color.backgroundColorForScreen)
            .cornerRadius(15)
            .shadow(radius: 2)
            Spacer()
        }
    }
}

struct UsedTrackView_Previews: PreviewProvider {
    static var previews: some View {
        UsedTrackView(viewModel: UsedTrackViewModel(), totalTime: 9)
    }
}
