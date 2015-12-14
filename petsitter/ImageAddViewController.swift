//
//  ImageAddViewController.swift
//  petsitter
//
//  Created by MU IT Program on 12/14/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit
import Parse
import Bolts

class ImageAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {

    var key = String()
    var choice = Int()
    var pet_pic = [PFFile]()
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
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
            if error != nil || object == nil || object?.valueForKey("pic_\(self.choice)") == nil{
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
    
    @IBAction func saveChanges(sender: AnyObject) {
        self.spinner.startAnimating()
        if image.image != nil{
            let imageToBeUploaded = self.image.image
        
            let imageData = UIImagePNGRepresentation(imageToBeUploaded!)!
        
            let file: PFFile = PFFile(data: imageData)!
            var imageSize = Float(imageData.length)
            imageSize = imageSize/(1024*1024)
        
        
            if imageSize <= (1024*1024){
                let query = PFQuery(className: "Pet_photos")
                query.whereKey("pet_key", equalTo: key)
                query.getFirstObjectInBackgroundWithBlock {
                    (object: PFObject?, error: NSError?) -> Void in
                    if error != nil || object == nil{
                        print("No files pulled")
                    } else {
                        
                        object!.setValue(file, forKey: "pic_\(self.choice)")
                    
                        do{
                            try object!.save()
                        }catch let error as NSError{
                            print(error)
                        }
                    
                        self.spinner.stopAnimating()
                        let alert = UIAlertController(title: "Success!", message: "Your changes have saved successfully.", preferredStyle: UIAlertControllerStyle.Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        self.navigationController?.popToRootViewControllerAnimated(true)
                        }
                        alert.addAction(OKAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        else{
            let alert = UIAlertController(title: "Error!", message: "No image was selected", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }

    @IBAction func selectImage(sender: AnyObject) {
        self.image.image = nil
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary)!
        imagePicker.allowsEditing = false
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.image.image = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
