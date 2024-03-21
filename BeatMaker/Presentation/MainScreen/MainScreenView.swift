//
//  MainScreenView.swift
//  BeatMaker
//
//  Created by 1 on 21.03.2024.
//

import SwiftUI

import SwiftUI

struct MainScreenView: View {
    var body: some View {
        ScrollView {
            VStack {
                HalfScreenRow()
                
                Text("Мои треки")
                    .font(.largeTitle)
                    .bold()
                    .padding(.leading, -150)
                Spacer()
                
                ForEach(1..<11) { index in
                    TrackRow(trackNumber: index)
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height)
    }
}

struct MainScreenPreviews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}

struct HalfScreenRow: View {
    var body: some View {
        ZStack {
            Color.red
                .frame(height: UIScreen.main.bounds.height / 2 + 45)
            VStack {
                Spacer()
                Button(action: {
                    // Play track action
                }) {
                    HStack {
                        Image(systemName: "arrowtriangle.right.fill")
                            .foregroundColor(.black)
                            .padding(.leading)
                        Text("Play track")
                            .bold()
                            .foregroundStyle(.black)
                            .padding()
                            
                    }
                    .background(Color.white)
                    .cornerRadius(30)
                }
                .padding(.vertical, UIScreen.main.bounds.height / 4)
            }
        }
        .padding(.top, -45)
    }
}

struct TrackRow: View {
    var trackNumber: Int
    
    var body: some View {
        HStack {
//            Circle()
//                .fill(Color.green)
//                .frame(width: 40, height: 40)
//                .padding()
//            Text("Track \(trackNumber)")
//                .padding()
//            Spacer()
            Text("😎")
                .frame(width: 35, height: 35, alignment: .center)
                .padding()
                .overlay(
                    Circle()
                        .stroke(Color.green, lineWidth: 4)
                        .padding(6)
                )
            Text("Трек\(trackNumber)")
                .padding()
            Spacer()
        }
        .padding(.leading)
    }
}
