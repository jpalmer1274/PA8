//
//  ViewController.swift
//  gioffrepalmerPA8
//
//  Created by Gioffre, Ian Thomas and JR Palmer on 12/9/20.
//

import UIKit

class PlaceTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var places = [Place]()
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        GooglePlacesSearchAPI.fetchSearchResults(latitude: "47.667191", longitude: "-117.402382", keyword: "carusos", completion: { (placesOptional) in
            if let places = placesOptional {
                print("in VC, got array back")
                self.places = places
                self.tableView.reloadData()
            } else {
                print("in VC, DID NOT get array back")
            }
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("I AM HERE 2")
        if section == 0 {
            return places.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("I AM HERE")
        let row = indexPath.row
        let place = places[row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitleStyle")
        
        cell.textLabel!.text = "\(place.name) (\(place.rating)⭐️)"
        cell.detailTextLabel!.text = place.vicinity
        
        return cell
    }
    
    
    
}

