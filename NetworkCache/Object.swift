//
//  Object.swift
//  NetworkCache
//
//  Created by Eden on 16/12/6.
//  Copyright © 2016年 Eden. All rights reserved.
//

import Foundation

typealias JSONDictonary = [String: Any]

struct Object {
    var title: String
    var id: String
    
    init?(json: JSONDictonary) {
        guard let id = json["id"] as? String,
            let title = json["title"] as? String else {
                return nil
        }
        
        self.title = title
        self.id = id
    }
}
