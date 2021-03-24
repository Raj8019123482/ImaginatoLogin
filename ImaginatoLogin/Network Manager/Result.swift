//
//  Result.swift
//  ImaginatoLogin
//
//  Created by Raj Rathod on 24/03/21.
//

import Foundation

typealias Parameters = [String:Any]

enum Result <T , E: Error> {
    case success(T)
    case failure(E)
}
