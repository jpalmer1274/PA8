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
        GooglePlacesSearchAPI.fetchSearchResults(latitude: "47.667191", longitude: "-117.402382", keyword: "carusos", completion: { (placesOptional) in
            if let places = placesOptional {
                print("in VC, got array back")
                self.places = places
                self.tableView.reloadData()
            }
            
            print("in VC, DID NOT get array back")
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleStyle", for: indexPath)
        
        cell.textLabel!.text = "\(place.name) (\(place.rating)⭐️)"
        cell.detailTextLabel!.text = place.address
        
        return cell
    }
    
    
    
}

