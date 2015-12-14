//
//  EditInfoViewController.swift
//  petsitter
//
//  Created by MU IT Program on 12/12/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit
import Parse
import Bolts
import CoreData

class EditInfoViewController: UIViewController {

    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var perTxt: UITextField!
    
    @IBOutlet weak var feedTxt: UITextField!
    
    @IBOutlet weak var actTxt: UITextField!
    
    @IBOutlet weak var conTxt: UITextField!
    
    @IBOutlet weak var numTxt: UITextField!
    
    var pet_key = String()
    
    var index_for_array = Int()
    
    var corePets = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPet()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPet(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Pet")
        
        do {
            let fetchedResults =
            try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResults {
                corePets = results
                var i = 0
                while i < corePets.count{
                    if pet_key == corePets[i].valueForKey("pet_key") as! String{
                        index_for_array = i;
                        print(corePets[i].valueForKey("pet_name") as! String)
                    }
                    i++
                }
            } else {
                print("Could not fetch pets")
            }
        } catch {
            return
        }
    }


    @IBAction func saveChanges(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let query = PFQuery(className:"Pet")
        query.getObjectInBackgroundWithId(self.pet_key) {
            (pet: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let pet = pet {
                //if_else will handle the feeding updates
                if self.feedTxt.text == "Edit feeding instructions here:" || self.feedTxt.text == "" || self.feedTxt.text == nil{
                    //nothing was entered, so we don't wish to update it.
                    print("Feeding instructions were left void, do not handle.")
                    
                }
                else{
                    pet["feeding_instructions"] = self.feedTxt.text
                    pet.saveInBackground()
                    
                    self.corePets[self.index_for_array].setValue(self.feedTxt.text, forKey: "pet_feeding")
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Could not save into core data \(error), \(error.userInfo)")
                    }

                    print("Feeding instructions should have updated they instructions")
                }
                //if_else will handle the activity updates
                if self.actTxt.text == nil || self.actTxt.text == "Edit activity instructions here:" || self.actTxt.text == " " || self.actTxt.text == ""{
                    //nothing was entered, so we don't wish to update it.
                    print("activity instructions were left void, do not handle.")
                }
                else{
                    pet["activity_instructions"] = self.actTxt.text
                    pet.saveInBackground()
                    print("Activity instructions should have updated they instructions")
                    
                    self.corePets[self.index_for_array].setValue(self.actTxt.text, forKey: "pet_activity")
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Could not save into core data \(error), \(error.userInfo)")
                    }
                }
                
                if self.nameTxt.text == nil || self.nameTxt.text == ""{
                    //don't handle
                }
                else{
                    pet["pet_name"] = self.nameTxt.text
                    pet.saveInBackground()
                    print("name should have updated they instructions")
                    
                    self.corePets[self.index_for_array].setValue(self.nameTxt.text, forKey: "pet_name")
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Could not save into core data \(error), \(error.userInfo)")
                    }

                }
                
                if self.perTxt.text == nil || self.perTxt.text == ""{
                    //don't handle
                }
                else{
                    pet["pet_bio"] = self.perTxt.text
                    pet.saveInBackground()
                    print("name should have updated they instructions")
                    
                    self.corePets[self.index_for_array].setValue(self.perTxt.text, forKey: "pet_bio")
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Could not save into core data \(error), \(error.userInfo)")
                    }

                }
                if self.conTxt.text == nil || self.numTxt.text == nil || self.numTxt.text == "" || self.conTxt.text == ""{
                    //nothing was entered, so we don't wish to update it.
                    print("contact updates were left void, do not handle. Both fields must be filled out in order to update.")
                }
                else{
                    pet["emergency_contact"] = self.conTxt.text
                    pet["emergency_phone"] = self.numTxt.text
                    pet.saveInBackground()
                    print("Contact changes should have updated they instructions")
                    
                    self.corePets[self.index_for_array].setValue(self.conTxt.text, forKey: "pet_contact")
                    self.corePets[self.index_for_array].setValue(self.numTxt.text, forKey: "pet_number")
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Could not save into core data \(error), \(error.userInfo)")
                    }
                }
                let alert = UIAlertController(title: "Success!", message: "Your changes have saved successfully.", preferredStyle: UIAlertControllerStyle.Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
                alert.addAction(OKAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }
    

}
