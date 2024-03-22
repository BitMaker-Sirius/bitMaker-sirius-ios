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
    var choosenSoundId: String?  
//    var chooseSound: [Bool]
//    var chooseSound: UUID
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
    
     let tactCount: Int = 10
     var tickHeight: CGFloat = 20
     var tickWidth: CGFloat = 1
     var barHeight: CGFloat = 1
    
    @State  var progressValue: Float = 0.5
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
                .progressViewStyle(LinearProgressViewStyle(tint: Color("text_color")))
                .padding(.horizontal, 50)
                .padding(.top, 15)
            
            
            HStack(spacing: 0) {
                Button(action: {
                    print("show all used sounds")
                }) {
                    Image(systemName: "chevron.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("text_color"))
                }
                .padding(.leading, 15)
                
                Spacer()
                ZStack() {
                    HStack {
                        ForEach(1..<tactCount) { _ in
                            Rectangle()
                                .frame(width: tickWidth, height: tickHeight)
                                .foregroundColor(Color("text_color"))
                            Spacer()
                        }
                        
                        Rectangle()
                            .frame(width: tickWidth, height: tickHeight)
                            .foregroundColor(Color("text_color"))
                    }
                    .padding(.leading, 8)
                    .padding(.trailing, 50)
                    
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(Color("text_color"))
                        .padding(.leading, 8)
                        .padding(.trailing, 50)
                }
            }
            .padding(.bottom, 10)
            
            Rectangle()
                .frame(width: 330, height: 330)
                .foregroundColor(Color("light_blue").opacity(50))
                .cornerRadius(12)
                .padding(.horizontal, 15)
                .shadow(color: Color.black.opacity(0.001), radius: 2, x: 0, y: 4)
            
            HStack {
                Text("Звуки")
                    .bold()
                
                Spacer()
                
                Button(action: {
                    print("edit sounds")
                }) {
                    Text("редактировать")
                        .fontWeight(.thin)
                        .foregroundColor(Color("text_color"))
                }
            }
            .padding(.horizontal, 15)
            .padding(.top, 15)
            .padding(.bottom, 5)
            
            ZStack {
                Rectangle()
                    .frame(height: 100)
                    .foregroundColor(Color("light_blue").opacity(50))
                    .cornerRadius(12)
                    .padding(.horizontal, 15)
                    .shadow(color: Color.black.opacity(0.001), radius: 2, x: 0, y: 4)
                
                
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.state.soundsArray, id: \.self) {sound in
                        soundView(text: sound.emoji, name: sound.name) {
                            viewModel.setSelectedSound(at: sound.id)
                            }
                        .shadow(color: viewModel.areUuidsSimilar(id1: sound.id, id2: viewModel.state.choosenSoundId ?? "") ? Color("main_blue").opacity(1) : Color("main_blue").opacity(0), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 25)
            }
            
            Spacer()
            HStack {
                Button(action: {
                    print("record music")
                }) {
                    Image(systemName: "stop.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("text_color"))
                    
                }
                Spacer()
                Button(action: {
                    print("stop music")
                    viewModel.handle(.tapButton)
                }) {
                    if viewModel.state.shouldShowPause {
                        Image(systemName: "pause.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color("text_color"))
                    } else {
                        Image(systemName: "play.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color("text_color"))
                    }
                }
                
                Spacer()
                
                Button(action: {
                    print("add new sounds")
                }) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 40)
                        .foregroundColor(Color("text_color"))
                }
                
            }
            .padding(.horizontal, 70)
            .padding(.bottom, 15)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Image(systemName: "chevron.left"),
                            trailing: Button(action: {
            isSave.toggle()
        }) {
            Text("Сохранить")
                .foregroundColor(Color("text_color"))
        } )
        .navigationDestination(
            isPresented: $isSave) {
                PlayTrackView(track: Track(name: "", description: ""))
            }
    }
    
}


#Preview {
    TrackEditorView(viewModel: TrackEditorViewModel())
}

struct soundView: View {
    @State var text:String
    @State var name:String
    var buttonClicked: (() -> Void)?
    var body: some View {
        VStack {
            Button(action: {
                print("change music")
                buttonClicked?()
            }) {
                Text(text)
            }
            Text(name)
                .fontWeight(.thin)
                .font(.system(size: 11))
                .foregroundColor(Color("text_color"))
        }
    }
}
