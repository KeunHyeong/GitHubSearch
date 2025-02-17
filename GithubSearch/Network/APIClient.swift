//
//  APIClient.swift
//  RememberTest
//
//  Created by 장근형 on 2/5/25.
//

import Alamofire
import Combine
import Foundation

class APIClient {
    static let agent = Agent()
    
    static let baseURL: URL = URL(string: "https://api.github.com/search/users")!
}
