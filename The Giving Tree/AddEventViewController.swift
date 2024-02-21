//
//  AddEventViewController.swift
//  The Giving Tree
//
//  Created by Siddharth Prothia on 2/17/24.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class AddEventViewController: UIViewController {
    
    @IBOutlet weak var eventName: UITextField!
    
    @IBOutlet weak var eventDescription: UITextField!
    
    @IBOutlet weak var eventLocation: UITextField!
    
    @IBOutlet weak var eventDate: UITextField!
    
    @IBOutlet weak var eventPoint: UITextField!
    
    @IBOutlet weak var eventTime: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventName.textAlignment = .center
        eventDescription.textAlignment = .center
        eventLocation.textAlignment = .center
        eventDate.textAlignment = .center
        eventPoint.textAlignment = .center
        eventTime.textAlignment = .center

        
    }
    

    @IBAction func addEvent(_ sender: Any) {
        
        let ref = Database.database().reference()
        let eventsRef = ref.child("events")
        
        let randomNumber = Int.random(in: 1...100)
        
        let alert = UIAlertController(title: "Success", message: "You have created a new event!", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true)

        
        eventsRef.observeSingleEvent(of: .value, with: { snapshot in
            // Count the children
            let eventCount = Int(snapshot.childrenCount)
            let newEventNumber = eventCount + 1
            let newEventKey = "event_\(newEventNumber)"

            // Add the new event
            let newEventRef = eventsRef.child(newEventKey)
            newEventRef.setValue(["name": self.eventName.text!, "date": self.eventDate.text!, "description": self.eventDescription.text!, "location": self.eventLocation.text!, "points": self.eventPoint.text!, "time": self.eventTime.text!, "attendees": randomNumber]) { (error, reference) in
                if let error = error {
                    print("Data could not be saved: \(error.localizedDescription)")
                } else {
                    print("Data saved successfully!")
                }
            }
        })
        
        
    }
    

}
