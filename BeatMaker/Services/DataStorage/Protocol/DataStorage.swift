//
//  DataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

protocol DataStorage<DataType> {
    associatedtype DataType
    associatedtype ErrorType: Error
    
    /// Взять из стореджа объект данных
    func get(by id: String, completion: @escaping ((Result<DataType, ErrorType>) -> Void))
    /// Взять из стореджа все объекты данных
    func getAll(completion: @escaping ((Result<[DataType], ErrorType>) -> Void))
    
    /// Сохранить  в сторедж объект данных
    func save(_ data: DataType, completion: @escaping ((_ id: String?) -> Void))
    /// Удалить из стореджа объект данных
    func delete(by id: String, completion: @escaping ((_ isCompleted: Bool) -> Void))
    /// Передаем измененный объект данных, для обновления существующего в сторедже
    func update(by id: String, with data: DataType, completion: @escaping ((_ isCompleted: Bool) -> Void))
}
