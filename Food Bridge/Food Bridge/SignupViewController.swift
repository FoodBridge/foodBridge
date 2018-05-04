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
    
    @IBAction func signup(_ sender: UIButton) {
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
        let formdata = Formdata(email: self.email.text!, password: self.password.text!)
        
        queue.async {
            guard let uploadData = try? JSONEncoder().encode(formdata) else {
                return
            }
            
            let api = (self.userDefaults.url(forKey: "apiAdress")!).appendingPathComponent("/api/users")
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
                                        self.userDefaults.set(token, forKey: "token")
                                        print(self.userDefaults.string(forKey: "token"))
                                    }
                               }
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
