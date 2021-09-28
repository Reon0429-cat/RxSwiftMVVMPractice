//
//  SampleViewController.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/22.
//

import UIKit
import RxSwift
import RxCocoa

enum SampleError: Error {
    case error
}

protocol EventConvertible {
    associatedtype ElementType
    var event: Event<ElementType> { get }
}

extension Event: EventConvertible {
    var event: Event<Element> {
        return self
    }
}

extension ObservableType where Element: EventConvertible {
    func elements() -> Observable<Element.ElementType> {
        return self.compactMap { $0.event.element }
    }
    func errors() -> Observable<Error> {
        return self.compactMap { $0.event.error }
    }
}

final class SampleViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        materialize分岐()
        
    }
    
    private func materialize分岐() {
        let observable = Observable<String>.create { observer in
            observer.onNext("A")
            observer.onError(SampleError.error)
            return Disposables.create()
        }
        let result = observable.materialize()
        let element = result.elements()
        _ = element.subscribe { value in
            print(value)
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)
        /*
         A
         */
        
        // 異常系のみ取り出すために異常系のみ取り出したストリームerrorsの作成
        let errors = result
            .compactMap { $0.error }
        _ = errors.subscribe { value in
            print(value)
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)
        /*
         error
         */
    }
    
    private func materialize() {
        let observable = Observable<String>.create { observer in
            observer.onNext("A")
            observer.onError(SampleError.error)
            return Disposables.create()
        }
        // Observable<String> -> Observable<Event<String>>
        _ = observable.materialize()
            .subscribe(onNext: { event in
                switch event {
                    case .next(let string):
                        print(string)
                    case .error(let error):
                        print(error)
                    case .completed:
                        print("完了")
                }
            }, onError: { error in
                print(error)
            })
        /*
         A
         error
         */
    }
    
  
}
