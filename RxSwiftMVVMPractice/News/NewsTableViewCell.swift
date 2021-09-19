//
//  NewsTableViewCell.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/20.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    
    func configure(article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
    }
    
}
