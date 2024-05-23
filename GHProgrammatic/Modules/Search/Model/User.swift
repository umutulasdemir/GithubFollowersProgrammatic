//
//  User.swift
//  GHProgrammatic
//
//  Created by Umut Ulaş Demir on 18.05.2024.
//

import Foundation

struct UserEntity: Codable {
    let login: String
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let followers: Int
    let following: Int
    let createdAt: String
}
