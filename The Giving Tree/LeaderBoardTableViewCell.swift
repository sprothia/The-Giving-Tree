//
//  LeaderBoardTableViewCell.swift
//  The Giving Tree
//
//  Created by Siddharth Prothia on 2/19/24.
//

import UIKit

struct LeaderBoardStructure {
    var indexLbl: String
    var name: String
    var points: Int
}

class LeaderBoardTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var indexLbl: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var points: UILabel!
    
    func configure(with leaderboard: LeaderBoardStructure) {
        
        name.text = leaderboard.name
        points.text = String(leaderboard.points)
        indexLbl.text = leaderboard.indexLbl
        
    }


}
