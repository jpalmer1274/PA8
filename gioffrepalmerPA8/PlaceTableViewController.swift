//
//  ViewController.swift
//  gioffrepalmerPA8
//
//  Created by Gioffre, Ian Thomas and JR Palmer on 12/9/20.
//

import UIKit

class PlaceTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    var places = [Place]()
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Nearby"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func searchNearby(keyword: String) {
        GooglePlacesSearchAPI.fetchSearchResults(latitude: "47.667191", longitude: "-117.402382", keyword: keyword, completion: { (placesOptional) in
            if let places = placesOptional {
                print("in Table VC, got array back")
                self.places = places
                self.tableView.reloadData()
            } else {
                print("in Table VC, DID NOT get array back")
            }
            
        })
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
                searchNearby(keyword: keyword)
            } else {
                places.removeAll()
                tableView.reloadData()
            }
        }
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

