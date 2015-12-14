//
//  ViewLogContainerTableViewController.swift
//  petsitter
//
//  Created by Devin Clark on 12/12/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit

class ViewLogContainerTableViewController: UITableViewController {

    var key = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell", forIndexPath: indexPath)


        return cell
    }
    
    @IBAction func newLogButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("newLog", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newLog"
        {
            if let destination = segue.destinationViewController as? SubAddLogContainerViewController {
                destination.key = self.key
            }
        }
    }


  
    
}
