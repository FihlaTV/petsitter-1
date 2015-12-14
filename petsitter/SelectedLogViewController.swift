//
//  SelectedLogViewController.swift
//  petsitter
//
//  Created by MU IT Program on 12/13/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit
import Parse
import Bolts

class SelectedLogViewController: UIViewController {

   
    var logInfo = String()
    
    var logPic = UIImage()
    var key = String()
    
    @IBOutlet weak var info: UITextView!
    
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        info.text = logInfo
        
    }
    override func viewWillAppear(animated: Bool) {
        let query = PFQuery(className: "Pet_log")
        query.whereKey("objectId", equalTo: key)
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil || object?.valueForKey("log_photo") == nil{
                print("No image")
            } else {
              
                //Retrieves the picture as a PFFile "parse framework file"
                let pet_pic = (object?["log_photo"] as! PFFile)
                
                //extra step required to transform the pffile object into a uiimage
                pet_pic.getDataInBackgroundWithBlock { (imageData: NSData?, error:NSError?) -> Void in
                    if error == nil {
                        let image = UIImage(data: imageData!)
                    
                        self.image.image = image
                        
                    }
                }
            }
        }
        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
