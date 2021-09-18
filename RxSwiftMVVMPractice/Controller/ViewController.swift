//
//  ViewController.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/19.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    private enum RowType: CaseIterable {
        case inputName
    }
    private let viewModel: ViewModelType = ViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        setupTableView()
        
    }
    
    private func setupBindings() {
        // Input
        saveButton.rx.tap
            .subscribe(onNext: viewModel.inputs.saveButtonDidTapped)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.outputs.event
            .drive(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                    case .presentAlert(let alert):
                        self.present(alert, animated: true)
                    case .notifyClosedAlert:
                        self.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
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
            viewModel.inputs.didSelectRow(vc: self)
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
        let name = viewModel.outputs.userName
        cell.configure(name: name)
        return cell
    }
    
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.inputs.textFieldDidChangeSelection(text: textField.text)
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
