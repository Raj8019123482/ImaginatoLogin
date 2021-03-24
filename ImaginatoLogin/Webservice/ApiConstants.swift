//
//  ApiConstants.swift
//  ImaginatoLogin
//
//  Created by Raj Rathod on 24/03/21.
//

import Foundation

enum APIConstants: String {
    static let pathTest = "http://imaginato.mocklab.io/"
    case login = "login"

    var url: String {
            return APIConstants.pathTest + rawValue
        }
    
}
