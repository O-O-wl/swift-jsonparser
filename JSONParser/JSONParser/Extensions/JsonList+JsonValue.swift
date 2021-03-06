//
//  JsonList+JsonValue.swift
//  JSONParser
//
//  Created by 이동영 on 30/05/2019.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

extension JsonList: JsonValue {
    
    func describeType() -> String {
        return "배열"
    }

    func serialize(indent: Int = 0 ) -> String {
        let ws = String(repeating: "\t", count: indent)
        let prefix = indent != 0 ? "\(ws)":""
        let elements = self.map { "\($0.serialize(indent: indent+1))"}.joined(separator: ", ")
        return "\(prefix)[ \(elements)]"
    }
}

