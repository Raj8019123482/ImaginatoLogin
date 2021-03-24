//
//  User.swift
//  ImaginatoLogin
//
//  Created by Raj Rathod on 24/03/21.
//

import ObjectMapper

struct User: Mappable {

    var userId: Int = Int.min
    var userName: String = ""
    var created_at: String!

    init?(map: Map) {
        if map.JSON["id"] == nil || map.JSON["email"] == nil {
            return nil
        }
    }
    mutating func mapping(map: Map) {
        userId <- map["userId"]
        userName <- map["userName"]
        created_at <- map["created_at"]
    }

    init(id: Int, name: String, created: String) {
        self.userId = id
        self.userName = name
        self.created_at = created
    }
}
