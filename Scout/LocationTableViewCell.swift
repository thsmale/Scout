//
//  LocationTableViewCell.swift
//  Scout
//
//  Created by Tommy Smale on 3/22/21.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    let tableViewCellIdentifier = "locationCellID"
    let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: tableViewCellIdentifier)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(label)
        
        let margins = self.contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            label.topAnchor.constraint(equalTo: margins.topAnchor),
            label.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
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
