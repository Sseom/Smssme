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
    
    func fetch<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        
        var urlComponents = URLComponents(string: endpoint.baseURL + endpoint.path)!
        
        // 쿼리파라미터 설정
        urlComponents.queryItems = endpoint.queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        urlComponents.encodePlusSign()
        
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
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("서버 오류 상태 코드: \(httpResponse.statusCode)")
                completion(.failure(NetworkError.serverError(httpResponse.statusCode)))
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
