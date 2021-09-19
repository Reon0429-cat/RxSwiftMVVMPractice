//
//  HomeViewController.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/20.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {

    @IBOutlet private weak var helloLabel: UILabel!
    
    var user = BehaviorRelay<User>(value: User())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helloLabel.text = "\(user.value.name.value)"
        
    }
    
}
