//
//  NetworkManager.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/14/24.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    
    //MARK: -Completion Handler를 이용한 방법
    func fetch<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        
        var urlComponents = URLComponents(string: endpoint.baseURL + endpoint.path)!
        
        // 쿼리파라미터 설정
        urlComponents.queryItems = endpoint.queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        // queryItems에서 쿼리 스트링을 추출하여 '+'만 인코딩 -> url 만드는 과정에서 +만 인코딩이 안 됐기 때문
        if let originalQuery = urlComponents.percentEncodedQuery {
            let plusEncodedQuery = originalQuery.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "+").inverted)
            
            // percentEncodedQuery에 +만 인코딩된 쿼리 설정
            urlComponents.percentEncodedQuery = plusEncodedQuery
        }
        
        
        guard let url = urlComponents.url else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
       
        print("✅ url: \(url)")

        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("네트워크 에러")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("data fetch 실패")
                completion(.failure(NetworkError.dataFetchFail))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                print("디코딩 실패")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
