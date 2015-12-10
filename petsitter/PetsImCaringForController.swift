//
//  PetsImCaringForController.swift
//  petsitter
//
//  Created by Devin Clark on 12/8/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit
import CoreData
import Parse
import Bolts

class PetsImCaringForController: UITableViewController {
    
    var corePets = [NSManagedObject]()
    
    var coreSit: NSManagedObject?
    
    var activityInst = String()
    var bio = String()
    var name = String()
    var pet_key = String()
    var emerName = String()
    var feedingInst = String()
    var emerPhone = String()
    
    @IBAction func addPet(sender: AnyObject) {
        let alert = UIAlertController(title: "Add Pet Code", message: "Enter the pet code provided by the pet owner", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler(nil)
        let submitAction = UIAlertAction(title: "Submit", style: .Default) { [alert] (action: UIAlertAction!) in
            
            let answer = alert.textFields![0]
            if let pet_code = answer.text {
                print(pet_code)
                let query = PFQuery(className: "Pet")
                query.whereKey("pet_code", equalTo: pet_code)
                query.getFirstObjectInBackgroundWithBlock {
                    (object: PFObject?, error: NSError?) -> Void in
                    if error != nil || object == nil {
                        print("The request failed inside addPet")
                    }
                    else {
                        self.pet_key = (object!.valueForKey("objectId"))! as! String
                        
                        self.activityInst = (object!.valueForKey("activity_instructions"))! as! String
                        self.emerName = (object!.valueForKey("emergency_contact"))! as! String
                        self.feedingInst = (object!.valueForKey("feeding_instructions"))! as! String
                        self.emerPhone = (object!.valueForKey("emergency_phone"))! as! String
                        self.bio = (object!.valueForKey("pet_bio"))! as! String
                        self.name = (object!.valueForKey("pet_name"))! as! String
                        
                        print(self.pet_key," : Key retrieved from db")
                        print(self.activityInst," : activity retrieved from db")
                        print(self.emerName," : emername retrieved from db")
                        print(self.feedingInst," : feeding retrieved from db")
                        print(self.emerPhone," : phone retrieved from db")
                        print(self.bio," : bio retrieved from db")
                        print(self.name," : name retrieved from db")

                        self.createPetInCoreData()
                        self.loadPets()
                        self.tableView.reloadData()
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func createPetInCoreData(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        if coreSit == nil{
            let petEntity = NSEntityDescription.entityForName("Sitting", inManagedObjectContext: managedContext)
            coreSit = NSManagedObject(entity: petEntity!, insertIntoManagedObjectContext: managedContext)
        }
        
        print("Here in core, pet key = ", self.pet_key)
        
        self.coreSit?.setValue(self.name, forKey: "sit_name")
        self.coreSit?.setValue(self.bio, forKey: "sit_bio")
        self.coreSit?.setValue(self.feedingInst, forKey: "sit_feeding")
        self.coreSit?.setValue(self.activityInst, forKey: "sit_activity")
        self.coreSit?.setValue(self.emerName, forKey: "sit_contact")
        self.coreSit?.setValue(self.emerPhone, forKey: "sit_number")
        self.coreSit?.setValue(self.pet_key, forKey: "sit_key")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save into core data \(error), \(error.userInfo)")
        }
        
        //self.uploadImageToDatabase()
        
    }

    
    override func viewWillAppear(animated: Bool) {
        loadPets()
        tableView.reloadData()
    }
    
    func loadPets(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Sitting")
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return corePets.count
    }
    
    //uncomment when view controller and segue are added
    /*override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.performSegueWithIdentifier("sitInfoSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "sitInfoSegue"
    {
    if let destination = segue.destinationViewController as? SitInfoViewController {
    if let petIndex = tableView.indexPathForSelectedRow?.row {
    let corePet = corePets[petIndex]
    
    let name = corePet.valueForKeyPath("sit_name") as! String
    let key = corePet.valueForKey("sit_key") as! String
    let bio = corePet.valueForKey("sit_bio") as! String
    let feed = corePet.valueForKey("sit_feeding") as! String
    let act = corePet.valueForKey("sit_activity") as! String
    let contact = corePet.valueForKey("sit_contact") as! String
    let number = corePet.valueForKey("sit_number") as! String
    
    destination.name_of_pet = name
    destination.key_of_pet = key
    destination.pet_bio_passed = bio
    destination.feed_passed = feed
    destination.act_passed = act
    destination.contact_name = contact
    destination.contact_number = number
    
    }
    }
    }
    }*/
    
    //=========================================
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //let cell = tableView.dequeueReusableCellWithIdentifier("caringPetCell", forIndexPath: indexPath)
    
    // Caleb Code
        var pet_pic = [PFFile]()
        let cell = tableView.dequeueReusableCellWithIdentifier("caringPetCell", forIndexPath: indexPath) as!CaringForTableViewCell
        
        let corePet = corePets[indexPath.row]
        let petKey = corePet.valueForKey("sit_key") as! String
        let petName = corePet.valueForKey("sit_name") as! String
        let petBio = corePet.valueForKey("sit_bio") as! String
        print(petKey)
        
        let query = PFQuery(className: "Pet_photos")
        query.whereKey("pet_key", equalTo: petKey)
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("The getFirstObject request failed inside of the myPetsTVC, in cell function.")
            } else {
                //Retrieves the picture as a PFFile "parse framework file"
                pet_pic.append(object?["profile_pic"] as! PFFile)
                
                //extra step required to transform the pffile object into a uiimage
                pet_pic[0].getDataInBackgroundWithBlock { (imageData: NSData?, error:NSError?) -> Void in
                    if error == nil {
                        let image = UIImage(data: imageData!)
                        
                        cell.petImageView.image = image
                    }
                }
            }
            
        }
        
        //this is where we continue
        
        cell.petNameLabel.text = petName
        cell.petBioLabel.text = petBio
        
    //end caleb code
        
    return cell
    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
