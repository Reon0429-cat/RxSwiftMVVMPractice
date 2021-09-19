//
//  SettingsViewController.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/19.
//

import UIKit
import RxSwift
import RxDataSources

final class SettingsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SettingsSectionModel>(
        configureCell: configureCell()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        setupTableView()
        setupViewModel()
        
    }
    
    private func setupViewController() {
        navigationItem.title = "設定"
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.contentInset.bottom = 12.0
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let item = self?.dataSource[indexPath] else { return }
                self?.tableView.deselectRow(at: indexPath, animated: true)
                switch item {
                    default: break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupViewModel() {
        let viewModel = SettingsViewModel()
        
        viewModel.itemsObservable
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.setup()
    }
    
    private func configureCell() -> RxTableViewSectionedReloadDataSource<SettingsSectionModel>.ConfigureCell {
        let cell: RxTableViewSectionedReloadDataSource<SettingsSectionModel>.ConfigureCell = {
            dataSource,
            tableView,
            indexPath,
            _ in
            let item = dataSource[indexPath]
            switch item {
                case .account, .security, .notification, .contents,
                     .sounds, .dataUsing, .accessibility:
                    let cell = tableView
                        .dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                    cell.textLabel?.text = item.title
                    cell.accessoryType = item.accessoryType
                    return cell
                case .description(let text):
                    let cell = tableView
                        .dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                    cell.textLabel?.text = text
                    cell.isUserInteractionEnabled = false
                    return cell
            }
        }
        return cell
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = dataSource[indexPath]
        return item.rowHeight
    }
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        let section = dataSource[section]
        return section.model.headerHeight
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        let section = dataSource[section]
        return section.model.footerHeight
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
}
