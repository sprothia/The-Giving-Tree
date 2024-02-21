//
//  SignInViewController.swift
//  The Giving Tree
//
//  Created by Siddharth Prothia on 12/23/23.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.textAlignment = .center
        passwordTF.textAlignment = .center
        
        passwordTF.layer.shadowColor = UIColor.black.cgColor
        passwordTF.layer.shadowOffset = CGSize(width: 0, height: 2)
        passwordTF.layer.shadowOpacity = 0.8
        passwordTF.layer.shadowRadius = 3
        
        emailTF.layer.shadowColor = UIColor.black.cgColor
        emailTF.layer.shadowOffset = CGSize(width: 0, height: 2)
        emailTF.layer.shadowOpacity = 0.8
        emailTF.layer.shadowRadius = 3
    }
   
    
    @IBAction func login(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { [weak self] authResult, error in
            
          guard let strongSelf = self else { return }
          if let error = error {
            print("Error signing in: \(error.localizedDescription)")
            return
          }
          // User was signed in successfully
          if let user = authResult?.user {
            print("User signed in: \(user.email ?? "")")
            self?.goToHomeEventViewController()
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
    

}
