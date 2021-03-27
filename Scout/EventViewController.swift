//
//  EventViewController.swift
//  Scout
//
//  Created by Tommy Smale on 3/23/21.
//

import UIKit

class EventViewController: UIViewController {

    weak var eventTableView: UITableView!
    
    let locationViewCellIdentifier = "locationCellID"
    let dateViewCellIdentifier = "dateCellID"
    let dateLabels = ["Starts", "Ends"]

    override func loadView() {
        super.loadView()
        
        let margins = self.view.safeAreaLayoutGuide
        
        let eventTableView = UITableView()
        eventTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(eventTableView)
        NSLayoutConstraint.activate([
            eventTableView.topAnchor.constraint(equalTo: margins.topAnchor),
            eventTableView.leftAnchor.constraint(equalTo: margins.leftAnchor),
            eventTableView.rightAnchor.constraint(equalTo: margins.rightAnchor),
            eventTableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
        self.eventTableView = eventTableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEvent))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        self.navigationItem.title = "New Event"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent))
        self.navigationItem.rightBarButtonItem = addButton
            
        self.eventTableView.dataSource = self
        self.eventTableView.delegate = self
        self.eventTableView.register(LocationTableViewCell.self, forCellReuseIdentifier: locationViewCellIdentifier)
        self.eventTableView.register(DateTableViewCell.self, forCellReuseIdentifier: dateViewCellIdentifier)
        self.eventTableView.sectionHeaderHeight = 0
        self.eventTableView.sectionFooterHeight = 100
    }

    @objc func cancelEvent() {
        
    }
    
    @objc func addEvent() {
        
    }

}

extension EventViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: locationViewCellIdentifier, for: indexPath) as? LocationTableViewCell else {
                fatalError("Failed to cast dequeueResuableCell as LocationTableViewCell")
            }
            
            cell.label.text = "Location"
            cell.label.textColor = .lightGray
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: dateViewCellIdentifier, for: indexPath) as? DateTableViewCell else {
                fatalError("Failed to cast dequeueResuableCell as DateTableViewCell")
            }
            
            cell.startLabel.text = dateLabels[indexPath.row]
           
            return cell
        }
    }
}

extension EventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 16
        } else {
            return 32
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 32
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.present(UINavigationController(rootViewController: LocationViewController()), animated: true, completion: nil)
        }else {
            print("Selected row: \(indexPath.row)")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: dateViewCellIdentifier, for: indexPath) as? DateTableViewCell else {
                fatalError("Failed to cast dequeueResuableCell as DateTableViewCell")
            }
            self.eventTableView.insertRows(at: [indexPath], with: .top)
            self.eventTableView.reloadRows(at: [indexPath], with: .bottom)
        }
    }
}

