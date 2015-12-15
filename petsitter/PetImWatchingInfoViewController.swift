//
//  PetImWatchingInfoViewController.swift
//  petsitter
//
//  Created by Devin Clark on 12/10/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit
import Parse
import Bolts
import CoreData

class PetImWatchingInfoViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var bio: UITextView!
    @IBOutlet weak var image: UIImageView!
    

    @IBOutlet weak var subInfoContainer: UIView!
    

    @IBOutlet weak var subLogContainer: UIView!

    @IBOutlet weak var segSwitch: UISegmentedControl!
    
    var sub: SubSitInfoViewController?
    
    var name_of_pet = String()
    var key_of_pet = String()
    var pet_bio_passed = String()
    var feed_passed = String()
    var act_passed = String()
    var contact_name = String()
    var contact_number = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        fillInformation()
        gatherImage(key_of_pet)
        
        switch segSwitch.selectedSegmentIndex {
        case 0:
            subLogContainer.hidden = true
            subInfoContainer.hidden = false
            //segSwitch.hidden = false
            //self.performSegueWithIdentifier("sitInfo", sender: self)
            
        case 1:
            subLogContainer.hidden = false
            subInfoContainer.hidden = true
            segSwitch.hidden = false
            
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
                        
                        self.image.image = image
                    }
                }
                
            }
        }
    }
    
    func fillInformation(){
        bio.text = pet_bio_passed
        nameLabel.text = name_of_pet
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segSwitch(sender: AnyObject) {
        switch segSwitch.selectedSegmentIndex {
        case 0:
            subLogContainer.hidden = true
            subInfoContainer.hidden = false
            //segSwitch.hidden = false
            //self.performSegueWithIdentifier("sitInfo", sender: self)
            
        case 1:
            subLogContainer.hidden = false
            subInfoContainer.hidden = true
            segSwitch.hidden = false
            
        default:
            break;
        }
        

        
    }
    
    @IBAction func addLog(sender: AnyObject) {
        
        self.performSegueWithIdentifier("addLog", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //first case, when a user decides to edit their pets information.
        if segue.identifier == "addLog"
        {
            //set the EditViewController's variable to the name we retrieved from the parse database.
            if let destinationVC = segue.destinationViewController as? AddLogViewController{
                destinationVC.key = self.key_of_pet
            }
        }
        if segue.identifier == "sitInfo"
        {
            //set the EditViewController's variable to the name we retrieved from the parse database.
            if let destinationVC = segue.destinationViewController as? SubSitInfoViewController{
                destinationVC.feed_passed = self.feed_passed
                destinationVC.act_passed = self.act_passed
                destinationVC.contact_number = self.contact_number
                destinationVC.contact_name = self.contact_name
                destinationVC.key = self.key_of_pet
            }
        }
        if segue.identifier == "sitLog"{
            
            if let destinationVC = segue.destinationViewController as? SubSitLogTableViewController{
                destinationVC.key = self.key_of_pet
            }
        }
        
        
    }
    

}
