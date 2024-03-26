//
//  TrackRowView.swift
//  BeatMaker
//
//  Created by 1 on 25.03.2024.
//

import SwiftUI

struct ProjectRow<ParentViewModel: MainViewModel>: View {
    @ObservedObject var parentViewModel: ParentViewModel
    @ObservedObject var project: Project
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 50, height: 50)
                    .padding()
                // TODO: Реализовать подгрузку картинки
                Text(["🤪", "😎", "🤩", "🥳", "🥹", "😇", "🤯", "🤔"].randomElement() ?? "😎")
                    .frame(width: 35, height: 35, alignment: .center)
                    .padding()
            }
            
            Text(project.name)
                .padding()
            
            Spacer()
            
            Image(systemName: project.isPlaying ? "stop.circle" : "play.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.black)
                .padding(.trailing, 50)
                .gesture(
                    TapGesture()
                        .onEnded {
                            parentViewModel.handle(.tapPlayProjectButton(projectId: project.id))
                        }
                )
        }
        .padding(.leading)
    }
}
