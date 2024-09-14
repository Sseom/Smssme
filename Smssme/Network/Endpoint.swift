//
//  Endpoint.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/14/24.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case dataFetchFail
    case decodingFail
}

enum HTTPMethodType: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

final class Endpoint {
    let baseURL: String
    let method: HTTPMethodType
    let headerParameters: [String: String]
    let path: String
    let queryParameters: [String: String]
    
    init(baseURL: String = "",
         method: HTTPMethodType = .get,
         headerParameters: [String : String] = [:],
         path: String = "",
         queryParameters: [String : String] = [:]
    ) {
        self.baseURL = baseURL
        self.method = method
        self.headerParameters = headerParameters
        self.path = path
        self.queryParameters = queryParameters
    }
    
    func createURL() -> URL? {
        var urlComponents = URLComponents(string: baseURL.appending(path))
        
        var queryItems = [URLQueryItem]()
        
        queryParameters.forEach {
            queryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
            print(queryItems)
        }
        urlComponents?.queryItems = queryItems
        
        return urlComponents?.url
        
    }
    
    func createEndpoint() throws -> URLRequest {
        guard let url = createURL() else { throw NetworkError.invalidUrl }
        print("createEndpoint() -> url:\(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        
        print("encodedUrl \(url)")
        
        // 직접 헤더 추가
        request.allHTTPHeaderFields = headerParameters
        
        return request
    }
}
