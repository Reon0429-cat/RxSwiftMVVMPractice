//
//  GitHubRepository.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/22.
//

import Foundation
import RxSwift

final class GitHubRepository {
    
    private let baseUrlString = "https://api.github.com"
    
    func getRepos() -> Observable<[Repo]> {
        guard let url = URL(string: baseUrlString + "/repositories") else { abort() }
        return NetworkService().execute(url: url)
    }
    
    func getBranches(ownerName: String, repoName: String) -> Observable<[Branch]> {
        guard let url = URL(string: baseUrlString + "/repos/\(ownerName)/\(repoName)/branches") else { abort() }
        return NetworkService().execute(url: url)
    }
    
}
