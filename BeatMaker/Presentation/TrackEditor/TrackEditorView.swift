//
//  TrackEditorView.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

struct TrackEditorView: View {
    @StateObject var viewModel = TrackEditorViewModel()
    
    //@Published var track: Track
    
    private var tactCount: Int = 10
    private var tickHeight: CGFloat = 20
    private var tickWidth: CGFloat = 1
    private var barHeight: CGFloat = 1
    
    @State private var progressValue: Float = 0.5
    @State private var isSave: Bool = false
    
    
    
    
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
                
                VStack {
                    HStack
                    {
                        soundView(text: "😋", name: "барабан")
                        Spacer()
                        soundView(text: "😋", name: "барабан")
                        Spacer()
                        soundView(text: "😋", name: "барабан")
                        Spacer()
                        soundView(text: "😋", name: "барабан")
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 10)
                    
                    HStack
                    {
                        soundView(text: "😋", name: "барабан")
                        Spacer()
                        soundView(text: "😋", name: "барабан")
                        Spacer()
                        soundView(text: "😋", name: "барабан")
                        Spacer()
                        soundView(text: "😋", name: "барабан")
                    }
                    .padding(.horizontal, 25)
                }
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
                }) {
                    Image(systemName: "pause.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 40)
                        .foregroundColor(Color("text_color"))
                    
                }
                Spacer()
                Button(action: {
                    print("add new sounds")
                }) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
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


struct TrackEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TrackEditorView()
    }
}

struct soundView: View {
    @State var text:String
    @State var name:String
    var body: some View {
        VStack {
            Button(action: {
                print("stop music")
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
