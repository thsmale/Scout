//
//  ResultsTableViewCell.swift
//  Scout
//
//  Created by Tommy Smale on 3/23/21.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {
    
    let resultsCellIdentifier = "resultsCellID"
    
    let nameLabel = UILabel() 

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: resultsCellIdentifier)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(nameLabel)
        
        let margins = self.contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
