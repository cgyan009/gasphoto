//
//  Api.swift
//  GasPhoto
//
//  Created by Chenguo Yan on 2020-02-26.
//  Copyright © 2020 Chenguo Yan. All rights reserved.
//

import Foundation

fileprivate typealias dictionary = [String : Any]

class API {
    
    static let shared = API()
    private init() {}
    
    enum ApiError: Error {
        case serviceError
        case decodeError
        case jsonSerializationError
        case urlError
        case dataError
    }
    
    private enum Constants {
        static let scheme = "https"
        static let host = "pixabay.com"
        static let path = "/api/"
        static let userKey = "15402780-ae82d240934309c7944e89e4f"
        static let keyName = "key"
        static let keyWordsName = "q"
        static let imageTypeName = "image_type"
        static let imageTypeValue = "photo"
        static let pageName = "page"
        static let httpGetMethod = "GET"
    }
    
    private func execute(
        request: URLRequest,
        completion: @escaping (Result<dictionary, Error>) -> Void
    ) {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, 200...226 ~= httpResponse.statusCode else {
                completion(.failure(ApiError.serviceError))
                return
            }
            guard let data = data, error == nil else {
                completion(.failure(ApiError.dataError))
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? dictionary else {
                    completion(.failure(ApiError.jsonSerializationError))
                    return
                }
                completion(.success(json))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchData<T: Decodable>(
        with keyWords: String?,
        pageNo: Int,
        completionHandler: @escaping (Result<T, Error>) -> Void
    ) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.path
        let keyItem = URLQueryItem(name: Constants.keyName, value: Constants.userKey)
        let qItem = URLQueryItem(name: Constants.keyWordsName, value: keyWords)
        let imageTypeItem = URLQueryItem(name: Constants.imageTypeName, value: Constants.imageTypeValue)
        let pageItem = URLQueryItem(name: Constants.pageName, value: "\(pageNo)")
        urlComponents.queryItems = [keyItem, qItem, imageTypeItem, pageItem]
        
        guard let url = urlComponents.url else {
            print(ApiError.urlError)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.httpGetMethod
        execute(request: request) { (result) in
            switch result {
            case .success(let dict):
                do {
                    let data = try JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
                    let model = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(model))
                } catch {
                    completionHandler(.failure(ApiError.decodeError))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
