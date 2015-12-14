//
//  ViewImageSitterViewController.swift
//  petsitter
//
//  Created by MU IT Program on 12/14/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit
import Parse
import Bolts

class ViewImageSitterViewController: UIViewController {
    
    var key = String()
    var choice = Int()
    var pet_pic = [PFFile]()
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gatherImage()
        // Do any additional setup after loading the view.
    }
    
    
    func gatherImage(){
        let query = PFQuery(className: "Pet_photos")
        query.whereKey("pet_key", equalTo: key)
        query.selectKeys(["pic_\(choice)"])
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("The getFirstObject request failed inside of the myPetsTVC, in cell function.")
            } else {
                //Retrieves the picture as a PFFile "parse framework file"
                self.pet_pic.append(object?["pic_\(self.choice)"] as! PFFile)
                
                //extra step required to transform the pffile object into a uiimage
                self.pet_pic[0].getDataInBackgroundWithBlock { (imageData: NSData?, error:NSError?) -> Void in
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
