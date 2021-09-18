//
//  ViewModel.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/19.
//

import RxSwift
import RxCocoa

protocol ViewModelInput {
    func saveButtonDidTapped()
    func didSelectRow<T: UITextFieldDelegate>(vc: T)
    func textFieldDidChangeSelection(text: String?)
}

protocol ViewModelOutput: AnyObject {
    var event: Driver<ViewModel.Event> { get }
    var userName: String { get }
}

protocol ViewModelType {
    var inputs: ViewModelInput { get }
    var outputs: ViewModelOutput { get }
}

final class ViewModel: ViewModelInput,
                       ViewModelOutput {
    
    private var userUseCase = UserUseCase()
    private var inputtedName = ""
    
    enum Event {
        case presentAlert(UIAlertController)
        case notifyClosedAlert
    }
    
    private let eventRelay = PublishRelay<Event>()
    
    private func createAlert<T: UITextFieldDelegate>(vc: T) -> UIAlertController {
        let alert = UIAlertController(title: "名前入力",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.delegate = vc
        }
        alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: { _ in
            self.eventRelay.accept(.notifyClosedAlert)
        }))
        return alert
    }
    
}

// MARK: - Input
extension ViewModel {
    
    func saveButtonDidTapped() {
        let user = User(name: inputtedName)
        userUseCase.saveUser(user: user)
    }
    
    func didSelectRow<T: UITextFieldDelegate>(vc: T) {
        eventRelay.accept(.presentAlert(createAlert(vc: vc)))
    }
    
    func textFieldDidChangeSelection(text: String?) {
        inputtedName = text ?? ""
    }
    
}

// MARK: - Output
extension ViewModel {
    
    var event: Driver<Event> {
        eventRelay.asDriver(onErrorDriveWith: .empty())
    }
    
    var userName: String {
        return inputtedName
    }
    
}

extension ViewModel: ViewModelType {
    
    var inputs: ViewModelInput {
        return self
    }
    
    var outputs: ViewModelOutput {
        return self
    }
    
}
