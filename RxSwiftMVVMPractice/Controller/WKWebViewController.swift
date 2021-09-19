//
//  WKWebViewController.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/19.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import WebKit

final class WKWebViewController: UIViewController {

    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var webView: WKWebView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        
    }
    
    private func setupWebView() {
        let loadingObservable = webView.rx.observe(Bool.self,
                                                   "loading")
            .filterNil()
            .share()
        
        loadingObservable
            .map { return !$0 }
            .bind(to: progressView.rx.isHidden)
            .disposed(by: disposeBag)
        
        loadingObservable
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        
        loadingObservable
            .map { [weak self] _ in return self?.webView.title }
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        webView.rx.observe(Double.self,
                           "estimatedProgress")
            .filterNil()
            .map { return Float($0) }
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)
        
        let url = URL(string: "https://github.com/Reon0429-cat")
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }
    
}
