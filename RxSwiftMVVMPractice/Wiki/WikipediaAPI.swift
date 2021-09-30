//
//  WikipediaAPI.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/30.
//

import Foundation
import RxSwift

protocol WikipediaAPI {
    func search(from word: String) -> Observable<[WikipediaPage]>
}

final class WikipediaDefaultAPI: WikipediaAPI {
    private let host = URL(string: "https://ja.wikipedia.org")!
    private let path = "/w/api.php"
    private let URLSession: Foundation.URLSession
    
    init(URLSession: Foundation.URLSession) {
        self.URLSession = URLSession
    }
    
    func search(from word: String) -> Observable<[WikipediaPage]> {
        var components = URLComponents(url: host,
                                       resolvingAgainstBaseURL: false)!
        components.path = path
        let items = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "list", value: "search"),
            URLQueryItem(name: "srsearch", value: word)
        ]
        components.queryItems = items
        let request = URLRequest(url: components.url!)
        return URLSession.rx.response(request: request)
            .map { pair in
                do {
                    let response = try JSONDecoder().decode(WikipediaSearchResponse.self,
                                                            from: pair.data)
                    return response.search
                } catch {
                    // map内でthrowさせることででコード失敗時にエラーを伝達させる
                    throw error
                }
            }
    }
    
}
