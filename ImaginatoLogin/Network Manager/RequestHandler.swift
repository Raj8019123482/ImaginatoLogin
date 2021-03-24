//
//  RequestHandler.swift
//  ImaginatoLogin
//
//  Created by Raj Rathod on 24/03/21.
//

import Foundation

class RequestHandler {
    
    class var reachability : Reachability {
        let reachability = Reachability()!
        return reachability
    }
    
    class func networkResult<T: Parceable>(completion: @escaping ((Result<Response<T>, ErrorResult>) -> Void)) ->
        ((Result<Data, ErrorResult>) -> Void) {
            
            return { dataResult in
                
                DispatchQueue.global(qos: .background).async(execute: {
                    switch dataResult {
                    case .success(let data) :
                        ParserHelper.parse(data: data, completion: completion)
                    case .failure(let error) :
                        completion(.failure(.network(string: error.message)))
                    }
                })
            }
    }
}
