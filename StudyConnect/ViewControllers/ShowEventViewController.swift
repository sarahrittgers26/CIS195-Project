//
//  ShowEventViewController.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/15/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ShowEventViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var confirmedUsers: UIStackView!
    
    var group: Group?
    var event: Events?
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLocationManager()
        map.delegate = self
        map.showsUserLocation = true
        updateView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (CLLocationManager.authorizationStatus() == .notDetermined) {
            locationManager.requestWhenInUseAuthorization()
        }

        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        }
        displayMap()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = regionInMeters
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            map.setRegion(region, animated: true)
        }
    }
    
    func displayMap() {
        guard let address = event?.address else { return }
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let
                placemarks = placemarks, let location = placemarks.first?.location
            else {
                // no location found
                return
            }
            
            let annotation = MKPointAnnotation()
            annotation.title = address
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.map.addAnnotation(annotation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        map.setRegion(region, animated: true)
    }
    
    func updateView() {
        if let event = event {
            whenLabel.text = "Time: \(event.date) \(event.time)"
            whereLabel.text = "Location: \(event.address)"
            self.title = event.title
        }
    }
    
    // Actions
    
    @IBAction func confirmEvent(_ sender: Any) {
        guard let group = group, let user = FirebaseUsers.getCurrentUser(), let event = event else { return }
        FirebaseGroups.confirmUserForEvent(groupID: group.id, eventID: event.id, userID: user.uid, callback: { (bool) in
            if bool {
                self.reloadEvent()
            } else {
                let alert = Helpers.showErrorAlert(message: "You are already confirmed")
                self.present(alert, animated: true)
            }
        })
    }
    
    @IBAction func addToCalendar(_ sender: Any) {
    }
    
    @IBAction func deleteEvent(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "This cannot be undone", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction!) in
            // do nothing
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction!) in
            if let group = self.group, let event = self.event {
                FirebaseGroups.deleteEvent(groupID: group.id, eventID: event.id, callback: {
                    self.performSegueToReturnBack()
                })
            }
        }))
        self.present(alert, animated: true)
    }
    
    // Helpers
    
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"eventDeleted"), object: nil)
        } else {
            self.dismiss(animated: true, completion: {NotificationCenter.default.post(name: NSNotification.Name(rawValue:"eventDeleted"), object: nil)})
        }
    }
    
    // refresh the event object
    func reloadEvent() {
        guard let group = group, let event = event else { return }
        FirebaseGroups.getEvent(groupID: group.id, eventID: event.id, callback: { (event) in
            self.event = event
            self.renderConfirmedUsers()
        })
    }
    
    // render names of confirmed users
    func renderConfirmedUsers() {
        for view in self.confirmedUsers.subviews {
            view.removeFromSuperview()
        }
        
        guard let event = event else { return }
        FirebaseUsers.getSpecifiedUsers(toGet: event.confirmedUsers, callback: { (users) in
            for user in users {
                let label = UILabel()
                label.text = "\(user.firstName) \(user.lastName)"
                label.textColor = UIColor(red: 139/255, green: 140/255, blue: 137/255, alpha: 1)
                self.confirmedUsers.addArrangedSubview(label)
            }
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
