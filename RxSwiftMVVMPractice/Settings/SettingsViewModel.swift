//
//  SettingsViewModel.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/19.
//

import RxSwift
import RxCocoa
import RxDataSources

final class SettingsViewModel {
    
    private let itemsRelay = BehaviorRelay<[SettingsSectionModel]>(value: [])
    
    var itemsObservable: Observable<[SettingsSectionModel]> {
        return itemsRelay.asObservable()
    }
    
    func setup() {
        updateItems()
    }
    
    private func updateItems() {
        let sections: [SettingsSectionModel] = [
            accountSection(),
            commonSection()
        ]
        itemsRelay.accept(sections)
    }
    
    private func accountSection() -> SettingsSectionModel {
        let items: [SettingsItem] = [
            .account,
            .security,
            .notification,
            .contents
        ]
        return SettingsSectionModel(model: .account, items: items)
    }
    
    private func commonSection() -> SettingsSectionModel {
        let items: [SettingsItem] = [
            .sounds,
            .dataUsing,
            .accessibility,
            .description(text: "基本設定はこの端末でログインしている全てのアカウントに適用されます")
        ]
        return SettingsSectionModel(model: .common, items: items)
    }
    
}
