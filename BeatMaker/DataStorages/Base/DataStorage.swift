//
//  DataStorage.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

protocol DataStorage<DataType> {
    associatedtype DataType
    
    /// Взять из стореджа объект данных
    func get(by id: String, completion: @escaping (Result<DataType, DataStorageError>) -> Void)
    /// Взять из стореджа все объекты данных
    func getAll(completion: @escaping (Result<[DataType], DataStorageError>) -> Void)
    
    /// Если id != nil, то сохранить  в сторедж новый объект данных, иначе изменить существующий
    func save(by id: String?, _ data: DataType, completion: @escaping (_ id: String?, _ isCompleted: Bool) -> Void)
    /// Удалить из стореджа объект данных
    func delete(by id: String, completion: @escaping (_ isCompleted: Bool) -> Void)
}
