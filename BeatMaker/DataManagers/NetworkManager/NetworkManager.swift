//
//  SamplingService.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import AVFoundation

protocol NetworkManager {
    
    func fetchData(fromStringURL stringUrl: String, completion: @escaping (Result<Data, NetworkManagerErrors>) -> ())
    func fetchRandomImageFromApi(completion: @escaping (Result<Data, NetworkManagerErrors>) -> ())
}
