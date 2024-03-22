//
//  DataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

protocol DataStorage<DataType> {
    associatedtype DataType
    
    // Взять из стореджа объект данных
    func get(by id: UUID) -> DataType?
    // Взять из стореджа все объекты данных
    func getAll() -> [DataType]
    
    // Записать в сторедж объект данных
    func add(_ data: DataType)
    // Удалить из стореджа объект данных
    func remove(by id: UUID)
    // Передаем измененный объект данных, чтобы обновить его значения в сторедже
    func update(_ data: DataType)
}
