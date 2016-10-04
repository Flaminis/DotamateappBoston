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


class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBAction fileprivate func hideKeyboardGesture(_ sender: UITapGestureRecognizer) {
          view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func fromEmailToNext(_ sender: UITextField) {
        textFieldShouldReturn(sender)
    }
    
    @IBAction func fromPasswordToNext(_ sender: UITextField) {
        textFieldShouldReturn(sender)
    }
    
    @IBAction func fromUsernameToNext(_ sender: UITextField) {
        textFieldShouldReturn(sender)
    }
    
    @IBAction func finishedAddingSteamID(_ sender: UITextField) {
        textFieldShouldReturn(sender)
    }

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var steamIDField: UITextField!
    
    @IBOutlet weak var avatarTap: UIImageView!
    
     var actIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.attributedPlaceholder = NSAttributedString(string: "Email  *", attributes: [NSForegroundColorAttributeName : UIColor.gray])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Choose your password    *", attributes: [NSForegroundColorAttributeName : UIColor.gray])
        usernameField.attributedPlaceholder = NSAttributedString(string: "Choose your username    *", attributes: [NSForegroundColorAttributeName : UIColor.gray])
        steamIDField.attributedPlaceholder = NSAttributedString(string: "SteamID (Optional)", attributes: [NSForegroundColorAttributeName : UIColor.gray])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)

        //tap for image
        avatarTap.layer.cornerRadius = avatarTap.frame.size.height/2
        avatarTap.clipsToBounds = true
        avatarTap.image = UIImage(named: "DotaMateLOgo")!

        let avaTap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        avatarTap.isUserInteractionEnabled = true
        avatarTap.addGestureRecognizer(avaTap)
    }
    
    //MARK: PickerImage
    func loadImg(_ recognizer: UITapGestureRecognizer) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        avatarTap.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   //MARK: Actions
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)

        let username = self.usernameField.text
        let password = self.passwordField.text
        let email = self.emailField.text
        let steamIDField = self.steamIDField.text
        
        if((username?.characters.count<4) || (password?.characters.count<4)) {
            
            let alert = UIAlertController(title: "Invalid!", message:"Username and Password must be longer than 4 charachters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            self.present(alert, animated: true){}
        
        } else {
          
            //spin it babe
            SwiftSpinner.show("Placing Wards!")
            
            //send data to server with related columns
            let newUser = PFUser()
            newUser.username = username
            newUser.password = password
            newUser.email = email?.lowercased()
            newUser["SteamID"] = steamIDField?.lowercased()
            
            //edited later on
            newUser["mmr"] = ""
            let avaData = UIImageJPEGRepresentation(avatarTap.image!, 0.5)
            let avaFile = PFFile(name: "ava.jpg", data: avaData!)
            newUser["avatar"] = avaFile
            newUser["upvotes"] = 0
            //saveonServer
            
            newUser.signUpInBackground(block: { (succeed, error) in
               
                if ((error) != nil){
                    
                    SwiftSpinner.hide()
                    //error
                    let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                    self.present(alert, animated: true){}
        
                } else {
                 
                    SwiftSpinner.hide()

                    //remember logged user
                    UserDefaults.standard.set(newUser.username, forKey: "username")
                    UserDefaults.standard.synchronize()
                    
                    //call login func from AppDelegate class & open up
                    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.login()
                    
                }
            })
        }
    }
}
