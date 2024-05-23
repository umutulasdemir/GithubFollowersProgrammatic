//
//  UserInfoViewModel.swift
//  GHProgrammatic
//
//  Created by Umut Ulaş Demir on 21.05.2024.
//

import Foundation

protocol UserInfoViewModelDelegate: AnyObject {
    func didReceiveUserInfo(_ user: UserEntity)
    func didFailWithError(_ error: ErrorMessage)
    func showLoading()
    func hideLoading()
}

class UserInfoViewModel {
    weak var delegate: UserInfoViewModelDelegate?
    private let userService: UserService
    
    var username: String
    
    init(username: String, delegate: UserInfoViewModelDelegate, userService: UserService = UserService()) {
        self.username = username
        self.delegate = delegate
        self.userService = userService
    }
    
    func getUserInfo() {
        delegate?.showLoading()
        userService.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            self.delegate?.hideLoading()
            
            switch result {
            case .success(let user):
                self.delegate?.didReceiveUserInfo(user)
            case .failure(let error):
                self.delegate?.didFailWithError(error)
            }
        }
    }
}
