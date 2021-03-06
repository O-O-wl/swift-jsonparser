//
//  Scanner.swift
//  JSONParser
//
//  Created by 이동영 on 25/05/2019.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

protocol Scanner {
    func hasNext() -> Bool
    mutating func backCurser()
    mutating func moveCurser()
    mutating func next() -> Character?
}
