//
//  PlayTrackView.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

struct PlayTrackView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: PlayTrackViewModel
    
    var body: some View {
        ZStack {
            Color.background_color.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center) {
                    Button(action: { dismiss() }) {
                        Image.back_arrow.resizable().frame(width: 20, height: 20)
                            .offset(x: 2)
                            .padding(8).background(Color.background_color)
                            .cornerRadius(20)
                            .shadow(color: Color.onBackgroundColor_color, radius: 5)
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image.options.resizable().frame(width: 16, height: 16)
                            .padding(12).background(Color.background_color)
                            .cornerRadius(20)
                            .shadow(color: Color.onBackgroundColor_color, radius: 5)
                    }
                }.padding(.horizontal, 24).padding(.top, 12)
                
                Spacer()
                
                Text(viewModel.track.name)
                    .padding(.top, 12)
                
                Spacer()
                
                HStack(alignment: .center, spacing: 12) {
                    Text(viewModel.formatTime())
                       .frame(width: 50, height: 20, alignment: .center)
                    Slider(value: $viewModel.currentTime, in: 0...viewModel.totalDuration, step: 1)    .animation(.linear(duration: 0.1), value: viewModel.currentTime)
                    
                    Button(action: { viewModel.liked.toggle() }) {
                        (viewModel.liked ? Image("heart-filled_icon") : Image("heart_icon"))
                            .resizable().frame(width: 20, height: 20)
                    }
                }.padding(30)
                
                HStack(alignment: .center) {
                    Button {
                        
                    } label: {
                        Image.next.resizable().frame(width: 18, height: 18)
                            .rotationEffect(Angle(degrees: 180))
                            .padding(24).background(Color.background_color)
                            .clipShape(Circle())
                            .shadow(color: Color.onBackgroundColor_color, radius: 5)
                    }
                    
                    Spacer()
                    
                    Button {
                        viewModel.isPlaying.toggle()
                    } label: {
                        (viewModel.isPlaying ? Image.pause : Image.play)
                            .resizable().frame(width: 24, height: 27)
                            .padding(34).background(Color.onBackgroundColor_color)
                            .clipShape(Circle())
                            .shadow(color: Color.onBackgroundColor_color, radius: 5)
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image.next.resizable().frame(width: 18, height: 18)
                            .padding(24).background(Color.background_color)
                            .clipShape(Circle())
                            .shadow(color: Color.onBackgroundColor_color, radius: 5)
                    }
                }.padding(.horizontal, 32)
            }.padding(.bottom, 24)
        }
    }
}

struct PlayTrackView_Previews: PreviewProvider {
    static var previews: some View {
        PlayTrackView(viewModel: PlayTrackViewModel(track: Track(name: "Track name", description: "description")))
    }
}
