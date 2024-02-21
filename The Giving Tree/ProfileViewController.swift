//
//  ProfileViewController.swift
//  The Giving Tree
//
//  Created by Siddharth Prothia on 12/23/23.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct UserProfile {
    let name: String
    let events: [UserEvent]
    let points: Int
}

struct UserEvent {
    let date: String
    let description: String
    let location: String
    let name: String
    let points: Int
}

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var points: UILabel!
    
    @IBOutlet weak var myPoints: UILabel!
    
    var myEvents: [UserEvent] = []
    
    @IBOutlet weak var imageView: UIImageView!
    var totalPoints = 0
    
    var images: [UIImage] = [UIImage(named: "dog")!, UIImage(named: "fish")!, UIImage(named: "bee")!, UIImage(named: "horse")!, UIImage(named: "monkey")!, UIImage(named: "parrot")!]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEvents { [weak self] fetchedEvents in
            DispatchQueue.main.async {
                self?.myEvents = fetchedEvents
                print("These are myEvents \(self!.myEvents)")
                self?.tableView.reloadData()
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let randomImage = images.randomElement() {
            imageView.image = randomImage
        }
        
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            print("Current user ID is: \(userId)")
       
            let ref = Database.database().reference()
            
            ref.child("users").child(userId).observeSingleEvent(of: .value, with: { snapshot in
                
                guard let value = snapshot.value as? [String: AnyObject] else {
                    print("No Data Found")
                    return
                }
                
                let name = value["name"] as? String ?? "No Name"
                let points = value["points"] as? Int ?? 0
                
                self.name.text! = name
                print("total pointsss \(self.totalPoints)")
                self.myPoints.text! = String(self.totalPoints)

                
                print("Events: \(value["events"])")
                print("Name: \(name), Points: \(points)")
            }) { error in
                print(error.localizedDescription)
            }
            
            
        } else {
            print("No user is currently logged in.")
        }
        

    }
    
    @IBAction func logout(_ sender: Any) {
        logOutUser()
    }
    
    func getUserProfile(userId: String, completion: @escaping (UserProfile?, Error?) -> Void) {
        let ref = Database.database().reference()
        let userRef = ref.child("users").child(userId)
        var name = ""
        var points = 0
        
        userRef.observeSingleEvent(of: .value) { snapshot, err in
            guard let value = snapshot.value as? [String: Any] else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user found"]))
                return
            }

            name = value["name"] as? String ?? ""
            points = value["points"] as? Int ?? 0

        }
        

            let userProfile = UserProfile(name: name, events: [], points: points)
            completion(userProfile, nil)

        
    }
    
    func fetchEvents(completion: @escaping ([UserEvent]) -> Void) {
        var userId = ""

        if let user = Auth.auth().currentUser {
            userId = user.uid
        } else {
            print("No user is currently logged in.")
        }
        
        let ref = Database.database().reference()
        let userRef = ref.child("users").child(userId)
        let userEventsRef = userRef.child("events")
        
        
        userEventsRef.observeSingleEvent(of: .value) { snapshot in
            var events: [UserEvent] = []

            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let dict = snapshot.value as? [String: Any],
                   let name = dict["name"] as? String,
                   let date = dict["date"] as? String,
                   let points = dict["points"] as? Int {
                   let event = UserEvent(date: date, description: "", location: "", name: name, points: points)
                    events.append(event)
                    self.totalPoints += points
                }
                
            }

            completion(events)
        }

    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userEventCell", for: indexPath) as? ProfileEventsTableViewCell else {
                fatalError("Could not dequeue EventTableViewCell")
            }
        
            
            let event = myEvents[indexPath.row]
            cell.configure(with: event)


            return cell
        
    }
    
    func logOutUser() {
        do {
            try Auth.auth().signOut()
            // Successfully logged out
            print("Succesfully logged out")
            goToLoginViewController()
            // Here you can redirect the user to the login screen or perform other actions
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            // Handle the error, perhaps show an alert to the user
        }
    }
    
    func goToLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "signInVC")
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
               window.rootViewController = loginViewController
               UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: nil)
        }
    }
    

}
