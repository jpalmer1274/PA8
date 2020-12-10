//
//  PlaceDetailViewController.swift
//  gioffrepalmerPA8
//
//  Created by Gioffre, Ian Thomas and JR Palmer on 12/9/20.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    
    @IBOutlet var placeName: UILabel!
    @IBOutlet var placePhoneNumber: UILabel!
    @IBOutlet var placeOpen: UILabel!
    @IBOutlet var placeAddress: UILabel!
    @IBOutlet var placeReview: UILabel!
    @IBOutlet var placePicture: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
