//
//  Int+JsonValue.swift
//  JSONParser
//
//  Created by 이동영 on 30/05/2019.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

extension Int: JsonValue {
    func describeType() -> String {
        return "숫자"
    }
}

extension Int {
    static postfix func -- (lhs: inout Int) {
        lhs-=1
    }
    static postfix func ++ (lhs: inout Int) {
        lhs+=1
    }
}
