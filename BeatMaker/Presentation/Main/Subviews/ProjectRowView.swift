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
                    .fill(.gray)
                    .frame(width: 50, height: 50)
                    .padding()
                
                // TODO: Реализовать подгрузку картинки
                Text(["🤪", "😎", "🤩", "🥳", "🥹", "😇", "🤯", "🤔"].randomElement() ?? "😎")
                    .frame(width: 35, height: 35, alignment: .center)
                    .blur(radius: parentViewModel.state.isEditing ? 3 : 0)
                    .padding()
                
                if parentViewModel.state.isEditing {
                    Image(systemName: "trash.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .gesture(
                            TapGesture()
                                .onEnded {
                                    parentViewModel.handle(
                                        .tapDeleteButton(
                                            projectId: project.id
                                        )
                                    )
                                }
                        )
                        .padding()
                }
            }
            
            Text(project.name)
                .padding()
            
            Spacer()
            
            Image(systemName: parentViewModel.state.isEditing ? "pencil.circle" : "play.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.black)
                .padding(.trailing, 50)
                .gesture(
                    TapGesture()
                        .onEnded {
                            parentViewModel.handle(.tapRightProjectButton(projectId: project.id))
                        }
                )
        }
        .padding(.leading)
    }
}
