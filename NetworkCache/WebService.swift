//
//  WebService.swift
//  NetworkCache
//
//  Created by Eden on 16/12/6.
//  Copyright © 2016年 Eden. All rights reserved.
//

import Foundation

enum Result<A> {
    case success(A)
    case error(Error)
}

extension Result {
    init(_ value: A?, or error: Error) {
        if let value = value {
            self = .success(value)
        } else {
            self = .error(error)
        }
    }
    
    var value: A? {
        guard case .success(let v) = self else {
            return nil
        }
        
        return v
    }
}

enum WebSeviceError: Error {
    case NotAuthenticated
    case Other
}

class WebSevice {
    func load<A>(_ endpoint: EndPoint<A>, completion: @escaping (Result<A>) -> Void) {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        
        urlSession.dataTask(with: endpoint.url, completionHandler: { data, rsp, err in
            
            let result: Result<A>
            
            if let rsp = rsp as? HTTPURLResponse, rsp.statusCode == 401 {
                result = Result.error(WebSeviceError.NotAuthenticated)
            } else {
                let parsedData = data.flatMap(endpoint.parse);
                result = Result(parsedData, or: WebSeviceError.Other)
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }).resume()
    }
}
