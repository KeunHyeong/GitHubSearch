//
//  Agent.swift
//  RememberTest
//
//  Created by 장근형 on 2/5/25.
//

import Alamofire
import Combine
import Foundation

struct APIResponse<T: Decodable>: Decodable {
    var data: T?
}

enum APIError: Error {
    case http(ErrorData)
    case unknown
}

struct ErrorData: Codable {
    var responseCode: Int?
    var message: String?
    var etc: String?
    var reason: String?
    var path: String?
    var extraError: ExtraError?
}

struct ExtraError: Codable {
    var code: String?
    var message: String?
    var extraMessage: String?
}

struct Agent {
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func run<T: Decodable>(_ request: DataRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, APIError> {
        return request
            .validate()
            .publishData(emptyResponseCodes: [200, 201, 204, 205])
            .tryMap { result -> Response<T> in
                if let request = result.request,
                   let method = request.method,
                   let url = request.url {
                    var log = String()
                    log.append("\(method.rawValue) \(url.path)")
                    if let query = url.query {
                        log.append("?\(query)")
                    }
                    print(log)
                    
                    if let bodyData = request.httpBody {
                        print("Request Body : \(String(decoding: bodyData, as: UTF8.self))")
                    }
                }
                
                if let error = result.error {
                    if let errorData = result.data {
                        var value = try decoder.decode(ErrorData.self, from: errorData)
                        value.responseCode = error.responseCode
                        throw APIError.http(value)
                    } else {
                        throw error
                    }
                }
                
                // 응답이 성공이고 result가 있을 때
                if let data = result.data {
                    do {
                        let responseValue = try decoder.decode(APIResponse<T>.self, from: data)
                        
                        // APIResponse.data가 있을 때
                        if let value = responseValue.data {
                            return Response(value: value, response: result.response!)
                        } else {
                            guard let emptyValue = Empty.emptyValue() as? T else {
                                throw APIError.unknown
                            }
                            
                            return Response(value: emptyValue, response: result.response!)
                        }
                    } catch {
                        print(error)
                        guard let emptyValue = Empty.emptyValue() as? T else {
                            throw APIError.unknown
                        }
                        
                        return Response(value: emptyValue, response: result.response!)
                        
                    }
                }
                // 응답이 성공이고 result가 없을 때 Empty를 리턴
                else {
                    return Response(value: Empty.emptyValue() as! T, response: result.response!)
                }
            }
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    print("API Error - \(apiError)")
                    return apiError
                } else {
                    print("Error - \(error.localizedDescription)")
                    return .unknown
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
