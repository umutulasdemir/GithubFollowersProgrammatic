//
//  FollowerListViewModel.swift
//  GHProgrammatic
//
//  Created by Umut Ulaş Demir on 18.05.2024.
//

import Foundation

class FollowerListViewModel {
    weak var delegate: FollowerListViewModelDelegate?
    
    var username: String?
    var followers: [FollowerEntity] = []
    var page: Int = 1
    var hasMoreFollowers = true
    
    init(delegate: FollowerListViewModelDelegate) {
        self.delegate = delegate
    }
    
    func getFollowers(username: String, page: Int) {
        delegate?.showLoading()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let followers):
                if followers.count < 50 { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                self.delegate?.didUpdateFollowers()
            case .failure(let errorMessage):
                self.delegate?.didFailWithError(errorMessage)
            }
        }
    }
}
