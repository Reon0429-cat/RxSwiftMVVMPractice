//
//  SettingsSection.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/19.
//

import Foundation
import RxDataSources

typealias SettingsSectionModel = SectionModel<SettingsSection, SettingsItem>

enum SettingsSection {
    case account
    case common
    
    var headerHeight: CGFloat {
        return 40
    }
    
    var footerHeight: CGFloat {
        return 1
    }
}

enum SettingsItem {
    case account
    case security
    case contents
    case sounds
    case notification
    case dataUsing
    case accessibility
    case description(text: String)
    
    var title: String? {
        switch self {
            case .account: return "アカウント"
            case .security: return "セキュリティー"
            case .contents: return "コンテンツ設定"
            case .sounds: return "サウンド設定"
            case .notification: return "通知"
            case .dataUsing: return "データ利用の設定"
            case .accessibility: return "アクセシビリティ"
            case .description: return nil
        }
    }
    
    var rowHeight: CGFloat {
        switch self {
            case .description: return 72
            default: return 48
        }
    }
    
    var accessoryType: UITableViewCell.AccessoryType {
        switch self {
            case .description:
                return .none
            default:
                return .disclosureIndicator
        }
    }
}
