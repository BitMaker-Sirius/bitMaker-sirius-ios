//
//  Assembly.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 24.03.2024.
//

import Foundation
import RealmSwift

final class Assembly {
    // MARK: Views
    
    // PlayProjectView
    // EditProjectView
    // ...
    
    // MARK: ViewModels
    
    // PlayProjectVM
    // EditProjectVM
    // ...
    
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
        SoundDataStorageImp()
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
