//
//  NetworkManager.swift
//  NewsApplication
//
//  Created by Aisha Karzhauova on 23.11.2024.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://newsapi.org/v2/"
    private let apiKey = "334eb8884fe74c68ad4e23f4594b8101"

    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        let endpoint = "\(baseURL)everything?q=technology&apiKey=\(apiKey)"

        AF.request(endpoint).responseDecodable(of: NewsResponse.self) { response in
            switch response.result {
            case .success(let newsResponse):
                completion(.success(newsResponse.articles))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
