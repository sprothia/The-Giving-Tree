//
//  SignUpViewController.swift
//  The Giving Tree
//
//  Created by Siddharth Prothia on 12/23/23.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.textAlignment = .center
        emailTF.textAlignment = .center
        passwordTF.textAlignment = .center
        
        nameTF.layer.shadowColor = UIColor.black.cgColor
        nameTF.layer.shadowOffset = CGSize(width: 0, height: 2)
        nameTF.layer.shadowOpacity = 0.8
        nameTF.layer.shadowRadius = 1

        emailTF.layer.shadowColor = UIColor.black.cgColor
        emailTF.layer.shadowOffset = CGSize(width: 0, height: 2)
        emailTF.layer.shadowOpacity = 0.8
        emailTF.layer.shadowRadius = 1

        passwordTF.layer.shadowColor = UIColor.black.cgColor
        passwordTF.layer.shadowOffset = CGSize(width: 0, height: 2)
        passwordTF.layer.shadowOpacity = 0.8
        passwordTF.layer.shadowRadius = 1

    }
    
    @IBAction func createAccount(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!) { authResult, error in
          if let error = error {
            print("Error creating user: \(error.localizedDescription)")
            return
          }
            
          // User was created successfully
          if let user = authResult?.user {
              self.addUserToDatabase(userId: user.uid, name: self.nameTF.text!, events: ["Blank Event"], points: 0)
            print("User created: \(user.email ?? "")")
              
            self.goToHomeEventViewController()
          }
        }
        
    }
    
    func goToHomeEventViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "tabBarVC")
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
               window.rootViewController = loginViewController
               UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: nil)
        }
    }
    
    func addUserToDatabase(userId: String, name: String, events: [String], points: Int) {
        let ref = Database.database().reference()
        let userRef = ref.child("users").child(userId)

        let userData: [String: Any] = ["name": name,
                                       "events": events,
                                       "points": points]

        userRef.updateChildValues(userData) { (error, reference) in
            if let error = error {
                print("Data could not be saved: \(error.localizedDescription)")
            } else {
                print("Data saved successfully!")
            }
        }
    }


}
