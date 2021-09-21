//
//  BeerListViewModel.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/22.
//

import Foundation
import RxSwift
import RxCocoa

final class BeerListViewModel {
    
    private var page = 1
    private var disposeBag = DisposeBag()
    private let repository = BeerListRepository()
    
    struct Input {
        func viewDidLoad() { }
        let refreshTrigger = PublishRelay<Void>()
        let nextPageTrigger = PublishRelay<Void>()
    }
    
    struct Output {
        let list = BehaviorRelay<[Beer]>(value: [])
        let isLoading = BehaviorRelay<Bool>(value: false)
        let isRefreshing = PublishRelay<Bool>()
        let errorRelay = PublishRelay<NetworkingError>()
    }
    
    let input = Input()
    let output = Output()
    
    init() {
        input.refreshTrigger.asObservable()
            .map { [weak self] _ in
                self?.page = 1
            }
            .flatMap {
                self.repository.getBeerList(page: self.page)
                    .do(onError: { [weak self] error in
                        self?.output.errorRelay.accept(error as! NetworkingError)
                    })
            }
            .bind(to: self.output.list)
            .disposed(by: disposeBag)
        
        input.nextPageTrigger.asObservable()
            .map { [weak self] _ in
                self?.page += 1
            }
            .flatMap {
                self.repository.getBeerList(page: self.page)
                    .do(onError: { [weak self] error in
                        self?.output.errorRelay.accept(error as! NetworkingError)
                    })
            }
            .map { self.output.list.value + $0 }
            .bind(to: self.output.list)
            .disposed(by: disposeBag)
        
    }
    
}
