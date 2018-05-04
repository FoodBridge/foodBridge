//
//  FoodCreationViewController.swift
//  Food Bridge
//
//  Created by iosdev on 18.4.2018.
//  Copyright © 2018 FoodBridge. All rights reserved.
//

import UIKit
import Foundation


class FoodCreationViewController: UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {


    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    var fakeCats = [String]()

    
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var takePicture: UIButton!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var choosePicture: UIButton!

    @IBOutlet weak var imageOutlet: UIImageView!
    var food: Food?
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let food = Food(picture: #imageLiteral(resourceName: "defaultPhoto"), category: Category.Category1, description: "IKEA Veggie Balls") else {
            fatalError("Unable to instantiate food1")
        }
        self.food = food
        print("data generated")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getCategories()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self

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
    
    
    
    @IBAction func openCameraButton(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            activityIndicatorView.startAnimating()
            
            
            let imagePickerController = UIImagePickerController()
            
            // Only allow photos to be picked, not taken.
            imagePickerController.sourceType = .camera
            
            // Make sure ViewController is notified when the user picks an image.
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func openPhotoLibraryButton(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            activityIndicatorView.startAnimating()
            let imagePickerController = UIImagePickerController()
            
            // Only allow photos to be picked, not taken.
            imagePickerController.sourceType = .photoLibrary
            
            // Make sure ViewController is notified when the user picks an image.
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
        activityIndicatorView.stopAnimating()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        imagePicked.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        activityIndicatorView.stopAnimating()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fakeCats.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: fakeCats[row])
    }
    
    func getCategories(){
        fakeCats.append("Banana")
        fakeCats.append("Cocos")
        fakeCats.append("Lemon")
        fakeCats.append("Orange")
        fakeCats.append("Strawberry")
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

}
