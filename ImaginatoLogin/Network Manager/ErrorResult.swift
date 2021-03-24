//
//  ErrorResult.swift
//  ImaginatoLogin
//
//  Created by Raj Rathod on 24/03/21.
//

import Foundation

enum ErrorResult: Error {
    
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
    case cancel
    
    var message: String {
        switch self {
        case .network(let string):
            return string
        case .parser(let string):
            return string
        case .custom(let string):
            return string
        case .cancel:
            return ""
        }
    }
}
