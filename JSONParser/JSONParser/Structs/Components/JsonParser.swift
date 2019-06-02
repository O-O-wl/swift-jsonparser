//
//  MyListParser.swift
//  JSONParser
//
//  Created by 이동영 on 29/05/2019.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

struct JsonParser {
    private var tokens: Array<Token>
    var strategy: JsonParsingStrategy
    
    init(tokens: Array<Token>) {
        self.tokens = tokens
        self.strategy =
            tokens[0] == Token.LeftBraket ?
                JsonListParsingStrategy() : JsonObjectParsingStrategy()
    }
    
    mutating func parse() -> JsonValue {
        self.nomalizeTokens()
        return self.strategy.parse(tokens: self.tokens)
    }
    
    private mutating func nomalizeTokens() {
        self.mergeStringTokens()
        
    }
    
    private mutating func grouping() {
        for token in tokens {
            if token == .LeftBrace {
                
            }
        }
    }
    
    private mutating func mergeStringTokens() {
        var contents = ""
        var removingTokenIndex = MyStack<Int>()
        var isString = false
        for (index, token) in self.tokens.enumerated() {
            if token == .DoubleQuotation {
                isString.toggle()
                if isString == false {
                    self.tokens[index] = .String(contents)
                    contents = ""
                }
                continue
            }
            if isString {
                contents += token.getValue()
                removingTokenIndex.push(index)
            }
        }
        self.remove(indexs: &removingTokenIndex)
    }
    
    private mutating func remove(indexs: inout MyStack<Int>) {
        while let removingIndex = indexs.pop() {
            self.tokens.remove(at: removingIndex)
        }
    }
    
    private mutating func set(strategy: JsonParsingStrategy) {
        self.strategy = strategy
    }
    
}
