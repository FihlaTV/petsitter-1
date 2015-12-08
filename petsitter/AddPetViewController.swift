//
//  AddPetViewController.swift
//  petsitter
//
//  Created by Devin Clark on 11/19/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit

class AddPetViewController: UIViewController {

    @IBOutlet weak var personalityLabel: UILabel!
    @IBOutlet weak var feedingInstructions: UILabel!
    @IBOutlet weak var activityInstructions: UILabel!
    @IBOutlet weak var emergencyContact: UILabel!
    @IBOutlet weak var addPhotoVideo: UILabel!
    @IBOutlet weak var segmentBar: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentBar.hidden = true
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "barButtonItemClicked:"), animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Done button clicked
    @IBAction func barButtonItemClicked(send: AnyObject) {
    
    }
    @IBAction func segmentChanged(sender: AnyObject) {
    }
    
  
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}