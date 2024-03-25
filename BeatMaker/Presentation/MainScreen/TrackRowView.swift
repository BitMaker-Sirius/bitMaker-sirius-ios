//
//  TrackRowView.swift
//  BeatMaker
//
//  Created by 1 on 25.03.2024.
//

import SwiftUI

struct TrackRow: View {
    var mainScreenViewModel: any MainScreenViewObservable
    var trackNumber: Int
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 50, height: 50)
                    .padding()
                Text("😎")
                    .frame(width: 35, height: 35, alignment: .center)
                    .padding()
            }
            Text("Трек \(trackNumber)")
                .padding()
            Spacer()
            Image(systemName: "play.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.black)
                .padding(.trailing, 50)
                .gesture(
                    TapGesture()
                        .onEnded {
                            mainScreenViewModel.handle(.tapPlayTrackButton)
                        }
                )
        }
        .padding(.leading)
    }
}
