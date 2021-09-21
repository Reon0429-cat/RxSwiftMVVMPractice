//
//  RealmManager.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/22.
//

import Foundation
import RealmSwift

enum NetworkingError: Error {
    case error(String)
    case defaultError
    
    var message: String {
        switch self {
            case let .error(msg):
                return msg
            case .defaultError:
                return "Please retry later."
        }
    }
}

typealias ResultHandler<T> = (Result<T, NetworkingError>) -> Void

protocol LocalManager {
    func saveBeer(beer: Beer)
    func getLocalBeerList(page: Int,
                          completion: @escaping ResultHandler<[Beer]>)
    func searchLocalID(id: Int,
                       completion: @escaping ResultHandler<[Beer]>)
    func localRandom(completion: @escaping ResultHandler<[Beer]>)
}

final class RealmManager: LocalManager {
    
    private let realm = try! Realm()
    private var objects: Results<BeerRealm> {
        return realm.objects(BeerRealm.self)
    }
    
    func saveBeer(beer: Beer) {
        deleteBeer(beer: beer)
        let beerRealm = BeerRealm(beer: beer)
        try! realm.write {
            realm.add(beerRealm)
        }
    }
    
    func getLocalBeerList(page: Int,
                          completion: @escaping ResultHandler<[Beer]>) {
        let result = realm.objects(BeerRealm.self).filter(
            "id >= \((page - 1) * 25 + 1) AND id <= \(page * 25)"
        )
        var beers = [Beer]()
        for beer in result.map({ $0.toDTO() }) {
            beers.append(beer)
        }
        if beers.isEmpty {
            completion(.failure(.defaultError))
        } else {
            completion(.success(beers))
        }
    }
    
    func searchLocalID(id: Int,
                       completion: @escaping ResultHandler<[Beer]>) {
        let result = objects.filter("id = \(id)")
        var beers = [Beer]()
        for beer in result.map({ $0.toDTO() }) {
            beers.append(beer)
        }
        if beers.isEmpty {
            completion(.failure(.defaultError))
        } else {
            completion(.success(beers))
        }
    }
    
    func localRandom(completion: @escaping ResultHandler<[Beer]>) {
        let result = objects.randomElement()
        var beers = [Beer]()
        beers.append(result?.toDTO() ?? Beer(id: nil,
                                             name: "Don't have data",
                                             description: nil,
                                             imageURL: nil))
        if beers.isEmpty {
            completion(.failure(.defaultError))
        } else {
            completion(.success(beers))
        }
    }
    
    private func deleteBeer(beer: Beer) {
        try! realm.write {
            realm.delete(objects.filter("id = \(beer.id ?? 0)"))
        }
    }
    
}
