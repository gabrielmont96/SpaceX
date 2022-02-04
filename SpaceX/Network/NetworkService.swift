//
//  Network.swift
//  SpaceX
//
//  Created by Gabriel Monteiro Camargo da Silva - GCM on 16/01/22.
//

import Foundation

protocol Executor {
    func perform(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

class NetworkService<T: NetworkAPI> {
    
    var executor: Executor = URLSession.shared
    
    func request<V: Codable>(target: T, expecting: V.Type, completion: @escaping (Result<V, NetworkError>) -> Void) {
        guard let url = URL(string: "\(target.baseURL)\(target.path)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = target.method.rawValue
        
        for header in (target.headers ?? [:]) {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        executor.perform(with: urlRequest) {  (data, response, error) in
            guard response?.validationStatus == .success else {
                completion(.failure(.api(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -999,
                                         message: String(data: data ?? Data(), encoding: .utf8))))
                return
            }
            
            guard let responseData = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(expecting, from: responseData)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(NetworkError.parseError(error)))
            }
        }.resume()
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }

extension URLSession: Executor {
    func perform(with request: URLRequest,
                 completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler)
    }
}
