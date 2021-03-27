//
//  DateTableViewCell.swift
//  Scout
//
//  Created by Tommy Smale on 3/22/21.
//

import UIKit

class DateTableViewCell: UITableViewCell {
    
    let dateViewCellIdentifier = "dateCellID"
    weak var startLabel: UILabel!
    weak var dateLabel: UILabel!
    weak var datePicker: UIDatePicker!
    let dateFormatter = DateFormatter()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: dateViewCellIdentifier)
        
        let margins = self.contentView.layoutMarginsGuide
        
        let startLabel = UILabel()
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        startLabel.numberOfLines = 1
        self.contentView.addSubview(startLabel)
        
        NSLayoutConstraint.activate([
            startLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            //startLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            startLabel.topAnchor.constraint(equalTo: margins.topAnchor),
        ])
        startLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.startLabel = startLabel
        
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        //dateFormatter.dateFormat = "yyyy MM, dd'T'HH:mm:ss'Z'"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateLabel.text = dateFormatter.string(from: Date())
        dateLabel.textAlignment = .right
        self.contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.firstBaselineAnchor.constraint(equalTo: startLabel.firstBaselineAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: startLabel.trailingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        ])
        dateLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.dateLabel = dateLabel

        
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date.distantFuture
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.preferredDatePickerStyle = .inline
        self.contentView.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 8),
            datePicker.leftAnchor.constraint(equalTo: margins.leftAnchor),
            datePicker.rightAnchor.constraint(equalTo: margins.rightAnchor),
            datePicker.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
        self.datePicker = datePicker
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        //datePicker.isHidden = !datePicker.isHidden

    }

    @objc func dateChanged() {
        print("Date changed \(datePicker.date)")
        dateLabel.text = dateFormatter.string(from: datePicker.date)
    }
}
