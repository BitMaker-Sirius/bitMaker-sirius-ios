//
//  ContentView.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

struct TrackListView: View {
    @StateObject var viewModel = TrackListViewModel()
    
    @State private var projectPath: [Project] = []
    @State private var selectedProject: Project?
    @State private var isShowingPlayProjectView = false
    @State private var isShowingEditProjectSheet = false
    
    var body: some View {
        NavigationStack(path: $projectPath) {
            VStack {
                LazyVStack {
                    ForEach(viewModel.projects) { project in
                        VStack {
                            HStack {
                                Text(project.name)
                                Spacer()
                                Button {
                                    selectedProject = project
                                    isShowingPlayProjectView = true
                                    print("Воспроизведение " + project.name)
                                } label: {
                                    Image(systemName: "play.circle")
                                }
                            }
                            Divider()
                        }
                        .padding()
                        .background()
                        .onTapGesture {
                            print("Tap on \(project.name)")
                            projectPath.append(project)
                        }
                        .onLongPressGesture {
                            selectedProject = project
                            isShowingEditProjectSheet = true
                            print("Long press on \(project.name)")
                        }
                    }
                }
                
                Spacer()
            }
            .navigationDestination(for: Project.self, destination: { project in
//                TrackEditorView(project: project)
                TrackEditorView(viewModel: TrackEditorViewModel())
            })
            .navigationDestination(isPresented: $isShowingPlayProjectView) {
                if let projectToPlay = selectedProject {
                    PlayProjectView(viewModel: PlayProjectViewModel(project: projectToPlay))
                        .navigationBarBackButtonHidden()
                }
            }
            .sheet(isPresented: $isShowingEditProjectSheet) {
                if let projectForEditing = selectedProject {
                    Text("Редактирование трека " + projectForEditing.name)
                        .presentationDetents([.medium, .large])
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TrackListView()
    }
}
