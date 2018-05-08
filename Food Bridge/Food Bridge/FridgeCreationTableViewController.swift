//
//  FridgeCreationTableViewController.swift
//  Food Bridge
//
//  Created by iosdev on 18.4.2018.
//  Copyright © 2018 FoodBridge. All rights reserved.
//

import UIKit

class FridgeCreationTableViewController: UITableViewController {
    
    
    
    //MARK: Properties
    var foodItems = [Food]()

    override func viewDidLoad() {
        super.viewDidLoad()


        // Swipe
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)

        
        loadSampleFoodItems()
   
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return foodItems.count
    }
    
    //MARK: Private methods
    private func loadSampleFoodItems() {
        
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "FoodItemTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? FoodItemTableViewCell  else {
                fatalError("The dequeued cell is not an instance of FoodItemTableViewCell")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let food = foodItems[indexPath.row]

        cell.textLabel?.text = String(describing: food.category)
        cell.detailTextLabel?.text = food.description
        cell.imageView?.image = food.picture
        
        return cell
    }
    
    @IBAction func uploadFridge(_ sender: UIBarButtonItem) {
        let fridge = Fridge(foods: foodItems, name: "test", description: "also test")
        foodItems.removeAll()
        self.tableView.reloadData()
        ServerConnection.uploadFridge(fridge: fridge, callback: callB)
        
    }
    
    func callB () {
        print("maybe worked")
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func addFoodItem (segue: UIStoryboardSegue ){
        if let sender = segue.source as? FoodCreationViewController{
            if let newItem = sender.food {
                self.foodItems.append(newItem)
                print(sender.food?.description)
                print("added here")
                self.tableView.reloadData()
            }
            
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

 }*/
 }
