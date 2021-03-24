//
//  UserModel.swift
//  ImaginatoLogin
//
//  Created by Raj Rathod on 24/03/21.
//

import Foundation

final class UserModel: NSObject, Decodable {
    let user : UserData?
}

extension UserModel: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> UserModel? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: UserModel")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(UserModel.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: UserModel")
            return nil
        }
    }
}

final class UserData: NSObject, Codable {
    let userName, created_at: String?
    let userId: Int?
}
extension UserData: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> UserData? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: UserData")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(UserData.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: UserData")
            return nil
        }
    }
}
