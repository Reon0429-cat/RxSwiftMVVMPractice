//
//  APIClient.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/20.
//

import Foundation

enum Result<T, E> where E: Error  {
    case success(T)
    case failure(E)
}

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    var localizedDescription: String {
        switch self {
            case .requestFailed: return "Request Failed"
            case .invalidData: return "Invalid Data"
            case .responseUnsuccessful: return "Response Unsuccessful"
            case .jsonParsingFailure: return "JSON Parsing Failure"
            case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }
}


final class APIClient {
    
    func fetchGenericData<T: Decodable>(urlString: String,
                                        completion: @escaping (Result<T, Error>) -> ()) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { data, resp, err in
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let data = data else { return }
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                completion(.success(obj))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
    
}

