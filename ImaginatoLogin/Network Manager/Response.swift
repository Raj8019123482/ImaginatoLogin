//
//  Response.swift
//  ImaginatoLogin
//
//  Created by Raj Rathod on 24/03/21.
//

import Foundation

final class Empty : Parceable {
    
    var response : [String:AnyObject] = [:]
    init(_ json: [String:AnyObject]) {
        self.response = json
    }
    
    static func parseObject(dictionary: [String : AnyObject]) -> Empty? {
        return Empty(dictionary)
    }
}

class Response<T: Parceable> {
    
    var status: String?
    var message: String?
    var object: T?
    var objects: [T]?

    func parse(json dictionary: [String:AnyObject]) -> (Result<Response<T>, ErrorResult>) {
        print(dictionary)
        // parse json

        if let message = dictionary["error_message"] as? String {
            self.message = message
        }
        // check response for dictionary
        if let response = dictionary["data"] as? [String:AnyObject]  {
            self.object = T.parseObject(dictionary: response)
        }

        // check response for array
        if let response = dictionary["data"] as? [[String:AnyObject]]  {
            self.objects = []
            response.forEach {
                if let obj = T.parseObject(dictionary:$0) {
                    self.objects?.append(obj)
                }
            }
        }
        
        // check status
        if let status = dictionary["result"] as? Int {
            self.status = status == 1 ? "success" : "fail"
        }
        return Result.success(self)
    }
}
