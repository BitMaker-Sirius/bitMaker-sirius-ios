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
    
    func projectEditorView(projectId: String?) -> ProjectEditorView<some ProjectEditorViewModel> {
        ProjectEditorView(projectId: projectId, viewModel: self.projectEditorViewModel)
    }
    
    func playProjectView(projectId: String) -> PlayProjectView<some PlayProjectViewModel> {
        PlayProjectView(projectId: projectId, viewModel: self.playProjectViewModel)
    }
    
    func soundsListView(projectId: String) -> SoundsListView<some SoundsListViewModel> {
        SoundsListView(projectId: projectId, viewModel: self.soundsListViewModel)
    }
    
    // MARK: ViewModels
    
    private lazy var mainViewModel: MainViewModelImp = {
        MainViewModelImp(
            projectsListProvider: projectsListProvider,
            projectPlaybackService: projectPlaybackService,
            fileManager: fileManager
        )
    }()
    
    private lazy var projectEditorViewModel: ProjectEditorViewModelImp = {
        ProjectEditorViewModelImp(projectProvider: projectProvider, fileManager: fileManager)
    }()
    
    private lazy var playProjectViewModel: PlayProjectViewModelImp = {
        PlayProjectViewModelImp(
            projectProvider: projectProvider,
            projectsListProvider: projectsListProvider, 
            projectPlaybackService: projectPlaybackService
        )
    }()
    
    private lazy var soundsListViewModel: SoundsListViewModelImp = {
        SoundsListViewModelImp(projectProvider: projectProvider, soundsListProvider: soundsListProvider, soundPlaybackService: soundPlaybackService, fileManager: fileManager)
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
    
    lazy var projectDataStorage: any ProjectDataStorage = {
        ProjectDataStorageImp(realmManager: realmManager)
    }()
    
    private lazy var soundDataStorage: any SoundDataStorage = {
        SoundDataStorageImp(realmManager: realmManager)
    }()
    
    private lazy var audioDataStorage: any AudioDataStorage = {
        AudioDataStorageImp()
    }()
    
    private lazy var imageDataStorage: any ImageDataStorage = {
        ImageDataStorageImp()
    }()
    
    // MARK: DataManagers
    
    private lazy var realmManager: Realm? = {
        try? Realm(configuration: .init(deleteRealmIfMigrationNeeded: true))
    }()
    
    private lazy var fileManager: any FileManagerProtocol = {
        FileManagerImp(networkService: networkManager, audioDataStorage: audioDataStorage, imageDataStorage: imageDataStorage)
    }()
    
    private lazy var networkManager: any NetworkManager = {
        NetworkManagerImp()
    }()
}
