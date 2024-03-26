//
//  TrackListViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation

class TrackListViewModel: ObservableObject {
    @Published var projects: [Project] = []
    
    init() {
        let chinaSound = Sound(id: "1", audioFileId: "long-sound-on-sms-11-seconds-about-china", name: "Alarm Ringing")
        let iphoneSmsSound = Sound(id: "2", audioFileId: "iphone-sms", name: "iPhone SMS")
        let samsungSmsSound = Sound(id: "3", audioFileId: "sms-for-samsung", name: "Samsung SMS")
        
        let chinaTrack = Track(id: "track1", sound: chinaSound, points: [TrackPoint(startTime: 0, volume: 0.8, pitch: 1.0), TrackPoint(startTime: 1, volume: 0.8, pitch: 1.0), TrackPoint(startTime: 2, volume: 0.8, pitch: 1.0), TrackPoint(startTime: 3, volume: 0.8, pitch: 1.0)])
        
        let samsungTrack = Track(id: "track3", sound: samsungSmsSound, points: [TrackPoint(startTime: 1, volume: 0.8, pitch: 0.2), TrackPoint(startTime: 2, volume: 0.8, pitch: 0.4), TrackPoint(startTime: 3, volume: 0.8, pitch: 1.4), TrackPoint(startTime: 4, volume: 0.8, pitch: 2)])
        
        let iphoneTrack = Track(id: "track2", sound: iphoneSmsSound, points: [TrackPoint(startTime: 1, volume: 0.8, pitch: -1000), TrackPoint(startTime: 2, volume: 0.8, pitch: -500), TrackPoint(startTime: 3, volume: 0.8, pitch: 500), TrackPoint(startTime: 4, volume: 1.2, pitch: 1000)])
        
        
        let testProject1 = Project(
            id: "project1",
            metronomeBpm: 120,
            name: "project1",
            image: nil,
            updateDate: Date(),
            preparedSounds: [chinaSound, iphoneSmsSound, samsungSmsSound],
            tracks: [chinaTrack]
        )
        
        let testProject2 = Project(
            id: "project2",
            metronomeBpm: 240,
            name: "project2",
            image: nil,
            updateDate: Date(),
            preparedSounds: [chinaSound, iphoneSmsSound, samsungSmsSound],
            tracks: [iphoneTrack]
        )
        
        let testProject3 = Project(
            id: "project3",
            metronomeBpm: 240,
            name: "project3",
            image: nil,
            updateDate: Date(),
            preparedSounds: [chinaSound, iphoneSmsSound, samsungSmsSound],
            tracks: [iphoneTrack, samsungTrack]
        )
        
        projects = [testProject1, testProject2, testProject3]
    }
    
    // Обработка действий пользователя
}
