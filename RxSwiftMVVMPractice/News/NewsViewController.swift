//
//  NewsViewController.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/20.
//

import UIKit
import RxCocoa
import RxSwift

final class NewsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel = NewsViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        
    }
    
    private func setupBindings() {
        viewModel.articles.bind(to: tableView.rx.items(
                                    cellIdentifier: NewsTableViewCell.identifier,
                                    cellType: NewsTableViewCell.self)
        ) { row, article, cell in
            cell.configure(article: article)
        }
        .disposed(by: disposeBag)
        
        viewModel.loadData()
    }
    
}
