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

class PetInfoViewController: UIViewController {

    @IBOutlet weak var viewPetInfoContainer: UIView!
    @IBOutlet weak var viewLogContainer: UIView!
  
    @IBOutlet weak var petName: UILabel!
   
    @IBOutlet weak var petImage: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var petBio: UITextView!
    
    @IBOutlet weak var segSwitch: UISegmentedControl!
    
    var name_of_pet = String()
    var key_of_pet = String()
    var pet_bio_passed = String()
    var feed_passed = String()
    var act_passed = String()
    var contact_name = String()
    var contact_number = String()
    
    var sub:SubViewPetInfoViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //let textfield: UITextField = self.childViewControllers.last?.usernameTextField! as UITextField
        
    }
    
    override func viewWillAppear(animated: Bool) {
        spinner.startAnimating()
        gatherImage(key_of_pet)
        fillInformation()
        spinner.stopAnimating()
        viewLogContainer.hidden = true
        viewPetInfoContainer.hidden = false
    }
    
    func fillInformation(){
       petBio.text = pet_bio_passed
       petName.text = name_of_pet
        
       
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentSwitch(sender: AnyObject) {
        switch segSwitch.selectedSegmentIndex {
        case 0:
            viewLogContainer.hidden = true
            viewPetInfoContainer.hidden = false
            
        case 1:
            viewLogContainer.hidden = false
            viewPetInfoContainer.hidden = true
            
        default:
            break;
        }
    
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

    @IBAction func segueToEdit(sender: AnyObject) {
        self.performSegueWithIdentifier("goToEditSegue", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //first case, when a user decides to edit their pets information.
        if segue.identifier == "goToEditSegue"
        {
            //set the EditViewController's variable to the name we retrieved from the parse database.
            if let destinationVC = segue.destinationViewController as? EditInfoViewController{
                destinationVC.pet_key = self.key_of_pet
            }
        }
        if segue.identifier == "subInfo"
            {
                //set the EditViewController's variable to the name we retrieved from the parse database.
                if let destinationVC = segue.destinationViewController as? SubViewPetInfoViewController{
                    destinationVC.feed_passed = self.feed_passed
                    destinationVC.act_passed = self.act_passed
                    destinationVC.contact_number = self.contact_number
                    destinationVC.contact_name = self.contact_name
                }
        }
        if segue.identifier == "subLog"{
            
            if let destinationVC = segue.destinationViewController as? ViewLogContainerTableViewController{
                destinationVC.key = self.key_of_pet
            }
        }


    }
 
}
