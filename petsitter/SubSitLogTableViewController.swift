//
//  SubSitLogTableViewController.swift
//  petsitter
//
//  Created by MU IT Program on 12/13/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit
import Parse
import Bolts

class SubSitLogTableViewController: UITableViewController {

    var key = String()
    var array = [String]()
    var log_dates = [NSDate]()
    var log_info = [String]()
    var log_image = [PFFile]()
    var id = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPetLogs()
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func loadPetLogs(){
        let query = PFQuery(className:"Pet_log")
        query.whereKey("pet_key", equalTo:self.key)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) dates.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
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
        
        return self.array.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("logCell", forIndexPath: indexPath) as! SubSitLogTableViewCell
        let format = NSDateFormatter()
        format.dateStyle = .LongStyle
        
        let temp = log_dates[indexPath.row]
        
        cell.titleLabel.text = format.stringFromDate(temp)
        
        return cell
    }
    
   
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("selectedLog", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newLog"
        {
            if let destination = segue.destinationViewController as? SubAddLogContainerViewController {
                destination.key = self.key
            }
        }
        
        if segue.identifier == "selectedLog"{
            if let destination = segue.destinationViewController as? SelectSitLogViewController {
                
                if let logIndex = tableView.indexPathForSelectedRow?.row {
                    let info = log_info[logIndex]
                    let key = id[logIndex]
                    destination.key = key
                    destination.info = info
                    
                }
            }
            
        }

    }
    
    
    
    
}
