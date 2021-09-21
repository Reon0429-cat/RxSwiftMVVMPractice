//
//  ChainedRequestsViewController.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/22.
//

import UIKit
import RxSwift
import RxCocoa

final class ChainedRequestsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(CustomTableViewCell.nib,
                               forCellReuseIdentifier: CustomTableViewCell.identifier)
        }
    }
    
    private let githubRepository = GitHubRepository()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let randomNumber = Int.random(in: 0...50)
        
        let reposObservable = githubRepository.getRepos().share()
        
        reposObservable.map { repos -> String in
            let repo = repos[randomNumber]
            return repo.owner.login + "/" + repo.name
        }
        .startWith("Loading...")
        .bind(to: navigationItem.rx.title)
        .disposed(by: disposeBag)
        
        reposObservable
            .flatMap { repos -> Observable<[Branch]> in
                let repo = repos[randomNumber]
                return self.githubRepository.getBranches(ownerName: repo.owner.login,
                                                         repoName: repo.name)
            }.bind(to: tableView.rx.items(cellIdentifier: CustomTableViewCell.identifier,
                                          cellType: CustomTableViewCell.self)) { index, branch, cell in
                cell.configure(title: branch.name)
            }.disposed(by: disposeBag)
    }
    
}
