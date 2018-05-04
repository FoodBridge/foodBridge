//
//  ServerConnection.swift
//  Food Bridge
//
//  Created by iosdev on 26.4.2018.
//  Copyright © 2018 FoodBridge. All rights reserved.
//

import Foundation
import UIKit

class ServerConnection {
    
    static var baseApi = URL(string: "https://food-recycling.herokuapp.com")
    
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
    
    static func uploadPhoto (_ image:UIImage){
        let url = (baseApi!.appendingPathComponent("/api/photos/upload"))
        print(url)
        let tempToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1YWRlZDM4MmVhODI4YTAwMTRhODNkNGQiLCJhY2Nlc3MiOiJhdXRoIiwiaWF0IjoxNTI0NTkzMDg0fQ.Lmme7NRg7auKR_9KUud2Tx8jE_yYscxKPFhDo_DwioI"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=---PleaseWork", forHTTPHeaderField: "Content-Type")
        request.setValue(tempToken, forHTTPHeaderField: "x-auth")
        let boundary = "---PleaseWork"
        
        func createBody(
            boundary: String,
            data: Data,
            mimeType: String,
            filename: String) -> Data {
            
            
            
            let body = NSMutableData()
            
            let boundaryPrefix = "--\(boundary)\r\n"
            
            
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"photo\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: \(mimeType)\r\n\r\n")
            body.append(data)
            body.appendString("\r\n")
            body.appendString("--".appending(boundary.appending("--")))
            
            return body as Data
        }
        
        let httpBody = createBody(boundary: boundary,
                                data: UIImageJPEGRepresentation(image, 0.7)!,
                                mimeType: "image/jpg",
                                filename: "hello.jpg")
        
        let task = URLSession.shared.uploadTask(with: request, from: httpBody) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print ("error")
                return
            }
            
            let dataString = String(data: data!, encoding: .utf8)
            print (dataString)
            print(response.statusCode)
            return
            
        }
        task.resume()
    }
    
    
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
