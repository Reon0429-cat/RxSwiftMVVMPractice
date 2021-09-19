//
//  User.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/20.
//

import Foundation
import RxSwift
import RxCocoa

struct User {
    let name = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
}
