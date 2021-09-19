//
//  News.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/20.
//

import Foundation

struct News: Decodable {
    var articles = [Article]()
}

struct Article: Decodable {
    var title: String
    var description: String
}
