//
//  Repo.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/22.
//

import Foundation

struct Repo: Decodable {
    let name: String
    let owner: Owner
}

struct Owner: Decodable {
    let login: String
}

struct Branch: Decodable {
    let name: String
}
