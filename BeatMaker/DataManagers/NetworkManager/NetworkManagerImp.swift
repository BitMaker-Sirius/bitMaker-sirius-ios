//
//  NetworkManagerImp.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

final class NetworkManagerImp: NetworkManager {
    
    func fetchData(fromStringURL stringUrl: String, completion: @escaping (Result<Data, NetworkManagerErrors>) -> ()) {
        
        guard let url = URL(string: stringUrl) else {
            completion(Result.failure(NetworkManagerErrors.invalidURL))
            return
        }
        
        getData(fromURL: url) { result in
            completion(result)
        }
    }
    
    func fetchRandomImageFromApi(completion: @escaping (Result<Data, NetworkManagerErrors>) -> ()) {
        
        guard let randomImageUrl = URL(string: "https://random-image-pepebigotes.vercel.app/api/random-image") else {
            completion(Result.failure(NetworkManagerErrors.invalidURL))
            return
        }
        
        getData(fromURL: randomImageUrl) { result in
            completion(result)
        }
    }
    
    private func getData(fromURL url: URL, completion: @escaping (Result<Data, NetworkManagerErrors>) -> ()) {
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let err = error {
                print(err.localizedDescription)
                completion(Result.failure(NetworkManagerErrors.fetchError))
                return
            }
            
            guard let data = data else {
                completion(Result.failure(NetworkManagerErrors.fetchError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(Result.failure(NetworkManagerErrors.brokenResponse))
                return
            }
            
            if httpResponse.statusCode != 200 {
                completion(Result.failure(NetworkManagerErrors.notOKResponseStatus))
                return
            }
            
            completion(Result.success(data))
            return
        }
        
        dataTask.resume()
    }
}
