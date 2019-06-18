//
//  ErrorHandler.swift
//  JSONParser
//
//  Created by 이동영 on 18/06/2019.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

struct ErrorHandler {
    
    func handle(logic: () throws -> ()) {
        var occurError = false
        
        repeat {
            do{
                try logic()
                occurError = false
            }
            catch {
                print(error.localizedDescription)
                occurError = true
            }
        } while occurError
    }
}
