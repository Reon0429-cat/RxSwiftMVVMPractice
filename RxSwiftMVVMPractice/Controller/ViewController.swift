//
//  ViewController.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/19.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    private var userUseCase = UserUseCase()
    private var inputtedName = ""
    private enum RowType: CaseIterable {
        case inputName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        print(userUseCase.loadUser())
        
    }
    
    @IBAction private func saveButtonDidTapped(_ sender: Any) {
        let user = User(name: inputtedName)
        userUseCase.saveUser(user: user)
    }
    
}

// MARK: - func
private extension ViewController {
    
    func presentAlertWithTextField() {
        let alert = UIAlertController(title: "名前入力",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.delegate = self
        }
        alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: { _ in
            self.tableView.reloadData()
        }))
        present(alert, animated: true)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate,
                          UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if RowType.allCases[indexPath.row] == .inputName {
            presentAlertWithTextField()
        }
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return RowType.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomTableViewCell.identifier
        ) as! CustomTableViewCell
        cell.configure(name: inputtedName)
        return cell
    }
    
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        inputtedName = textField.text ?? ""
    }
    
}

// MARK: - setup
extension ViewController {
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.nib,
                           forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.tableFooterView = UIView()
    }
    
}
