//
//  Converter.swift
//  JSONParser
//
//  Created by 이동영 on 30/05/2019.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

protocol Converter {
    associatedtype Before
    associatedtype After
    
    func convert(before: Before) -> After?
}
