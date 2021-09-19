//
//  CounterViewController.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/19.
//

import UIKit
import RxSwift
import RxCocoa

final class CounterViewController: UIViewController {
    
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var countUpButton: UIButton!
    @IBOutlet private weak var countDownButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var viewModel = CounterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        
    }
    
    private func setupBindings() {
        // Input
        let input = CounterViewModelInput(countUpButton: countUpButton.rx.tap.asObservable(),
                                   countDownButton: countDownButton.rx.tap.asObservable(),
                                   countResetButton: resetButton.rx.tap.asObservable())
        viewModel.setup(input: input)
        
        // Output
        viewModel.outputs?.counterText
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}
