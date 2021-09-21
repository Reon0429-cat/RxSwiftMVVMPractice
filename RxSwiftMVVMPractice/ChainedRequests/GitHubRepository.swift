//
//  GitHubRepository.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/22.
//

import Foundation
import RxSwift
import RxCocoa

final class GitHubRepository {
    private let networkService = NetworkService()
    private let baseUrlString = "https://api.github.com"
    
    func getRepos() -> Observable<[Repo]> {
        return networkService.execute(url: URL(string: baseUrlString + "/repositories")!)
    }
    
    func getBranches(ownerName: String, repoName: String) -> Observable<[Branch]> {
        return networkService.execute(url: URL(string: baseUrlString + "/repos/\(ownerName)/\(repoName)/branches")!)
    }
}
