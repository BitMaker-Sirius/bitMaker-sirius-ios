//
//  NetworkManagerErrors.swift
//  BeatMaker
//
//  Created by Александр Бобрун on 26.03.2024.
//

import Foundation

enum NetworkManagerErrors: Error {
    
    case fetchError
    case invalidURL
    case notOKResponseStatus
    case brokenResponse
}
