//
//  AppDelegate.swift
//  The Giving Tree
//
//  Created by Siddharth Prothia on 12/19/23.
//

import UIKit

// Issues to Fix
// Tab Bar isnt visible for homeVC when register button in signup/signin vc is pressed
// Is not printing user name properly, for now its just hardcoded

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
//      
//    self.window = UIWindow(frame: UIScreen.main.bounds)
//
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//    if Auth.auth().currentUser != nil {
//          let mainViewController = storyboard.instantiateViewController(withIdentifier: "mainVC") as! MainViewController
//          print("Logged in!")
//          self.window?.rootViewController = mainViewController
//    } else {
//          let loginViewController = storyboard.instantiateViewController(withIdentifier: "signInVC") as! SignInViewController
//          print("Not logged in!")
//          self.window?.rootViewController = loginViewController
//    }
//
//    self.window?.makeKeyAndVisible()
//

    return true
  }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

