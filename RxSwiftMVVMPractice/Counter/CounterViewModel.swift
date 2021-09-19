//
//  CounterViewModel.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/19.
//

import RxSwift
import RxCocoa

struct CounterViewModelInput {
    let countUpButton: Observable<Void>
    let countDownButton: Observable<Void>
    let countResetButton: Observable<Void>
}

protocol CounterViewModelOutput: AnyObject {
    var counterText: Driver<String?> { get }
}

protocol CounterViewModelType {
    func setup(input: CounterViewModelInput)
    var outputs: CounterViewModelOutput? { get }
}

final class CounterViewModel {
    
    private let countRelay = BehaviorRelay<Int>(value: 0)
    private let initialCount = 0
    private let disposeBag = DisposeBag()
    
    init() {
        resetCount()
    }
    
    private func incrementCount() {
        let count = countRelay.value + 1
        countRelay.accept(count)
    }
    
    private func decrementCount() {
        let count = countRelay.value - 1
        countRelay.accept(count)
    }
    
    private func resetCount() {
        countRelay.accept(initialCount)
    }
    
}

extension CounterViewModel: CounterViewModelOutput {
    
    var counterText: Driver<String?> {
        return countRelay
            .map { "🍎 \($0) 🍏" }
            .asDriver(onErrorJustReturn: nil)
    }
    
}

extension CounterViewModel: CounterViewModelType {
    
    func setup(input: CounterViewModelInput) {
        input.countUpButton
            .subscribe(onNext: incrementCount)
            .disposed(by: disposeBag)
        
        input.countDownButton
            .subscribe(onNext: decrementCount)
            .disposed(by: disposeBag)

        input.countResetButton
            .subscribe(onNext: resetCount)
            .disposed(by: disposeBag)
    }
    
    var outputs: CounterViewModelOutput? {
        return self
    }
    
}
