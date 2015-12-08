//
//  PetInfoViewController.swift
//  petsitter
//
//  Created by MU IT Program on 12/2/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit
import CoreData
import Parse
import Bolts

class PetInfoViewController: UIViewController, UINavigationControllerDelegate {

  
    @IBOutlet weak var navBar: UINavigationItem!
   
    @IBOutlet weak var petImage: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var petBio: UITextView!
    
    @IBOutlet weak var petFeed: UITextView!
    
    @IBOutlet weak var petAct: UITextView!
    
    @IBOutlet weak var ContactName: UILabel!
    
    @IBOutlet weak var contactNumber: UILabel!
    
    @IBOutlet weak var segSwitch: UISegmentedControl!
    
    @IBOutlet weak var pet1: UIImageView!
    
    @IBOutlet weak var pet2: UIImageView!
    
    @IBOutlet weak var pet3: UIImageView!
    
    @IBOutlet weak var pet4: UIImageView!
    
    @IBOutlet weak var pet5: UIImageView!
    
    @IBOutlet weak var pet6: UIImageView!
    
    var name_of_pet = String()
    var key_of_pet = String()
    var pet_bio_passed = String()
    var feed_passed = String()
    var act_passed = String()
    var contact_name = String()
    var contact_number = String()
    
    //var pull_image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        spinner.startAnimating()
        gatherImage(key_of_pet)
        fillInformation()
        spinner.stopAnimating()
        navBar.title = name_of_pet
    }
    
    func fillInformation(){
        petBio.text = pet_bio_passed
        petFeed.text = feed_passed
        petAct.text = act_passed
        ContactName.text = contact_name
        contactNumber.text = contact_number
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func gatherImage(key: String){
        var pet_pic = [PFFile]()
        
        let query = PFQuery(className: "Pet_photos")
        query.whereKey("pet_key", equalTo: key)
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("The getFirstObject request failed inside of the myPetsTVC, in cell function.")
            }
            else {
                pet_pic.append(object?["profile_pic"] as! PFFile)
                
                //extra step required to transform the pffile object into a uiimage
                pet_pic[0].getDataInBackgroundWithBlock { (imageData: NSData?, error:NSError?) -> Void in
                    if error == nil {
                        let image = UIImage(data: imageData!)
                        
                        self.petImage.image = image
                    }
                }

            }
        }
    }

}
