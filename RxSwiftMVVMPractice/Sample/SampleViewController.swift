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
    case invalid
}

final class SampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let single = Single<Int>.create { singleObserver in
            singleObserver(.success(100))
            return Disposables.create()
        }.flatMap { value in
            return Single<Int>.create { singleObserver in
                singleObserver(.success(value + 300))
                return Disposables.create()
            }
        }.flatMap { value in
            return Single<Int>.create { singleObserver in
                singleObserver(.failure(SampleError.invalid))
                return Disposables.create()
            }
        }.flatMap { value in
            return Single<Int>.create { singleObserver in
                singleObserver(.success(value / 10))
                return Disposables.create()
            }
        }
        
        let _ = single.subscribe { singleObserver in
            print(singleObserver)
        }
        
        let _ = single.subscribe { singleObserver in
            switch singleObserver {
                case .success(let value):
                    print("success\(value)")
                case .failure(let error):
                    print("error\(error)")
            }
        }
        
    }
    
}
