//
//  Food.swift
//  Food Bridge
//
//  Created by iosdev on 18.4.2018.
//  Copyright © 2018 FoodBridge. All rights reserved.
//

import Foundation
import UIKit

class Food {
    //MARK: properties
    private let picture: UIImage
    private let category: Category
    private let description: String
    
    init(picture: UIImage, category: Category, description: String) {
        self.category = category
        self.picture = picture
        self.description = description
    }
    
}
