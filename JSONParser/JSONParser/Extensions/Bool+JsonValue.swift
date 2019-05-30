//
//  Bool+JsonValue.swift
//  JSONParser
//
//  Created by 이동영 on 30/05/2019.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

extension Bool: JsonValue {
    typealias T = Bool
    
    func getValue() -> Bool {
        return self
    }
}