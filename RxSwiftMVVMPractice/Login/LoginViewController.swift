//
//  LoginViewController.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/20.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var userNameErrorLabel: UILabel!
    @IBOutlet private weak var passwordErrorLabel: UILabel!
    @IBOutlet private weak var userNameTextField: UITextField!
    
    private var loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login"
        setupBindings()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let homeVC = segue.destination as? HomeViewController {
            homeVC.user = loginViewModel.user
        }
    }
    
    private func setupBindings() {
        userNameTextField.rx.text.orEmpty
            .bind(to: loginViewModel.user.value.name)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: loginViewModel.user.value.password)
            .disposed(by: disposeBag)
        
        loginViewModel.isLoginButtonEnabled
            .map { $0 ? 1 : 0.4 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)
        
        loginViewModel.isLoginButtonEnabled
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginViewModel.isUserNameError
            .map { !$0 }
            .bind(to: userNameErrorLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        loginViewModel.isPasswordError
            .map { !$0 }
            .bind(to: passwordErrorLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
}
