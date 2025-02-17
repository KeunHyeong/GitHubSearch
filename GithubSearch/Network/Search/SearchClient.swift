//
//  SearchClient.swift
//  RememberTest
//
//  Created by 장근형 on 2/5/25.
//

import Alamofire
import Foundation

class SearchClient: APIClient {
    static func getGithubUsers(_ name: String) async throws -> [GitHubUser] {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "q", value: name)]
        
        guard let finalURL = components?.url else {
            throw URLError(.badURL)
        }
        
        let request = AF.request(finalURL, interceptor: APIInterceptor())
        return try await withCheckedThrowingContinuation { continuation in
            request.responseDecodable(of: GitHubResponse.self) { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data.items)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}


