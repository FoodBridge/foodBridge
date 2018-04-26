//
//  ViewController.swift
//  Food Bridge
//
//  Created by iosdev on 10.4.2018.
//  Copyright © 2018 FoodBridge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Rounding corners of the button
        loginButton.layer.cornerRadius = 5
        loginButton.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

