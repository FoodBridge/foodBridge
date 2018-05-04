//
//  Fridge.swift
//  Food Bridge
//
//  Created by iosdev on 18.4.2018.
//  Copyright © 2018 FoodBridge. All rights reserved.
//

import Foundation

class Fridge {
     let foods: [Food]
     let name: String
     let description: String
    private let time: Any?
    
    init(foods: [Food], name:String, description: String) {
        self.foods = foods
        self.name = name
        self.description = description
        self.time = "test"
    }
}
