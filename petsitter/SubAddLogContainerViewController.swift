//
//  SubAddLogContainerViewController.swift
//  petsitter
//
//  Created by Devin Clark on 12/12/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit
import Parse
import Bolts


class SubAddLogContainerViewController: UIViewController {

    @IBOutlet weak var start_date: UIDatePicker!
    
    @IBOutlet weak var end_date: UIDatePicker!
    var key = String()
    var code_displayed = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func saveDates(sender: AnyObject) {
        var code = arc4random_uniform(10000000) + 100000
        code_displayed = code.description
        print(self.key)
        let query = PFQuery(className: "Pet")
        query.whereKey("objectId", equalTo: self.key)
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("The getFirstObject request failed inside of the myPetsTVC, in cell function.")
            } else if let pet = object{
                pet["pet_code"] = code.description
                pet["start_date"] = self.start_date.date
                pet["end_date"] = self.end_date.date
                
                pet.saveInBackground()
                print("Should of saved")
                
                
                
                
                let alertController = UIAlertController(title: "Success!", message: "Your pet has been given a code.  Please copy it and send it to your desired pet sitter via text. CODE:\(code) ", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }))
                alertController.addTextFieldWithConfigurationHandler(self.configurationTextField)
                
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
            
        }
    }
    
    func configurationTextField(textField: UITextField!)
    {
        if let aTextField = textField {
            textField.text = code_displayed
            

        }
    }

}
