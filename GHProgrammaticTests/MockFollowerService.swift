// MockFollowerService.swift

import Foundation
@testable import GHProgrammatic

class MockFollowerService: FollowerService {
    var shouldReturnError = false
    var followers: [FollowerEntity] = []
    
    override func getFollowers(for username: String, page: Int, completion: @escaping (Result<[FollowerEntity], ErrorMessage>) -> Void) {
        if shouldReturnError {
            completion(.failure(.unableComplete))
        } else {
            completion(.success(followers))
        }
    }
}
