//
//  NetworkManager.swift
//  GHProgrammatic
//
//  Created by Umut Ulaş Demir on 18.05.2024.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession = URLSession(configuration: .default)
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func request<T: Decodable>(endpoint: String, completion: @escaping (Result<T, ErrorMessage>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
