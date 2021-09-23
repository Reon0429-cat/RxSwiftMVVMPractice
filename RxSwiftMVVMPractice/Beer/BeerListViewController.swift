//
//  BeerListViewController.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/22.
//

import UIKit
import RxSwift
import RxCocoa

final class BeerListViewController: UIViewController {
    
    private let viewModel = BeerListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        viewModel.input.viewDidLoad()
        
    }
    
    private func setupBindings() {
        
    }
    
}
