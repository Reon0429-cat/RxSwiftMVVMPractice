//
//  NetworkService.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/22.
//

import Foundation
import RxSwift
import RxCocoa

final class NetworkService {
    func execute<T: Decodable>(url: URL) -> Observable<T> {
        return Observable.create { observer -> Disposable in
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data,
                      let decoded = try? JSONDecoder().decode(T.self, from: data) else { return }
                observer.onNext(decoded)
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

