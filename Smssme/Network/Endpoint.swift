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

}

extension URLComponents {
    mutating func encodePlusSign() {
        if let originalQuery = self.percentEncodedQuery {
            let plusEncodedQuery = originalQuery.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "+").inverted)
            self.percentEncodedQuery = plusEncodedQuery
        }
    }
}

