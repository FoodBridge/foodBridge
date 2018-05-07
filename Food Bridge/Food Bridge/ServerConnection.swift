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
    
    static let baseApi = URL(string: "https://food-recycling.herokuapp.com")
    
    static var userDefaults = UserDefaults.standard
    
    static var token: String{
        get{
            return userDefaults.string(forKey: "AuthToken")!
        }
    }
    
    
    static func logIn (email:String, password: String, callback: @escaping (StringError)->()){
        struct Formdata: Codable{
            let email: String
            let password: String
        }
        
        let formdata = Formdata(email: email, password: password)
        
        guard let uploadData = try? JSONEncoder().encode(formdata) else {
            let error = StringError.Error("can't parse into json")
            callback(error)
            return
        }
        
        let api = baseApi!.appendingPathComponent("/api/auth/login")
        print(api)
        var request = URLRequest(url: api)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    let dataString = String(data: data!, encoding: .utf8)
                    print (dataString)
                    return
            }
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
                let jsonresponse = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = jsonresponse as? [String:Any]{
                    if let nestedArray = dictionary["tokens"] as? [Any] {
                        if let firstObject = nestedArray.first {
                            if let finalDictionary = firstObject as? [String:Any]{
                                if let token = finalDictionary["token"] as? String {
                                    DispatchQueue.main.async {
                                        callback(StringError.String(token))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        task.resume()
        
        
    }
    
    static func signUp (email:String, password: String, callback: @escaping (StringError)->()){
        
        struct Formdata: Codable{
            let email: String
            let password: String
        }
        
        let formdata = Formdata(email: email, password: password)
        
        guard let uploadData = try? JSONEncoder().encode(formdata) else {
            let error = StringError.Error("can't parse into json")
            DispatchQueue.main.async {
                callback(error)
            }
            return
        }
        
        let api = baseApi!.appendingPathComponent("/api/users")
        print(api)
        var request = URLRequest(url: api)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
                let jsonresponse = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = jsonresponse as? [String:Any]{
                    if let nestedArray = dictionary["tokens"] as? [Any] {
                        if let firstObject = nestedArray.first {
                            if let finalDictionary = firstObject as? [String:Any]{
                                if let token = finalDictionary["token"] as? String {
                                    DispatchQueue.main.async {
                                        callback(StringError.String(token))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    
    
    
    static func fetchFridges (callback: @escaping ([Fridge])->()){
        var fetchedFridges = [Fridge]()
        
        let url = (baseApi!.appendingPathComponent("/api/fridges"))
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "x-auth")
        
        
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            
            if let error = error {
                print ("error: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print ("error can't parse response")
                fatalError()
            }
            
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
                let jsonresponse = try? JSONSerialization.jsonObject(with: data, options: [])
                if let fridges = jsonresponse as? [Any]{
                    var fridgeMiddleman = [FridgeEXT]()
                    for fridge in fridges {
                        if let fridgeData = fridge as? [String: Any]{
                            
                            guard let foods = fridgeData["posts"] as? [Any] else{
                                print("can't parse foods")
                                continue
                            }
                            
                            if foods.isEmpty{
                                print("empty fridge")
                                continue
                            }
                            
                            guard let description = fridgeData["description"] as? String else{
                                print ("can't parse description")
                                continue
                            }
                            
                            guard let name = fridgeData["name"] as? String else{
                                print ("can't parse name")
                                continue
                            }
                            
                            print("non empty")
                            
                            var foodInFridge = [FoodEXT]()
                            
                            for food in foods {
                                if let foodData = food as? [String:Any]{
                                    guard let description = foodData["description"] as? String else {
                                        print("Can't parse food description")
                                        continue
                                    }
                                    print(description)
                                    
                                    guard let category = foodData["category"] as? String else {
                                        print("Can't parse food category")
                                        continue
                                    }
                                    print(category)
                                    
                                    guard let imgPath = foodData["imgPath"] as? String else {
                                        print("Can't parse food category")
                                        continue
                                    }
                                    
                                    let cat = Category(rawValue: category)
                                    
                                    var foodItem = FoodEXT(picture: #imageLiteral(resourceName: "ImageNotAvailable"), category: cat!, description: description)
                                    
                                    foodItem?.pathData = imgPath
                                    
                                    foodInFridge.append(foodItem!)
                                    
                                }
                            }
                            fridgeMiddleman.append(FridgeEXT(foods: foodInFridge, description: description, name: name))
                        }
                    }
                    var requestCounter = 0
                    var requestTable = [Int:Bool]()
                    var finalFoodFlag = false
                    
                    for fakeFridge in fridgeMiddleman {
                        var finalFoods = [Food]()
                        
                        
                        var finalFoodinFridgeFlag = false
                        var fridgerequestTable = [Int:Bool]()
                        
                        for fakeFood in fakeFridge.foods{
                            
                            requestCounter += 1
                            var foodID = requestCounter
                            requestTable[foodID] = false
                            fridgerequestTable[foodID] = false
                            
                            func onImageFetch (image: UIImage) {
                                finalFoods.append(Food(picture: image, category: fakeFood.category, description: fakeFood.description)!)
                                requestTable[foodID] = true
                                fridgerequestTable[foodID] = true
                                print("appending here")
                                
                                if fakeFridge.foods.last === fakeFood {
                                    
                                    finalFoodinFridgeFlag = true
                                    print("last of the fridge")
                                    
                                    if fridgeMiddleman.last === fakeFridge{
                                        finalFoodFlag = true
                                        print("last fridge")
                                    }
                                }
                                
                                print(fridgerequestTable.values)
                                
                                if finalFoodinFridgeFlag, !fridgerequestTable.values.contains(false){
                                    print("fridge adding happens")
                                    fetchedFridges.append(Fridge(foods: finalFoods, name: fakeFridge.name, description: fakeFridge.description))
                                }
                                
                                if finalFoodFlag, !requestTable.values.contains(false){
                                    DispatchQueue.main.async {
                                        print("callback called")
                                        callback(fetchedFridges.reversed())
                                    }
                                }
                            }
                            
                            
                            downloadPhoto(path: fakeFood.pathData!, callback: onImageFetch)
                            
                        }
                    }
                    
                    
                }
            }
            }
        task.resume()
        }
    

    
    
    static func uploadFridge (fridge: Fridge, callback:@escaping ()->()){
        
        struct jsonData: Codable {
            let description: String
            let name: String
        }
        
        let data = jsonData(description: fridge.description, name: fridge.name)
        guard let uploadData = try? JSONEncoder().encode(data) else {
            print("can't encode json")
            return
        }
        
        let url = (baseApi!.appendingPathComponent("/api/fridges"))
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "x-auth")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            
            if let error = error {
                print ("error: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print ("error can't parse response")
                fatalError()
            }
            
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
                let jsonresponse = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = jsonresponse as? [String:Any]{
                    if let fridgeID = dictionary["_id"] as? String{
                        uploadFoods(fridgeID: fridgeID)
                    }
                }
            }
            
        }
        task.resume()
        
        func uploadFoods(fridgeID: String){
            for food in fridge.foods {
                uploadFood(food: food, fridgeID: fridgeID)
            }
            DispatchQueue.main.async {
                callback()
            }
        }
    }
    
    private static func uploadFood (food: Food, fridgeID: String) {
        
        struct jsonData: Codable{
            let imgPath: String
            let category: String
            let price: Int
            let description: String
            let fridge: String
        }
        
        func callback (photoPath:String){
            print("got here")
            print(photoPath)
            
            let url = (baseApi!.appendingPathComponent("/api/posts"))
            print(url)
            let tempToken = token
            
            if food.description == "" {
                food.description = " "
            }
            
            let data = jsonData(imgPath: photoPath, category: food.category.rawValue, price: 10, description: food.description, fridge: fridgeID)
            
            guard let uploadData = try? JSONEncoder().encode(data) else {
                print("can't encode json")
                return
            }
            
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(tempToken, forHTTPHeaderField: "x-auth")
            
            let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
                
                if let error = error {
                    print ("error: \(error)")
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print ("error can't parse response")
                    fatalError()
                }
                
                print(response)
                
                print(String(data: data!, encoding: .utf8))
                
            }
            task.resume()
        }
        
        uploadPhoto(food.picture, callback: callback)
    }
    
    static func downloadPhoto(path: String, callback:@escaping (UIImage)->()) {
        let url = (baseApi!.appendingPathComponent("/photos/"+path))
        print (url)
        
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print ("error can't parse response")
                fatalError()
            }
            print (response)
            if response.statusCode == 200{
                print("image convertion")
                let image = UIImage(data: data!)
                callback(image!)
            } else {
                callback(#imageLiteral(resourceName: "ImageNotAvailable"))
            }
        }
        task.resume()
    }
    
    private static func uploadPhoto (_ image:UIImage, callback:@escaping (String) -> ()){
        
        let url = (baseApi!.appendingPathComponent("/api/photos/upload"))
        print(url)
        let tempToken = token
        
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
                print ("error can't parse response")
                fatalError()
            }
            
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
                let jsonresponse = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = jsonresponse as? [String:String]{
                    callback(dictionary["filename"]!)
                }
            }
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

private class FoodEXT: Food {
    var pathData: String?
}

private class FridgeEXT {
    var foods: [FoodEXT]
    var description: String
    var name: String
    
    init(foods: [FoodEXT], description: String, name: String) {
        self.foods = foods
        self.description = description
        self.name = name
    }
}

