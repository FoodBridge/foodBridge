//
//  ServerConnection.swift
//  Food Bridge
//
//  Created by iosdev on 26.4.2018.
//  Copyright © 2018 FoodBridge. All rights reserved.
//

import Foundation

class ServerConnection {
    
    static var baseApi = URL(string: "https://food-recycling.herokuapp.com/api")
    
    struct Credentials: Codable {
        let email: String
        let password: String
    }

    static func logIn (email: String, password: String){
        let body = Credentials(email: email, password: password)
        let url = baseApi?.appendPathExtension("/auth/login")
        
        
    }
    
    static func signUp (email: String, password: String){
        
    }
    
    static private func formRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
}
