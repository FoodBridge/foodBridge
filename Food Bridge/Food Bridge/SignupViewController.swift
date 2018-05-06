//
//  SignupViewController.swift
//  Food Bridge
//
//  Created by iosdev on 23.4.2018.
//  Copyright © 2018 FoodBridge. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var password: UITextField!
    let userDefaults = UserDefaults.standard

    
    struct Formdata: Codable{
        let email: String
        let password: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDefaults.set(URL(string:"https://food-recycling.herokuapp.com"), forKey: "apiAdress")
        // Do any additional setup after loading the view.
        
        
        //Notification for the keyboard
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //Keyboard actions
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            animateViewMoving(up: true, moveValue: keyboardHeight)
        }
    }
    
    @objc func keyboardWillDissappear(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            animateViewMoving(up: false, moveValue: keyboardHeight)
            
        }
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
 
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func errorMessage (message msg:String){
        errorMsg.text = msg
    }
    
    func onSignUp(result: StringError) {
        switch result {
        case .String(let token):
            print(token)
            userDefaults.setValue(token, forKey: "AuthToken")
            performSegue(withIdentifier: "signedUp", sender: self)
        case .Error(let error):
            print(error)
        }
    }
    
    @IBAction func signup(_ sender: UIButton) {
        ServerConnection.signUp(email: email.text!, password: password.text!, callback: onSignUp)
    }
}
