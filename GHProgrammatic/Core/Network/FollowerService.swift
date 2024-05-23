//
//  FollowerService.swift
//  GHProgrammatic
//
//  Created by Umut Ulaş Demir on 21.05.2024.
//

import Foundation

class FollowerService {
    private let networkManager = NetworkManager.shared
    
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[FollowerEntity], ErrorMessage>) -> Void) {
        let endpoint = APIEndpoints.followers(username: username, page: page)
        networkManager.request(endpoint: endpoint, completion: completion)
    }
}
