//
//  FridgeFeedViewController.swift
//  Food Bridge
//
//  Created by iosdev on 24.4.2018.
//  Copyright © 2018 FoodBridge. All rights reserved.
//

import UIKit

class FridgeFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Test arrays
    
    let fridges = ["Sarah's Fridge", "Charlie's Fridge"]
    
    let fridge1 = ["Apple", "Orange", "Mango"]
    let fridge2 = ["Carrot", "Broccoli", "Cucumber"]
    
    let fridge1Description = ["This is an apple", "This orange is orange", "This particular mango tastes very good"]
    let fridge2Description = ["This carrot is rotten", "Broccoli is healthy", "Cucumber is mostly water"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Swipe
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Swipe
    
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if (self.tabBarController?.selectedIndex)! < 3 { // set your total tabs here
                self.tabBarController?.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if (self.tabBarController?.selectedIndex)! > 0 {
                self.tabBarController?.selectedIndex -= 1
            }
        }
    }
    
    
    //Tableview
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fridges[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fridges.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            // Fridge1 Section
            return fridge1.count
        case 1:
            // Fridge2 Section
            return fridge2.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an object of the dynamic cell “PlainCell”
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath)
        // Depending on the section, fill the textLabel with the relevant text
        
        
        
        switch indexPath.section {
        case 0:
            // Fridge1 Section
            // Fridge1 Titles
            cell.textLabel?.text = fridge1[indexPath.row]
            // Fridge1 Descriptions
            cell.detailTextLabel?.text = fridge1[indexPath.row]
            break
        case 1:
            // Fridge2 Section
            //Fridge 2 Titles
            cell.textLabel?.text = fridge2[indexPath.row]
            // Fridge2 Descriptions
            cell.detailTextLabel?.text = fridge2[indexPath.row]
            break
        default:
            break
        }
        // Return the configured cell
        return cell
    }
    
    
}
