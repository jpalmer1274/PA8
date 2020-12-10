//
//  PlaceDetailViewController.swift
//  gioffrepalmerPA8
//
//  Created by Gioffre, Ian Thomas and JR Palmer on 12/9/20.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    
    var placeIdOptional: String?
    
    @IBOutlet var placeName: UILabel!
    @IBOutlet var placePhoneNumber: UILabel!
    @IBOutlet var placeOpen: UILabel!
    @IBOutlet var placeAddress: UILabel!
    @IBOutlet var placeReview: UILabel!
    @IBOutlet var placePicture: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let placeId = placeIdOptional {
            GooglePlacesDetailAPI.fetchDetailResults(placeID: placeId, completion: { (placeOptional) in
                if let place = placeOptional {
                    print("in detail VC, got details back")
                    self.placeName.text = place.name
                    self.placePhoneNumber.text = place.phoneNumber
                    if place.openNow {
                        self.placeOpen.text = "(open)"
                    } else {
                        self.placeOpen.text = "(closed)"
                    }
                    self.placeAddress.text = place.address
                    self.placeReview.text = place.review
                    
                    // get picture using Place Photos API
                    GooglePlacesDetailAPI.fetchPlaceImage(fromPhotoReference: place.photoReference, completion: { (imageOptional) in
                        if let image = imageOptional {
                            self.placePicture.image = image
                        }
                    })
                } else {
                    print("in detail VC, didn't get details back")
                }
            })
        }
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
