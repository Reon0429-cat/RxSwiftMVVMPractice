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
    let error: Observable<Error>
    
    init(searchWord: Observable<String>,
         wikipediaAPI: WikipediaAPI) {
        let sequence = searchWord
            .filter { 3 <= $0.count }
            .flatMapLatest { wikipediaAPI.search(from: $0).materialize() }
            .share(replay: 1)
        
        wikipediaPages = sequence.elements()
        error = sequence.errors()
    }
    
}
