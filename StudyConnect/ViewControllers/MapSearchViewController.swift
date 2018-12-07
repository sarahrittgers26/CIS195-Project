//
//  MapSearchViewController.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/27/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit
import MapKit

class MapSearchViewController: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.delegate = self
        self.table.dataSource = self

        if (CLLocationManager.authorizationStatus() == .notDetermined) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            locationManager.startUpdatingLocation()
        }
        
        searchCompleter.delegate = self
        if let location = locationManager.location?.coordinate {
            searchCompleter.region = MKCoordinateRegion(center: location, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
        }
    }
    
    @IBAction func search(_ sender: Any) {
        searchCompleter.queryFragment = searchBar.text ?? ""
    }
    
    /*
     MKLocalSearchCompleter
    */
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        table.reloadData()
    }
    
    /*
     TableView Data Source
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        print(searchResults)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    /*
    TableView Delegate
    */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let result = searchResults[indexPath.row]
        let address = "\(result.title) \(result.subtitle)"
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"addressSelected"), object: nil, userInfo:["address": address])
        
        dismiss(animated: true, completion: nil)
    }
    

}
