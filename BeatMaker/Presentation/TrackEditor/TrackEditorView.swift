//
//  TrackEditorView.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

enum PlayTrackViewEvent {
    case tapButton
}

struct TrackEditorViewState {
    var shouldShowPause: Bool
    var isPauseActive: String
    var choosenSoundId: String?
    var soundsArray: [Sound]
}

protocol TrackEditorViewModeling: ObservableObject {
    var state: TrackEditorViewState { get }
    
    func handle(_ event: PlayTrackViewEvent)
    
    func setSelectedSound(at index: UUID)
    
    func areUuidsSimilar(id1: UUID, id2: String) -> Bool
}

struct TrackEditorView<ViewModel: TrackEditorViewModeling>: View {
    
    @StateObject var viewModel: ViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    let tactCount: Int = 10
    var tickHeight: CGFloat = 20
    var tickWidth: CGFloat = 1
    var barHeight: CGFloat = 1
    
    @State var progressValue: Float = 0.5
    @State private var isSave: Bool = false
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        
        VStack {
            ProgressView(value: progressValue)
                .progressViewStyle(LinearProgressViewStyle(tint: .black))
                .padding(.horizontal, 40)
                .padding(.top, 15)
            
            
            HStack {
                Button(action: {
                }) {
                    Image(systemName: "chevron.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
                .padding(.leading,10)
                
                Spacer()
                ZStack {
                    HStack {
                        ForEach(1..<tactCount) { _ in
                            Rectangle()
                                .frame(width: tickWidth, height: tickHeight)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        Rectangle()
                            .frame(width: tickWidth, height: tickHeight)
                            .foregroundColor(.black)
                    }
                    
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.black)
                }
                .padding(.leading, 4)
                .padding(.trailing, 40)
            }
            .padding(.bottom, 10)
            
            Rectangle()
                .frame(width: 330, height: 330)
                .foregroundColor(.gray.opacity(50))
                .cornerRadius(12)
                .padding(.horizontal, 15)
                .shadow(color: Color.black.opacity(0.001), radius: 2, x: 0, y: 4)
            
            HStack {
                Text("Звуки")
                    .bold()
                
                Spacer()
                
                Button(action: {
                }) {
                    Text("редактировать")
                        .fontWeight(.thin)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 15)
            .padding(.top, 15)
            .padding(.bottom, 5)
            
            ZStack {
                Rectangle()
                    .frame(height: 100)
                    .foregroundColor(.gray.opacity(50))
                    .cornerRadius(12)
                    .padding(.horizontal, 15)
                    .shadow(color: Color.black.opacity(0.001), radius: 2, x: 0, y: 4)
                
                
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.state.soundsArray, id: \.self) {sound in
                        soundView(sound: sound) {
                            viewModel.setSelectedSound(at: sound.id)
                        }
                        .shadow(color: viewModel.areUuidsSimilar(id1: sound.id, id2: viewModel.state.choosenSoundId ?? "") ? .red.opacity(1) : .red.opacity(0), radius: 8, x: 0, y: 0)
                    }
                }
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
                        .foregroundColor(.black)
                    
                }
                Spacer()
                Button(action: {
                    viewModel.handle(.tapButton)
                }) {
                    Image(systemName: viewModel.state.isPauseActive)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button(action: {
                }) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 40)
                        .foregroundColor(.black)
                }
                
            }
            .padding(.horizontal, 70)
            .padding(.bottom, 15)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }),
            trailing:
                Button(action: {
                    isSave.toggle()
                }) {
                    Text("Визуализация")
                        .foregroundColor(.black)
                } )
        .navigationDestination(
            isPresented: $isSave) {
                PlayProjectView(viewModel: PlayProjectViewModel(project: Project(name: "Project 1", image: nil, upateDate: nil, bpm: 120, sounds: [], tracks: [])))
            }
    }
    
}


#Preview {
    TrackEditorView(viewModel: TrackEditorViewModel())
}

struct soundView: View {
    @State var sound:Sound
    var buttonClicked: (() -> Void)?
    var body: some View {
        VStack {
            Button(action: {
                buttonClicked?()
            }) {
                Text(sound.emoji)
            }
            Text(sound.name)
                .fontWeight(.thin)
                .font(.system(size: 11))
                .foregroundColor(.black)
        }
    }
}
