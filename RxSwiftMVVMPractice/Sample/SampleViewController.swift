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

final class SampleViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catchError()
        
    }
    
    private func catchError() {
        let sequence = Observable<String>.create { observer in
            observer.onNext("A")
            observer.onError(SampleError.error)
            observer.onNext("B")
            observer.onCompleted()
            return Disposables.create()
        }
        _ = sequence
            .catchAndReturn("Z")
            .subscribe(onNext: { string in
                print("onNext: ", string)
            }, onError: { error in
                print("onError", error)
            }, onCompleted: {
                print("onCompleted")
            }, onDisposed: {
                print("onDisposed")
            })
        /*
         onNext:  A
         onNext:  Z
         onCompleted
         onDisposed
         */
    }
    
    private func retry() {
        let sequence = Observable<String>.create { observer in
            observer.onNext("A")
            observer.onError(SampleError.error)
            print("Error 発生")
            observer.onNext("B")
            observer.onCompleted()
            return Disposables.create()
        }
        
        _ = sequence
            .retry(2)
            .subscribe(onNext: { string in
                print("onNext: ", string)
            }, onError: { error in
                print("onError", error)
            }, onCompleted: {
                print("onCompleted")
            }, onDisposed: {
                print("onDisposed")
            })
        /*
         onNext:  A
         Error 発生
         onNext:  A
         Error 発生
         onError error
         onDisposed
         */
    }
    
    private func 正常終了() {
        let sequence = Observable.of(1, 2)
            .flatMap { int -> Observable<String> in
                print("\(int)")
                let observable = Observable<String>.create { observer in
                    observer.onNext("A")
                    observer.onCompleted()
                    observer.onNext("B")
                    return Disposables.create()
                }
                return observable
            }
        
        _ = sequence
            .subscribe(onNext: { string in
                print("onNext: ", string)
            }, onError: { error in
                print("onError", error)
            }, onCompleted: {
                print("onCompleted")
            }, onDisposed: {
                print("onDisposed")
            })
        /* 1
         onNext:  A
         2
         onNext:  A
         onCompleted
         onDisposed
         */
    }
    
    private func 異常終了() {
        let sequence = Observable.of(1, 2)
            .flatMap { int -> Observable<String> in
                print("\(int)")
                let observable = Observable<String>.create { observer in
                    observer.onNext("A")
                    observer.onError(SampleError.error)
                    observer.onNext("B")
                    return Disposables.create()
                }
                return observable
            }
        
        _ = sequence
            .subscribe(onNext: { string in
                print("onNext: ", string)
            }, onError: { error in
                print("onError", error)
            }, onCompleted: {
                print("onCompleted")
            }, onDisposed: {
                print("onDisposed")
            })
        /*
         1
         onNext:  A
         onError error
         onDisposed
         */
    }
    
    private func empty() {
        // onCompletedのみ
        let observable = Observable<Int>.empty()
        observable
            .subscribe({ print($0) })
            .disposed(by: disposeBag)
        // completed
    }
    
    private func just() {
        // 1回のonNextごにonCompletedするObservable
        let observable = Observable.just(1) // Observable<Int>.just(1)と同じ
        observable
            .subscribe({ print($0) })
            .disposed(by: disposeBag)
        // next(1)
        // completed
        
        // 以下のようにcreateを使って作ることもできる
        // let observable = Observable<Int>.create { observer in
        //     observer.onNext(1)
        //     observer.onCompleted()
        //     return Disposables.create()
        // }
    }
    
    private func createObservable() {
        // ライブラリ自体にObservableが用意されている場合はそちらを使うが、
        // 用意されていない場合は自作する
        // ↓ subscribeされると100, 200を出力後、完了するObservableを自作
        let observable = Observable<Int>.create { observer in
            observer.onNext(100)
            observer.onNext(200)
            observer.onCompleted()
            return Disposables.create()
        }
        observable
            .subscribe({ print($0) })
            .disposed(by: disposeBag)
        // next(100)
        // next(200)
        // completed
    }
    
    private func zip() {
        // 複数のオブザーバブルのイベントを一つずつ順番に合成する
        // 並列処理をする場合に使う
        // (API通信で複数のレスポンスを待ってから処理を進めたい時など)
        let int = Observable.of(1, 2, 3, 4)
        let string = Observable.of("a", "b", "c")
        _ = Observable.zip(int, string) {
            "\($0)" + "\($1)"
        }
        .subscribe { print("onNext", $0) }
        .disposed(by: disposeBag)
        // onNext next(1a)
        // onNext next(2b)
        // onNext next(3c)
        // onNext completed
    }
    
    private func withLatestFrom() {
        // あるオブザーバブルがイベントを送信した際にもう一方のオブザーバブルの最新イベントを合成
        // 一つのアクションが起きた時に他の値に対して何かしらの処理をする場合に使う
        // (ボタンが押された時に、他の要素がどのようになっているか知りたいときなど)
        let int = PublishSubject<Int>()
        let string = PublishSubject<String>()
        int.withLatestFrom(string)
            .subscribe({ string in
                print("onNext", string)
            })
            .disposed(by: disposeBag)
        
        int.onNext(1)
        string.onNext("a")
        int.onNext(2)
        string.onNext("b")
        string.onNext("c")
        int.onNext(3)
    }
    
    private func combineLatest() {
        // 複数の変数を監視する必要がある場合に使う合成オペレーター
        // (ログイン画面のバリデーションなど)
        let int = PublishSubject<Int>()
        let string = PublishSubject<String>()
        let _ = Observable.combineLatest(int, string) {
            "\($0)" + "\($1)"
        }
            .subscribe { print("onNext", $0) }
            .disposed(by: disposeBag)
        
        int.onNext(1)
        string.onNext("a")
        int.onNext(2)
        string.onNext("b")
        string.onNext("c")
        int.onNext(3)
    }
    
    private func single() {
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
                singleObserver(.failure(SampleError.error))
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

