//
//  ProfileEventsTableViewCell.swift
//  The Giving Tree
//
//  Created by Siddharth Prothia on 1/28/24.
//

import UIKit

class ProfileEventsTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var date: UILabel!
  
    
    
    func configure(with event: UserEvent) {
        
        name.text = event.name
        points.text = String(event.points)
        date.text = event.date
        
    }
    
    
    
    
    
}
