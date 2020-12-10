//
//  GooglePlacesAPI.swift
//  gioffrepalmerPA8
//
//  Created by John Palmer on 12/9/20.
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
        
        // we need to make a request to the Flickr API server using the url
        // we will get back a JSON response (if all goes well)
        // we will make the request on a background thread using a data task
        let task = URLSession.shared.dataTask(with: url) { (dataOptional, urlResponseOptional, errorOptional) in
            // this closure executes later...
            // when the task has received a response from the server
            // we want to grab the Data object that represents the JSON response (if there is one)
            if let data = dataOptional, let dataString = String(data: data, encoding: .utf8) {
                print("we got data!!!")
                print(dataString)
                
                // we want to convert the Data to a JSON object, then the JSON object to a Swift dictionary so we can parse the photos from the array
                // to create [InterestingPhoto]
                // write a method to do this
                if let places = places(fromData: data) {
                    print("we got an [Place] with \(places.count) photos")
                    // our goal is to get this array back to ViewController for displaying in the views
                    // PROBLEMS!!
                    // MARK: - Threads
                    // so far, our code in ViewController (for example) has run on the main UI thread
                    // the main UI thread listens for interactions with views from the user, it calls callbacks in view controllers and delgates, etc.
                    // we don't want to run long running tasks/code on the main UI thread, why?
                    // by default, URLSession dataTasks run on a background thread
                    // that means that this closure we are in right now... runs asynchronously on a background thread
                    // fetchInterestingPhotos() starts the task (that runs in the background), then it immediately returns (we can't return the array then!!)
                    
                    // we need a completion handler (AKA closure) to call code in ViewController when we have a result (success or failure)
                    // we want to call the completion closure so it runs on the main UI thread and can update our views
                    // a thread in iOS is managed by a queue
                    DispatchQueue.main.async {
                        completion(places)
                    }
                    
                    // should call completion on failure as well
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
        // by default tasks are created in the suspended state
        // call resume() to start the task
        task.resume()
    }
    
    static func places(fromData data: Data) -> [Place]? {
        // if anything goes wrong, return nil
        
        // MARK: - JSON
        // javascript object notation
        // json is the most commonly used format for passing data around the web
        // it is really just a dictionary
        // keys are strings
        // values are strings, arrays, nested JSON objects, ints, bools, etc.
        // our goal is to convert the data into a swift dictionary [String: Any]
        // libaries (like swiftyJSON) that make this really easy
        // we are gonna do it the long way!
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonDictionary = jsonObject as? [String: Any], let placeArray = jsonDictionary["results"] as? [[String: Any]] else {
                print("Error parsing JSON")
                return nil
            }
            // we sucessfully go the array of photos
            print("successfully got placeArray")
            var places = [Place]()
            for placeObject in placeArray {
                // parse a InterestingPhoto from photoObject ([String: Any])
                // write a method to do this
                if let place = place(fromJSON: placeObject) {
                    places.append(place)
                }
            }
            // return the array if it its not empty
            // GS: finished after class
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
        // task: finish this method
        // we need the id, title, datetaken, url_h
        // GS: finished after class
        guard let id = json["place_id"] as? String, let name = json["name"] as? String, let vicinity = json["vicinity"] as? String,
              let photos = json["photos"] as? [[String: Any]], let photo = photos[photos.startIndex] as? [String: Any], let photoReference = photo["photo_reference"] as? String,
              let rating = json["rating"] as? Double, let openingHours = json["opening_hours"] as? [String: Any], let openNow = openingHours["open_now"] as? Bool
        else {
            print("error, not all info was present")
            return nil
        }
        
        return Place(id: id, name: name, vicinity: vicinity, rating: rating, photoReference: photoReference, openNow: openNow, phoneNumber: "", address: "")
    }
    
    static func fetchPlace(fromURLString urlString: String, completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { (dataOptional, urlResponseOptional, errorOptional) in
            if let data = dataOptional, let image = UIImage(data: data) {
                // task: call completion correctly
                // update the view to show the image
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
