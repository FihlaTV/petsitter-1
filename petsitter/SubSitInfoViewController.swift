//
//  SubSitInfoViewController.swift
//  petsitter
//
//  Created by MU IT Program on 12/13/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit

class SubSitInfoViewController: UIViewController {

    @IBOutlet weak var petFeed: UITextView!
    
    @IBOutlet weak var petAct: UITextView!
    
    @IBOutlet weak var conName: UILabel!
    
    @IBOutlet weak var conNum: UIButton!
    
    @IBOutlet weak var pic1: UIImageView!
    
    @IBOutlet weak var pic2: UIImageView!
    
    @IBOutlet weak var pic3: UIImageView!
    
    @IBOutlet weak var pic4: UIImageView!
    
    @IBOutlet weak var pic5: UIImageView!
    
    @IBOutlet weak var pic6: UIImageView!
    
    
    var feed_passed = String()
    var act_passed = String()
    var contact_name = String()
    var contact_number = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillInformation()
        print(feed_passed, " fp")
        // Do any additional setup after loading the view.
    }
    
    func fillInformation(){
        petFeed.text = feed_passed
        petAct.text = act_passed
        conName.text = contact_name
        conNum.setTitle(contact_number, forState: .Normal)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func call_number(sender: AnyObject) {
        
        
    }
    

}
