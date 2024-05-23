//
//  FollowerListViewModel.swift
//  GHProgrammatic
//
//  Created by Umut Ulaş Demir on 18.05.2024.
//

import Foundation

protocol FollowerListViewModelDelegate: AnyObject {
    func didUpdateFollowers()
    func didFailWithError(_ error: ErrorMessage)
    func showLoading()
    func hideLoading()
    func showEmptyState(message: String)
}

class FollowerListViewModel {
    weak var delegate: FollowerListViewModelDelegate?
    
    private let followerService: FollowerService
    
    var username: String?
    var followers: [FollowerEntity] = []
    var filteredFollowers: [FollowerEntity] = []
    var page: Int = 1
    var hasMoreFollowers = true
    
    init(delegate: FollowerListViewModelDelegate, followerService: FollowerService = FollowerService()) {
        self.delegate = delegate
        self.followerService = followerService
    }
    
    func getFollowers(username: String, page: Int) {
        delegate?.showLoading()
        followerService.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let followers):
                if followers.count < 50 { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                
                if followers.isEmpty {
                    let message = "This user doesn't have any followers. Go follow them 😃."
                    DispatchQueue.main.async {
                        self.delegate?.showEmptyState(message: message)
                    }
                }
                
                self.filteredFollowers = self.followers
                self.delegate?.didUpdateFollowers()
            case .failure(let errorMessage):
                self.delegate?.didFailWithError(errorMessage)
            }
        }
    }
    
    func filterFollowers(with filter: String) {
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        delegate?.didUpdateFollowers()
    }
}
