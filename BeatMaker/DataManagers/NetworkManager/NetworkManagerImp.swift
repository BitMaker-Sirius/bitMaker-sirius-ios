//
//  NetworkManagerImp.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

final class NetworkManagerImp: NetworkManager {
    
    func fetchData(fromStringURL stringUrl: String, complition: @escaping (Result<Data, NetworkManagerErrors>) -> ()) {
        
        guard let url = URL(string: stringUrl) else {
            complition(Result.failure(NetworkManagerErrors.invalidURL))
            return
        }
        
        getData(fromURL: url) { result in
            complition(result)
        }
    }
    
    func fetchRandomImageFromApi(complition: @escaping (Result<Data, NetworkManagerErrors>) -> ()) {
        
        guard let randomImageUrl = URL(string: "https://random-image-pepebigotes.vercel.app/api/random-image") else {
            complition(Result.failure(NetworkManagerErrors.invalidURL))
            return
        }
        
        getData(fromURL: randomImageUrl) { result in
            complition(result)
        }
    }
    
    private func getData(fromURL url: URL, complition: @escaping (Result<Data, NetworkManagerErrors>) -> ()) {
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let err = error {
                print(err.localizedDescription)
                complition(Result.failure(NetworkManagerErrors.fetchError))
                return
            }
            
            guard let data = data else {
                complition(Result.failure(NetworkManagerErrors.fetchError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                complition(Result.failure(NetworkManagerErrors.brokenResponse))
                return
            }
            
            if httpResponse.statusCode != 200 {
                complition(Result.failure(NetworkManagerErrors.notOKResponseStatus))
                return
            }
            
            complition(Result.success(data))
            return
        }
        
        dataTask.resume()
    }
}
