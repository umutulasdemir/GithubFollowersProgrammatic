//
//  UserService.swift
//  GHProgrammatic
//
//  Created by Umut Ulaş Demir on 21.05.2024.
//

import Foundation

class UserService {
    private let networkManager = NetworkManager.shared
    
    func getUserInfo(for username: String, completion: @escaping (Result<UserEntity, ErrorMessage>) -> Void) {
        let endpoint = APIEndpoints.user(username: username)
        networkManager.request(endpoint: endpoint, completion: completion)
    }
}
