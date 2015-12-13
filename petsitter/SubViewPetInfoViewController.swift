//
//  SubViewPetInfoViewController.swift
//  petsitter
//
//  Created by Devin Clark on 12/12/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit


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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillInformation()
        // Do any additional setup after loading the view.
    }
    
    func fillInformation(){
        petFeed.text = feed_passed
        petAct.text = act_passed
        ContactName.text = contact_name
        contactNumber.setTitle(contact_number, forState: .Normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
