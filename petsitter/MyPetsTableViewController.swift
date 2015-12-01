//
//  MyPetsTableViewController.swift
//  petsitter
//
//  Created by Devin Clark on 11/19/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit
import CoreData
import Parse
import Bolts

class MyPetsTableViewController: UITableViewController {
    
    
    var corePets = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        loadPets()
        tableView.reloadData()
    }
    
    
    func loadPets(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Pet")
        
        do {
            let fetchedResults =
            try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResults {
                corePets = results
            } else {
                print("Could not fetch pets")
            }
        } catch {
            return
        }
    }
    
    func deletePetAtIndex(index: Int){
        if (index < corePets.count){
            let corePet = corePets[index]
            
            corePets.removeAtIndex(index)
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            managedContext.deleteObject(corePet)
            // Complete save and handle potential error
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return corePets.count
    }
    
    // will pull all of the user's pets from core data
    // ============================================================
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var pet_pic = [PFFile]()
        let cell = tableView.dequeueReusableCellWithIdentifier("petCell", forIndexPath: indexPath) as!PetTableViewCell
        
        let corePet = corePets[indexPath.row]
        let petKey = corePet.valueForKey("pet_key") as! String
        let petName = corePet.valueForKey("pet_name") as! String
        
        
        let query = PFQuery(className: "Pet")
        query.whereKey("objectId", equalTo: petKey)
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("The getFirstObject request failed inside of the myPetsTVC, in cell function.")
            } else {
                //Retrieves the picture as a PFFile "parse framework file"
                pet_pic.append(object?["pet_profile_pic"] as! PFFile)
                print(pet_pic)
                //extra step required to transform the pffile object into a uiimage
                pet_pic[0].getDataInBackgroundWithBlock { (imageData: NSData?, error:NSError?) -> Void in
                    if error == nil {
                        let image = UIImage(data: imageData!)
                        cell.petImage.image = image
                    }
                }
            }
            
        }
        
        //this is where we continue
        
        cell.nameLabel.text = petName
        
        
        return cell
    }
    // ============================================================
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // this section will delete the pet from the data base
            //==========================================================
            let corePet = corePets[indexPath.row]
            let key_for_Delete = corePet.valueForKey("pet_key") as! String
            let query = PFQuery(className: "Pet")
            query.whereKey("objectId", equalTo: key_for_Delete)
            query.getFirstObjectInBackgroundWithBlock {
                (object: PFObject?, error: NSError?) -> Void in
                if error != nil || object == nil {
                    print("The getFirstObject request failed in my pets table view controller.")
                } else {
                    // The find succeeded and now will delete the object in the database.
                    print("Delete started")
                    object?.deleteInBackground()
                    
                    // Delete the row from the core data source
                    // =============================================================
                    self.deletePetAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    //============================================================
                }
                
            }
            // ============================================================
            
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}
