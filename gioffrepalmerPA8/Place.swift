//
//  Place.swift
//  gioffrepalmerPA8
//
//  Created by Gioffre, Ian Thomas and JR Palmer on 12/9/20.
//

import Foundation

class Place {
    var id: String
    var name: String
    var vicinity: String
    var rating: Double
    var photoReference: String
    var openNow: Bool
    var phoneNumber: String
    var address: String
    
    init(id: String, name: String, vicinity: String, rating: Double, photoReference: String, openNow: Bool, phoneNumber: String, address: String) {
        self.id = id
        self.name = name
        self.vicinity = vicinity
        self.rating = rating
        self.photoReference = photoReference
        self.openNow = openNow
        self.phoneNumber = phoneNumber
        self.address = address
    }
}
