//
//  GooglePlacesDetailAPI.swift
//  gioffrepalmerPA8
//
//  Created by Gioffre, Ian Thomas and John Palmer on 12/9/20.
//

import Foundation
import UIKit


struct GooglePlacesDetailAPI {
    
    static let APIkey = "AIzaSyB5-R6QQQq_tJ6vY2Mb-8KRcHBZYiz3pr0"
    static let baseURL = "https://maps.googleapis.com/maps/api/place/details/json"
    
    static func googlePlacesDetailURL(placeID: String) -> URL {
        
        let params = [
            "key": APIkey,
            "place_id" : placeID
        ]
        
        var queryItems = [URLQueryItem]()
        
        for (key, value) in params {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        var components = URLComponents(string: GooglePlacesDetailAPI.baseURL)!
        components.queryItems = queryItems
        let url = components.url!
        print(url)
        return url
        
    }
    
    static func fetchDetailResults(placeID: String, completion: @escaping (Place?) -> Void) {
        let url = GooglePlacesDetailAPI.googlePlacesDetailURL(placeID: placeID)
        
        let task = URLSession.shared.dataTask(with: url) { (dataOptional, urlResponseOptional, errorOptional) in
            if let data = dataOptional, let dataString = String(data: data, encoding: .utf8) {
                print("we got data!!!")
                print(dataString)
                
                if let place = place(fromData: data) {
                    DispatchQueue.main.async {
                        completion(place)
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
    
    static func place(fromData data: Data) -> Place? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonDictionary = jsonObject as? [String: Any], let placeDetails = jsonDictionary["result"] as? [String: Any],
                  let id = placeDetails["place_id"] as? String, let name = placeDetails["name"] as? String, let vicinity = placeDetails["vicinity"] as? String,
                  let rating = placeDetails["rating"] as? Double, let photos = placeDetails["photos"] as? [[String: Any]],
                  let openingHours = placeDetails["opening_hours"] as? [String: Any], let openNow = openingHours["open_now"] as? Bool,
                  let address = placeDetails["formatted_address"] as? String, let reviews = placeDetails["reviews"] as? [[String: Any]]
            else {
                print("Not all data present")
                return nil
            }
            let photo = photos[photos.startIndex]
            let review = reviews[reviews.startIndex]
            guard let photoReference = photo["photo_reference"] as? String, let reviewText = review["text"] as? String
            else {
                print("Not all data present")
                return nil
            }
            
            guard let phoneNumber = placeDetails["formatted_phone_number"] as? String else {
                return Place(id: id, name: name, vicinity: vicinity, rating: rating, photoReference: photoReference, openNow: openNow, phoneNumber: "", address: address, review: reviewText)
            }
            
            return Place(id: id, name: name, vicinity: vicinity, rating: rating, photoReference: photoReference, openNow: openNow, phoneNumber: phoneNumber, address: address, review: reviewText)
            
        } catch {
            print("Error converting Data to JSON \(error)")
        }
        
        return nil
        
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
