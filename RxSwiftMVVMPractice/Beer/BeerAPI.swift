//
//  BeerAPI.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/22.
//

import Foundation

enum BeerAPI {
    case getBeerList(page: Int)
    case getDetailBeer(id: Int)
    case searchID(id: Int)
    case random
}

extension BeerAPI {
    var baseURL: String {
        return "https://api.punkapi.com/v2/beers"
    }
    
    var path: String {
        switch self {
        case .random:
            return "/random"
        default:
            return ""
        }
    }
    
    var method: String {
        switch self {
        default:
            return "GET"
        }
    }
    
    var querys: [String: String]? {
        switch self {
        case let .getBeerList(page):
            return ["page": String(page)]
        case let .searchID(id):
            return ["ids": String(id)]
        case let .getDetailBeer(id):
            return ["ids": String(id)]
        case .random:
            return nil
        }
    }
}

extension BeerAPI {
    
    static func setRequest(_ api: BeerAPI) -> URLRequest {
        var url = api.baseURL + api.path
        if api.querys != nil {
            url += "?"
            for query in api.querys! {
                url += query.key + "=" + query.value
            }
        }
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = api.method
        return request
    }
    
}
