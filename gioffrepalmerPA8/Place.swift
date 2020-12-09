//
//  Place.swift
//  gioffrepalmerPA8
//
//  Created by Gioffre, Ian Thomas on 12/9/20.
//

import Foundation

class Place {
    var id: String
    var name: String
    var vicinity: String
    var rating: String
    var photoReference: String
    
    init(id: String, name: String, vicinity: String, rating: String, photoReference: String) {
        self.id = id
        self.name = name
        self.vicinity = vicinity
        self.rating = rating
        self.photoReference = photoReference
    }
}
