//
//  SamplingService.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import AVFoundation

protocol NetworkManager {
    // Реализация походов в сеть
    func fetchData(fromStringURL stringUrl: String, complition: @escaping (Result<Data, NetworkManagerErrors>) -> ())
    func fetchRandomImageFromApi(complition: @escaping (Result<Data, NetworkManagerErrors>) -> ())
}
