//
//  BeerListRepository.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/22.
//

import Foundation
import RxSwift

protocol BeerListRepositoryProtocol {
    func getBeerList(page: Int) -> Single<[Beer]>
}

final class BeerListRepository: BeerListRepositoryProtocol {
    
    let realmManager = RealmManager()
    
    func getBeerList(page: Int) -> Single<[Beer]> {
        return Single<[Beer]>.create { single in
            let request = BeerAPI.setRequest(.getBeerList(page: page))
            let response = URLSession.shared.rx.response(request: request)
            return response.subscribe(onNext: { response, data in
                if 200..<300 ~= response.statusCode {
                    guard let beers = try? JSONDecoder().decode([Beer].self, from: data) else {
                        return single(.failure(NetworkingError.error("エラー")))
                    }
                    for beer in beers {
                        self.realmManager.saveBeer(beer: beer)
                    }
                    return single(.success(beers))
                }
            }, onError: { error in
                self.realmManager.getLocalBeerList(page: page) { result in
                    switch result {
                        case .success(let beers):
                            return single(.success(beers))
                        case .failure(let error):
                            return single(.failure(error))
                    }
                }
            })
        }
    }
    
    
}
