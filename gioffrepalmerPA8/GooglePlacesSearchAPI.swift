//
//  GooglePlacesAPI.swift
//  gioffrepalmerPA8
//
//  Created by Gioffre, Ian Thomas and John Palmer on 12/9/20.
//

import Foundation
import UIKit

struct GooglePlacesSearchAPI {
    
    static let APIkey = "AIzaSyB5-R6QQQq_tJ6vY2Mb-8KRcHBZYiz3pr0"
    static let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    
    static func googlePlacesSearchURL(latitude: String, longitude: String, keyword: String) -> URL {
        
        let params = [
            "key": APIkey,
            "location" : "\(latitude),\(longitude)",
            "rankby" : "distance",
            "keyword" : keyword
        ]
        
        var queryItems = [URLQueryItem]()
        
        for (key, value) in params {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        var components = URLComponents(string: GooglePlacesSearchAPI.baseURL)!
        components.queryItems = queryItems
        let url = components.url!
        print(url)
        return url
        
    }
    
    static func fetchSearchResults(latitude: String, longitude: String, keyword: String, completion: @escaping ([Place]?) -> Void) {
        let url = GooglePlacesSearchAPI.googlePlacesSearchURL(latitude: latitude, longitude: longitude, keyword: keyword)
        
        let task = URLSession.shared.dataTask(with: url) { (dataOptional, urlResponseOptional, errorOptional) in
            if let data = dataOptional, let dataString = String(data: data, encoding: .utf8) {
                print("we got data!!!")
                print(dataString)
                
                if let places = places(fromData: data) {
                    print("we got an [Place] with \(places.count) photos")
                    
                    DispatchQueue.main.async {
                        completion(places)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
            else {
                if let error = errorOptional {
                    print("Error getting data \(error)")
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    static func places(fromData data: Data) -> [Place]? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonDictionary = jsonObject as? [String: Any], let placeArray = jsonDictionary["results"] as? [[String: Any]] else {
                print("Error parsing JSON")
                return nil
            }
            
            print("successfully got placeArray")
            
            var places = [Place]()
            for placeObject in placeArray {
                if let place = place(fromJSON: placeObject) {
                    places.append(place)
                }
            }
            
            if !places.isEmpty {
                return places
            }
        }
        catch {
            print("Error converting Data to JSON \(error)")
        }
        
        return nil
    }
    
    static func place(fromJSON json: [String: Any]) -> Place? {
        guard let id = json["place_id"] as? String, let name = json["name"] as? String, let vicinity = json["vicinity"] as? String,
              let photos = json["photos"] as? [[String: Any]], let rating = json["rating"] as? Double,
              let openingHours = json["opening_hours"] as? [String: Any], let openNow = openingHours["open_now"] as? Bool
        else {
            print("Not all data present")
            return nil
        }
        let photo = photos[photos.startIndex]
        guard let photoReference = photo["photo_reference"] as? String else {
            print("Not all data present")
            return nil
        }
        
        return Place(id: id, name: name, vicinity: vicinity, rating: rating, photoReference: photoReference, openNow: openNow, phoneNumber: "", address: "")
    }
    
    static func fetchPlace(fromURLString urlString: String, completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { (dataOptional, urlResponseOptional, errorOptional) in
            if let data = dataOptional, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            else {
                if let error = errorOptional {
                    print("error fetching information \(error)")
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
}
