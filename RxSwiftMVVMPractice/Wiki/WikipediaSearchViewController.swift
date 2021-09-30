//
//  WikipediaSearchViewController.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/30.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

final class WikipediaSearchViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = WikipediaSearchViewModel(
            searchWord: searchBar.rx.text.orEmpty.asObservable(),
            wikipediaAPI: WikipediaDefaultAPI(URLSession: .shared)
        )
        
        viewModel.wikipediaPages
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) {
                index, result, cell in
                cell.textLabel?.text = result.title
                cell.detailTextLabel?.text = result.url.absoluteString
            }
            .disposed(by: disposeBag)
        
        viewModel.error
            .compactMap { $0 as? URLError }
            .subscribe(onNext: { error in
                if error.code == .notConnectedToInternet {
                    // alert
                }
            })
            .disposed(by: disposeBag)
        
    }
    
}
