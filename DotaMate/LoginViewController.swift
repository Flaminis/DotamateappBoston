//
//  SignUpViewController.swift
//  DotaMate
//
//  Created by Yerbol Kopzhassar on 08/07/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit
import Parse
import SwiftSpinner
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



//TODO: Add placeholder texts to constant file

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    var actIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150)) as UIActivityIndicatorView
    var canlogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.gray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.gray])
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
        
        view.addSubview(self.actIndicator)
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBackAction(_ sender: UIButton) {}
    //MARK: - LoginAction
    @IBAction func loginWithDataAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        var username = self.userNameTextField.text
        let password = self.passwordTextField.text
        
        if((username?.characters.count<4) || (password?.characters.count<4)) {
            let alert = UIAlertController(title: "Invalid!", message:"Email and Password must be longer than 6 charachters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            self.present(alert, animated: true){}
        
        } else {
            SwiftSpinner.show("Ganking Mid")
            
            let emailToUNM = PFQuery (className: "_User")
            emailToUNM.whereKey("email", equalTo: "\(username!)")
            emailToUNM.getFirstObjectInBackground(block: { (user, error) in
                
                if error==nil {
                    username = String(describing: (user?.value(forKey: "username"))!)
                    self.canlogin = true
                    
                    PFUser.logInWithUsername(inBackground: username!, password: password!, block: { (user, error) in
                        SwiftSpinner.hide()
                        
                        if ((user) != nil) {
                            //remember user
                            UserDefaults.standard.set(user!.username, forKey: "username")
                            UserDefaults.standard.synchronize()
                            
                            //call login func
                            let appDelegate : AppDelegate = UIApplication.shared.delegate as!AppDelegate
                            appDelegate.login()
                            
                        } else {
                            var alert:UIAlertController
                            
                            alert = UIAlertController(title: "Login Failed", message:"Unable to login, either email or password is incorrect. Have you signed up for a DotaMate account?", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                            self.present(alert, animated: true){}
                        }
                        
                    })
                    
                } else {
                    
                    SwiftSpinner.hide()
                    let   alert = UIAlertController(title: "Login Failed", message:"Unable to login, either email or password is incorrect. Have you signed up for a DotaMate account?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                    self.present(alert, animated: true){}

                }
            })
        }
    }
}
