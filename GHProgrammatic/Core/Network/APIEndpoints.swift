//
//  APIEndpoints.swift
//  GHProgrammatic
//
//  Created by Umut Ulaş Demir on 21.05.2024.
//

import Foundation

struct APIEndpoints {
    static let base = "https://api.github.com"
    
    static func user(username: String) -> String {
        return "\(base)/users/\(username)"
    }
    
    static func followers(username: String, page: Int) -> String {
        return "\(base)/users/\(username)/followers?per_page=50&page=\(page)"
    }
}
