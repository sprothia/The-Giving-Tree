//
//  EventsViewController.swift
//  The Giving Tree
//
//  Created by Siddharth Prothia on 12/23/23.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore


struct Event {
    var id: String
    var attendees: Int
    var name: String
    var date: String
    var description: String
    var location: String
    var points: Int
    var time: String
    
    func toDictionary() -> [String: Any] {
        return ["name": name, "points": points, "time": time, "description": description, "attendees": attendees, "id": id, "location": location, "date": date]
    }
    
}


class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let database = Database.database().reference()
    private var events: [Event] = []
    private let tableView = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        database.child("events").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                return
            }
            
            print("Succesful, value: \(value)")
        })
        
        setupTableView()
        fetchData()

    }
   
    private func setupTableView() {
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "EventCell")
        view.addSubview(tableView)
    }
  

    private func fetchData() {
        let database = Database.database().reference()
        database.child("events").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let self = self, let value = snapshot.value as? [String: Any] else {
                return
            }
            
            self.events = value.compactMap { (key, value) -> Event? in
                guard let eventDict = value as? [String: Any] else { return nil }
                return Event(
                    id: key,
                    attendees: eventDict["attendees"] as? Int ?? 0,
                    name: eventDict["name"] as? String ?? "",
                    date: eventDict["date"] as? String ?? "",
                    description: eventDict["description"] as? String ?? "",
                    location: eventDict["location"] as? String ?? "",
                    points: eventDict["points"] as? Int ?? 0,
                    time: eventDict["time"] as? String ?? ""
                )
            }
            
            self.tableView.reloadData()
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventTableViewCell else {
            return UITableViewCell()
        }
        let event = events[indexPath.row]
        cell.configure(with: event)
        
        
        cell.onRegisterButtonTapped = { [weak self] in
            self?.registerForEvent(event)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300 // Adjust as needed
    }
    
    private func registerForEvent(_ event: Event) {

        print("Registering for event: \(event.name)")
        
        
        
        if let user = Auth.auth().currentUser {
            
            let alert = UIAlertController(title: "Success", message: "You have registered for this event!", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            self.present(alert, animated: true)
            
            let userId = user.uid
            print("Current user ID is: \(userId)")
            
            let myEventsRef = Database.database().reference().child("users").child(userId).child("events")
            
            let signedUpEvent = Event(id: event.id, attendees: event.attendees, name: event.name, date: event.date, description: event.description, location: event.location, points: event.points, time: event.time)
            
            myEventsRef.observeSingleEvent(of: .value, with: { snapshot in
                let nextIndex = snapshot.childrenCount
                let newEventRef = myEventsRef.child("\(nextIndex + 1)")
                newEventRef.setValue(signedUpEvent.toDictionary())
            })


            
            getUserProfile(userId: userId) { userProfile, error in
                if let error = error {
                    print("Error retrieving user: \(error.localizedDescription)")
                } else if let userProfile = userProfile {
                    print("User name registering for event is: \(userProfile)")

                    let attendeeListRef = Database.database().reference().child("events").child(event.id).child("attendeeList")
                    attendeeListRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in

                        var attendeeList = currentData.value as? [[String: String]] ?? []
                        let attendeeDetails = ["id": userId, "name": userProfile.name]
                        attendeeList.append(attendeeDetails)

                        currentData.value = attendeeList
                        return TransactionResult.success(withValue: currentData)
                    }) { (error, committed, snapshot) in
                        if let error = error {
                            print("Error updating attendeeList: \(error.localizedDescription)")
                        } else {
                            print("Succesfully appended to attendeeList")
                        }
                    }

                }
            }
            
            
        } else {
            print("No user is currently logged in.")
        }
        
    }
    
    func getUserProfile(userId: String, completion: @escaping (UserProfile?, Error?) -> Void) {
        var name = ""
        var points = 0
        
        let ref = Database.database().reference()

        ref.child("users").child(userId).observeSingleEvent(of: .value, with: { snapshot in
            
            guard let value = snapshot.value as? [String: AnyObject] else {
                print("No Data Found")
                return
            }
            
            let name = value["name"] as? String ?? "No Name"
            let points = value["points"] as? Int ?? 0

            print("Name: \(name), Points: \(points)")
            
            let userProfile = UserProfile(name: name, events: [], points: points)
            completion(userProfile, nil)
            
        }) { error in
            print(error.localizedDescription)
        }
    

    }


    @IBAction func logout(_ sender: Any) {
        logOutUser()
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
