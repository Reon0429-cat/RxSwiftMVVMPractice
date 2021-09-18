//
//  UserUseCase.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/19.
//

import Foundation


final class UserUseCase {
    
    private let nameKey = "nameKey"
    
    func saveUser(user: User) {
        UserDefaults.standard.set(user.name, forKey: nameKey)
    }
    
    func loadUser() -> User {
        let name = UserDefaults.standard.string(forKey: nameKey) ?? ""
        return User(name: name)
    }
    
}
