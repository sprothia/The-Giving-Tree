//
//  LeaderBoardViewController.swift
//  The Giving Tree
//
//  Created by Siddharth Prothia on 12/23/23.
//

import UIKit
import FirebaseDatabase


class LeaderBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {


    @IBOutlet weak var tableView: UITableView!

    var everyUser: [LeaderBoardStructure] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchAndDisplayUsers()
      
    }
    
    func fetchAndDisplayUsers() {
        let ref = Database.database().reference().child("users")

        ref.observeSingleEvent(of: .value, with: { snapshot in
            var fetchedUsers: [LeaderBoardStructure] = []

            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let dict = snapshot.value as? [String: Any],
                   let name = dict["name"] as? String,
                   let points = dict["points"] as? Int {
                    print("User ID: \(snapshot.key), Name: \(name), Points: \(points)")
                    
                    let user = LeaderBoardStructure(indexLbl: snapshot.key, name: name, points: points)
                    fetchedUsers.append(user)
                }
            }
            
            self.everyUser = fetchedUsers.sorted { $0.points > $1.points }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return everyUser.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath) as? LeaderBoardTableViewCell
        
        cell?.points.text = String(everyUser[indexPath.row].points)
        cell?.indexLbl.text = String(indexPath.row)
        cell?.name.text = String(everyUser[indexPath.row].name)

        return cell!
        
    }
    

    
}
