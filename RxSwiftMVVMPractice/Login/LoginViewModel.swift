//
//  LoginViewModel.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/20.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
    
    let isUserNameError = PublishRelay<Bool>()
    let isPasswordError = PublishRelay<Bool>()
    let user = BehaviorRelay<User>(value: User())
    var isLoginButtonEnabled: Observable<Bool> {
        return .combineLatest(user.value.name.startWith(""),
                              user.value.password.startWith("")) { name, password in
            self.isUserNameError.accept(true)
            self.isPasswordError.accept(true)
            if !Validation().isValidUserName(username: name) && !name.isEmpty {
                self.isUserNameError.accept(false)
                if !Validation().isValidPassword(password: password) && !password.isEmpty {
                    self.isPasswordError.accept(false)
                }
                return false
            } else if !Validation().isValidPassword(password: password) && !password.isEmpty {
                self.isPasswordError.accept(false)
                return false
            } else if !password.isEmpty && !name.isEmpty{
                return true
            }
            return false
        }
    }
    
}
