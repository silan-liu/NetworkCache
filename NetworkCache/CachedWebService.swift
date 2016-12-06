//
//  CachedWebService.swift
//  NetworkCache
//
//  Created by Eden on 16/12/6.
//  Copyright © 2016年 Eden. All rights reserved.
//

import Foundation

struct FileStorage {
    
    let baseUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    subscript(key: String) -> Data? {
        get {
            let url = baseUrl.appendingPathComponent(key)
            print("url", url)
            return try? Data(contentsOf: url)
        }
        
        set {
            let url = baseUrl.appendingPathComponent(key)
            
            try? newValue?.write(to: url)
        }
    }
}

class Cache {
    var fileStorage = FileStorage()
    
    func save<A>(_ data: Data, for endpoint: EndPoint<A>) {
        guard case .GET = endpoint.httpMethod else { return }
        fileStorage[endpoint.cacheKey] = data
    }
    
    func load<A>(_ endpoint: EndPoint<A>) -> A? {
        guard case .GET = endpoint.httpMethod else { return nil }
        let data = fileStorage[endpoint.cacheKey]
        return data.flatMap(endpoint.parse)
    }
}

class CachedWebService {
    let webService: WebSevice
    let cache: Cache = Cache()
    
    init(_ webService: WebSevice) {
        self.webService = webService
    }
    
    func load<A>(_ endpoint: EndPoint<A>, completion: @escaping (Result<A>) -> Void) {
        // load from cache
        if let data = cache.load(endpoint) {
            print("exit cache")
            completion(.success(data))
            return
        }
        
        let newEndpoint = EndPoint<Data>(url: endpoint.url, parseData: { $0 })
        
        webService.load(newEndpoint, completion: { result in
            switch result {
            case .error(let error):
                completion(.error(error))
            
            case let .success(data):
                self.cache.save(data, for: endpoint)
                completion(Result(endpoint.parse(data), or: WebSeviceError.Other))
            }
        })
    }
}
