//
//  FridgeFeedViewController.swift
//  Food Bridge
//
//  Created by iosdev on 24.4.2018.
//  Copyright © 2018 FoodBridge. All rights reserved.
//

import UIKit

class FridgeFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    
    
    //MARK: Properties
    var foodItems = [Food]()
    
    
    var filteredFoodItems = [Food]()
    
    @IBOutlet
    var tableView: UITableView!
    
    
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
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
        
        loadSampleFoodItems()
        
        
        filteredFoodItems = foodItems
       
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.searchBarStyle = .minimal
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: Private methods
    private func loadSampleFoodItems() {
        let photo1 = UIImage(named: "defaultPhoto")
        let photo2 = UIImage(named: "defaultPhoto")
        let photo3 = UIImage(named: "defaultPhoto")
        
        guard let food1 = Food(picture: #imageLiteral(resourceName: "defaultPhoto"), category: Category.Category1, description: "IKEA Veggie Balls") else {
            fatalError("Unable to instantiate food1")
        }
        
        guard let food2 = Food(picture: #imageLiteral(resourceName: "defaultPhoto"), category: Category.Category1, description: "IKEA Veggie Balls") else {
            fatalError("Unable to instantiate food1")
        }
        
        guard let food3 = Food(picture: #imageLiteral(resourceName: "defaultPhoto"), category: Category.Category1, description: "IKEA Veggie Balls") else {
            fatalError("Unable to instantiate food1")
        }
        
        foodItems += [food1, food2, food3]
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
    
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFoodItems.count
    }
    
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fridges[section]
    }
    */
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "PlainCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? FridgeFeedTableViewCell  else {
                fatalError("The dequeued cell is not an instance of FoodItemTableViewCell")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let food = filteredFoodItems[indexPath.row]
        
        cell.textLabel?.text = String(describing: food.category)
        cell.detailTextLabel?.text = food.description
        cell.imageView?.image = food.picture
        
        return cell
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            filteredFoodItems = foodItems
        }
        else {
            filteredFoodItems = foodItems.filter({ $0.description.lowercased().contains(searchController.searchBar.text!.lowercased()) || String(describing: $0.category).description.lowercased().contains(searchController.searchBar.text!.lowercased()) })
        }
        self.tableView.reloadData()
    }
    
    
    
}
