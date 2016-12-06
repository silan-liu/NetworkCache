//
//  EndPoint.swift
//  NetworkCache
//
//  Created by Eden on 16/12/6.
//  Copyright © 2016年 Eden. All rights reserved.
//

import Foundation

enum HttpMethod {
    case GET
    case POST
    
    var method: String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        }
    }
}

struct EndPoint<A> {
    var url: URL
    var httpMethod: HttpMethod = .GET
    var parse: (Data) -> A?
}

extension EndPoint {
    public init(url: URL, parse: @escaping (Any) -> A?) {
        self.url = url;
        self.parse = { data in

            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())

            let result = json.flatMap(parse)
            return result
        }
    }
    
    public init(url: URL, parseData: @escaping (Data) -> A?) {
        self.url = url
        self.parse = parseData
    }
}

extension EndPoint {
    var cacheKey: String {
        return "cache" + String(url.hashValue)
    }
}
