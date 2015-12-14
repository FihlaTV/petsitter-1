//
//  SubViewPetInfoViewController.swift
//  petsitter
//
//  Created by Devin Clark on 12/12/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit
import Parse
import Bolts

class SubViewPetInfoViewController: UIViewController {

    @IBOutlet weak var petFeed: UITextView!
    
    @IBOutlet weak var petAct: UITextView!
    
    @IBOutlet weak var ContactName: UILabel!
    
    @IBOutlet weak var contactNumber: UIButton!
    
    @IBOutlet weak var code: UITextField!
    
    var feed_passed = String()
    var act_passed = String()
    var contact_name = String()
    var contact_number = String()
    var key = String()
    var choice = Int()
    
    @IBOutlet weak var pic1: UIImageView!
    @IBOutlet weak var pic2: UIImageView!
    @IBOutlet weak var pic3: UIImageView!
    @IBOutlet weak var pic4: UIImageView!
    @IBOutlet weak var pic5: UIImageView!
    @IBOutlet weak var pic6: UIImageView!
    
    var images = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillInformation()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        gather_available_images()
    }
    func fillInformation(){
        petFeed.text = feed_passed
        petAct.text = act_passed
        ContactName.text = contact_name
        contactNumber.setTitle(contact_number, forState: .Normal)
        
    }
    
    func gather_available_images(){
        let query = PFQuery(className: "Pet_photos")
        query.whereKey("pet_key", equalTo: key)
        //query.selectKeys(["pic_1,pic_2,pic_3,pic_4,pic_5,pic_6"])
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("The getFirstObject request failed. [1]")
            }
            else {
                
                if object?.valueForKey("pic_1") != nil{
                    
                    let pic = (object?["pic_1"] as! PFFile)
                    pic.getDataInBackgroundWithBlock { (imageData: NSData?, error:NSError?) -> Void in
                        if error == nil {
                            let image = UIImage(data: imageData!)
                            
                            self.pic1.image = image
                            
                        }
                    }

                    
                }
                if object?.valueForKey(("pic_2")) != nil{
                    
                    let pic = (object?["pic_2"] as! PFFile)
                    pic.getDataInBackgroundWithBlock { (imageData: NSData?, error:NSError?) -> Void in
                        if error == nil {
                            let image = UIImage(data: imageData!)
                            
                            self.pic2.image = image
                            
                        }
                    }

                    
                }
                if object?.valueForKey(("pic_3")) != nil{
                    let pic = (object?["pic_3"] as! PFFile)
                    pic.getDataInBackgroundWithBlock { (imageData: NSData?, error:NSError?) -> Void in
                        if error == nil {
                            let image = UIImage(data: imageData!)
                            
                            self.pic3.image = image
                            
                        }
                    }

                }
                if object?.valueForKey(("pic_4")) != nil{
                    let pic = (object?["pic_4"] as! PFFile)
                    pic.getDataInBackgroundWithBlock { (imageData: NSData?, error:NSError?) -> Void in
                        if error == nil {
                            let image = UIImage(data: imageData!)
                            
                            self.pic4.image = image
                            
                        }
                    }

                }
                if object?.valueForKey(("pic_5")) != nil{
                    let pic = (object?["pic_5"] as! PFFile)
                    pic.getDataInBackgroundWithBlock { (imageData: NSData?, error:NSError?) -> Void in
                        if error == nil {
                            let image = UIImage(data: imageData!)
                            
                            self.pic5.image = image
                            
                        }
                    }

                }
                if object?.valueForKey(("pic_6")) != nil{
                    let pic = (object?["pic_6"] as! PFFile)
                    pic.getDataInBackgroundWithBlock { (imageData: NSData?, error:NSError?) -> Void in
                        if error == nil {
                            let image = UIImage(data: imageData!)
                            
                            self.pic6.image = image
                            
                        }
                    }

                }
            }
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pic1selected(sender: AnyObject) {
       self.choice = 1
       self.performSegueWithIdentifier("chooseImage", sender: self)
    }
    
    @IBAction func pic2selected(sender: AnyObject) {
        self.choice = 2
        self.performSegueWithIdentifier("chooseImage", sender: self)
    }
    
  
    @IBAction func pic3selected(sender: AnyObject) {
        self.choice = 3
        self.performSegueWithIdentifier("chooseImage", sender: self)
    }
    
    @IBAction func pic4selected(sender: AnyObject) {
        self.choice = 4
        self.performSegueWithIdentifier("chooseImage", sender: self)
    }
    
    
    @IBAction func pic5selected(sender: AnyObject) {
        self.choice = 5
        self.performSegueWithIdentifier("chooseImage", sender: self)
    }
    
    @IBAction func pic6selected(sender: AnyObject) {
        self.choice = 6
        self.performSegueWithIdentifier("chooseImage", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chooseImage"
        {
            //set the EditViewController's variable to the name we retrieved from the parse database.
            if let destinationVC = segue.destinationViewController as? ImageAddViewController{
                destinationVC.choice = self.choice
                destinationVC.key = self.key
            }
        }

    }
    
}

