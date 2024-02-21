//
//  EventTableViewCell.swift
//  The Giving Tree
//
//  Created by Siddharth Prothia on 1/17/24.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let descriptionLabel = UILabel()
    let locationLabel = UILabel()
    let pointsLabel = UILabel()
    let timeLabel = UILabel()
    let attendeesLabel = UILabel()
    let registerButton = UIButton(type: .system)
    
    var onRegisterButtonTapped: (() -> Void)?




    // Initialize and layout your labels
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, dateLabel, timeLabel, locationLabel, pointsLabel, descriptionLabel, attendeesLabel, registerButton])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func registerButtonTapped() {
        onRegisterButtonTapped?()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Helper function to configure the cell with an Event
    func configure(with event: Event) {
        nameLabel.text = "Name: \(event.name)"
        dateLabel.text = "Date: \(event.date)"
        descriptionLabel.text = "Description: \(event.description)"
        locationLabel.text = "Location: \(event.location)"
        pointsLabel.text = "Points: \(event.points)"
        timeLabel.text = "Time: \(event.time)"
        attendeesLabel.text = "Attendees: \(event.attendees)"
    }
}
