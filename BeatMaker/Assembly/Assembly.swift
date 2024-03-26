//
//  Assembly.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 24.03.2024.
//

import SwiftUI
import RealmSwift

final class Assembly {
    // MARK: Views
    
    func rootView() -> RootView {
        RootView()
    }
    
    func mainView() -> MainView<some MainViewModel> {
        MainView(viewModel: mainViewModel)
    }
    
    func projectEditorView(projectId: String?) -> TrackEditorView<some TrackEditorViewModeling> {
        TrackEditorView(projectId: projectId, viewModel: self.projectEditorModel)
    }
    
    // MARK: ViewModels
    
    private lazy var mainViewModel: MainViewModelImp = {
        MainViewModelImp(
            projectsListProvider: projectsListProvider,
            projectPlaybackService: projectPlaybackService
        )
    }()
    
    private lazy var projectEditorModel: TrackEditorViewModel = {
        TrackEditorViewModel()
    }()
    
    // MARK: Providers
    
    private lazy var projectProvider: ProjectProvider = {
        ProjectProviderImp(projectDataStorage: projectDataStorage)
    }()
    
    private lazy var projectsListProvider: ProjectsListProvider = {
        ProjectsListProviderImp(projectDataStorage: projectDataStorage)
    }()
    
    private lazy var soundsListProvider: SoundsListProvider = {
        SoundsListProviderImp(soundDataStorage: soundDataStorage)
    }()
    
    // MARK: Services
    
    private lazy var projectPlaybackService: any ProjectPlaybackService = {
      ProjectPlaybackServiceImp(trackPlaybackService: trackPlaybackService)
    }()
    
    private lazy var trackPlaybackService: any TrackPlaybackService = {
        TrackPlaybackServiceImp(soundPlaybackService: soundPlaybackService)
    }()
    
    private lazy var soundPlaybackService: any SoundPlaybackService = {
        SoundPlaybackServiceImp()
    }()
    
    // MARK: DataStorages
    
    private lazy var projectDataStorage: any ProjectDataStorage = {
        ProjectDataStorageImp(realmManager: realmManager)
    }()
    
    private lazy var soundDataStorage: any SoundDataStorage = {
        SoundDataStorageImp(realmManager: realmManager)
    }()
    
    private lazy var aundioDataStorage: any AudioDataStorage = {
        AudioDataStorageImp()
    }()
    
    private lazy var imageDataStorage: any ImageDataStorage = {
        ImageDataStorageImp()
    }()
    
    // MARK: DataManagers
    
    private lazy var realmManager: Realm? = {
        try? Realm()
    }()
    
    // FileManager
    // NetworkManager
}
