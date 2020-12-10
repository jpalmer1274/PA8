//
//  ViewController.swift
//  gioffrepalmerPA8
//
//  Created by Gioffre, Ian Thomas and JR Palmer on 12/9/20.
//

import UIKit
import CoreLocation

class PlaceTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, CLLocationManagerDelegate {
    
    var places = [Place]()
    @IBOutlet var tableView: UITableView!
    
    var searchController = UISearchController(searchResultsController: nil)
    
    let locationManager = CLLocationManager()
    var latitude: String = String(47.667191) // default to gonzaga
    var longitude: String = String(-117.402382) // default to gonzaga
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocationServices()
            print("enabled")
        } else {
            print("disabled")
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Nearby"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func setupLocationServices() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestLocation()
    }
    
    func searchNearby(keyword: String, latitude: String, longitude: String) {
        GooglePlacesSearchAPI.fetchSearchResults(latitude: latitude, longitude: longitude, keyword: keyword, completion: { (placesOptional) in
            if let places = placesOptional {
                print("in Table VC, got array back")
                self.places = places
                self.tableView.reloadData()
            } else {
                print("in Table VC, DID NOT get array back")
            }
            
        })
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        locationManager.requestLocation()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return places.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let place = places[row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitleStyle")
        
        cell.textLabel!.text = "\(place.name) (\(place.rating)⭐️)"
        cell.detailTextLabel!.text = place.vicinity
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailSegue", sender: self)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let keyword = searchBar.text {
            if keyword != "" {
                searchNearby(keyword: keyword, latitude: self.latitude, longitude: self.longitude)
            } else {
                places.removeAll()
                tableView.reloadData()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        self.latitude = String(location.coordinate.latitude)
        self.longitude = String(location.coordinate.longitude)
        updateSearchResults(for: self.searchController)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error requesting location \(error)")
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "DetailSegue" {
                if let detailVC = segue.destination as? PlaceDetailViewController {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        let place = places[indexPath.row]
                        detailVC.placeIdOptional = place.id
                    }
                }
            }
        }
    }
    
}

