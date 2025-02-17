//
//  APIInterceptor.swift
//  RememberTest
//
//  Created by 장근형 on 2/5/25.
//

import Alamofire
import Foundation

// MARK: - API Interceptor
final class APIInterceptor: RequestInterceptor {
    func adapt(
        _ urlRequest: URLRequest,
        for session: Alamofire.Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var modifiedRequest = urlRequest
        modifiedRequest.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        completion(.success(modifiedRequest))
    }
}
