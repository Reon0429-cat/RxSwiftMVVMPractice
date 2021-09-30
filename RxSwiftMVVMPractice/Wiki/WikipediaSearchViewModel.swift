//
//  WikipediaSearchViewModel.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/30.
//

import Foundation
import RxSwift
import RxCocoa

final class WikipediaSearchViewModel {
    
    let wikipediaPages: Observable<[WikipediaPage]>
    init(searchWord: Observable<String>, wikipediaAPI: WikipediaAPI) {
        wikipediaPages = searchWord
            .filter { 3 <= $0.count }
            .flatMapLatest {
                return wikipediaAPI.search(from: $0)
            }
            .share(replay: 1)
    }
    
}
