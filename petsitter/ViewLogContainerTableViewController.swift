//
//  ViewLogContainerTableViewController.swift
//  petsitter
//
//  Created by Devin Clark on 12/12/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit
import Parse
import Bolts

class ViewLogContainerTableViewController: UITableViewController {

    var key = String()
    var array = [String]()
    var log_dates = [NSDate]()
    var log_info = [String]()
    var log_image = [PFFile]()
    var id = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPetLogs()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func loadPetLogs(){
        let query = PFQuery(className:"Pet_log")
        
        //query.selectKeys(["objectId, pet_key, createdAt, log_info"])
        query.whereKey("pet_key", equalTo:self.key)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) dates.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object.valueForKey("createdAt"))
                        print(object.objectId)
                        let temp = object.valueForKey("objectId") as! String
                        let created = object.valueForKey("createdAt") as! NSDate
                        self.log_info.append(object["log_info"] as! String)
                        self.id.append(temp)
                        self.array.append(temp)
                        self.log_dates.append(created)
                    }
                    
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
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
        //print(self.array.count)
        return self.array.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell", forIndexPath: indexPath) as! LogOwnerTableViewCell
        let format = NSDateFormatter()
        format.dateStyle = .LongStyle
        
        let temp = log_dates[indexPath.row]
        
        print(temp)
        
        let sin = format.stringFromDate(temp)
        print(sin)
        cell.titleLabel.text = sin
        return cell
    }
    
    @IBAction func newLogButton(sender: AnyObject) {
        print(array.count)
        self.performSegueWithIdentifier("newLog", sender: self)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("viewLog", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newLog"
        {
            if let destination = segue.destinationViewController as? SubAddLogContainerViewController {
                destination.key = self.key
            }
        }
        
        if segue.identifier == "viewLog"{
            if let destination = segue.destinationViewController as? SelectedLogViewController {
                
                if let logIndex = tableView.indexPathForSelectedRow?.row {
                    let info = log_info[logIndex]
                    let key = id[logIndex]
                    destination.key = key
                    destination.logInfo = info
                    
                }
            }
            
        }
    }


  
    
}
