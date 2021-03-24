//
//  RequestBuilder.swift
//  ImaginatoLogin
//
//  Created by Raj Rathod on 24/03/21.
//

import Foundation

enum HTTPMethod: String {
    case POST
    case GET
    case PUT
}

final class RequestBuilder {
    
    static let timeoutInterval : TimeInterval = 30
    
    //MARK:- url request builder method
    class func buildRequest(api: APIConstants, method: HTTPMethod = .GET, parameters: [String:Any]?) -> URLRequest? {
        
        guard let requestUrl = URL(string: api.url) else {
            debugPrint("-wrong url format-")
            return nil
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        request.timeoutInterval = RequestBuilder.timeoutInterval
        
        if method == .POST || method == .PUT {
            guard parameters != nil else { return nil }
            self.addPostRequest(parameters ?? [:], request: &request)
        } else {
            self.addGetRequest(request: &request, parameters: parameters ?? [:])
        }
        
        self.printRequest(request, parameters: parameters)
        
        return request
    }
    
    //MARK:- post request method to add data
    class func addPostRequest(_ parameters: [String:Any], request: inout URLRequest) {
            request.allHTTPHeaderFields = ["cache-control":"no-cache", "Content-Type": "application/json"]
            let json = try? JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = json
    }
    
    //MARK:- get request method
    class func addGetRequest(request: inout URLRequest, parameters: [String:Any]) {
        
        if !parameters.isEmpty {
            var getUrl = "\(request.url!.absoluteString)?"
            for (key,value) in parameters {
                getUrl.append("\(key)=\(value)&")
            }
            request.url = URL(string: getUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        }
        
            request.allHTTPHeaderFields = [
                "content-type":"application/json",
                "cache-control":"no-cache"]
    }
    
    class func printRequest(_ request: URLRequest, parameters: [String:Any]?) {
        print("******************************")
        print("url: \(request.url?.absoluteString ?? "invalid url")")
        print("method:\(request.httpMethod ?? "GET")")
        print("headers: \(request.allHTTPHeaderFields ?? [:])")
        if request.httpMethod  != "GET" {
            print("request: \(parameters ?? [:])")
        }
        print("******************************")
    }
    
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
