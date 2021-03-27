//
//  LocationViewController.swift
//  Scout
//
//  Created by Tommy Smale on 3/23/21.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, UISearchResultsUpdating {
    
    var searchController: UISearchController!
    weak var resultsTableView: UITableView!
    weak var datePicker: UIDatePicker!
    
    var results = [MKMapItem]()
    let resultsCellIdentifier = "resultsCellID"
    
    override func loadView() {
        super.loadView()
        
        let margins = self.view.safeAreaLayoutGuide
        
        let resultsTableView = UITableView()
        resultsTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(resultsTableView)
        NSLayoutConstraint.activate([
            resultsTableView.topAnchor.constraint(equalTo: margins.topAnchor),
            resultsTableView.leftAnchor.constraint(equalTo: margins.leftAnchor),
            resultsTableView.rightAnchor.constraint(equalTo: margins.rightAnchor),
            resultsTableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
        self.resultsTableView = resultsTableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white

        self.navigationItem.title = "Location"
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        self.navigationItem.rightBarButtonItem = cancelButton
        
        let resultsTableViewController = UISearchController()
        
        searchController = UISearchController(searchResultsController: resultsTableViewController)
        searchController.searchBar.placeholder = "Enter location"
        searchController.searchResultsUpdater = self
        searchController.automaticallyShowsCancelButton = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        self.navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        resultsTableView.register(ResultsTableViewCell.self, forCellReuseIdentifier: resultsCellIdentifier)
        resultsTableView.dataSource = self
        resultsTableView.keyboardDismissMode = .onDrag
        resultsTableView.rowHeight = 500
    }
    
    @objc func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    
    //MARK: UISearchResultsUpdating protocol
    func updateSearchResults(for searchController: UISearchController) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchController.searchBar.text ?? ""
        //MARK: TODO
        //add searchRequest.region
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                print("MKLocalSearch error: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            
            self.results = response.mapItems
            self.resultsTableView.reloadData()
            
        }
    }


}

extension LocationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: resultsCellIdentifier, for: indexPath) as? ResultsTableViewCell else {
            fatalError("Failed to cast dequeueResuableCell as ResultsTableViewCell")
        }

        // Configure the cell...
        let mapItem = results[indexPath.row]
        cell.nameLabel.text = mapItem.name
        

        return cell
    }
}


