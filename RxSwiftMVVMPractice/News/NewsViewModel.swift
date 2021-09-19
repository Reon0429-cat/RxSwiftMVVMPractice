//
//  NewsViewModel.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/20.
//

import Foundation
import RxCocoa
import RxSwift

struct NewsViewModel {
    let error = PublishRelay<String>()
    let articles = PublishRelay<[Article]>()
    
    func loadData() {
        APIClient().fetchGenericData(urlString: Constants.newApi) { (result: Result<News, Error>) in
            switch result {
                case .success(let news):
                    self.articles.accept(news.articles)
                case .failure(let error):
                    self.error.accept(error.localizedDescription)
            }
        }
    }
    
}
