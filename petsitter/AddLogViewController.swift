//
//  AddLogViewController.swift
//  petsitter
//
//  Created by Devin Clark on 12/10/15.
//  Copyright © 2015 Devin Clark. All rights reserved.
//

import UIKit
import Parse
import Bolts

class AddLogViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var image: UIImageView!
   
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var key = String()
   
    
    @IBOutlet weak var desc: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        desc.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 1.9, alpha: 1.0).CGColor
        desc.layer.borderWidth = 2.0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveLog(sender: AnyObject) {
        spinner.startAnimating()
        var log_info = String()
        
        if desc.text == "" || desc.text == nil{
            let alertController = UIAlertController(title: "Error!", message: "You may not leave the description empty, log must be filled out before saving anything!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            log_info = desc.text!
            //image was not added.
            if image.image == nil{
                let newLog = PFObject(className: "Pet_log")
                newLog["pet_key"] = self.key
                newLog["pet_id"] = PFObject(withoutDataWithClassName: "Pet", objectId: self.key)
                newLog["log_info"] = log_info
                newLog.saveInBackground()
                
                
                spinner.stopAnimating()
                
                let alertController = UIAlertController(title: "Success!", message: "Your pet log has been successfully created.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                    self.navigationController?.popViewControllerAnimated(true)
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            //image was added.
            else{
                let newLog = PFObject(className: "Pet_log")
                newLog["pet_key"] = self.key
                newLog["pet_id"] = PFObject(withoutDataWithClassName: "Pet", objectId: self.key)
                newLog["log_info"] = log_info
                
                
                let imageToBeUploaded = self.image.image
                
                let imageData = UIImagePNGRepresentation(imageToBeUploaded!)!
                
                let file: PFFile = PFFile(data: imageData)!
                var imageSize = Float(imageData.length)
                imageSize = imageSize/(1024*1024)
                
                if imageSize <= (1024*1024){
                    newLog["log_photo"] = file
                    
                    newLog.saveInBackground()
                    
                    let alertController = UIAlertController(title: "Success!", message: "Your pet log has been successfully created.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                        self.navigationController?.popViewControllerAnimated(true)
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    spinner.stopAnimating()
                }
                else{
                    //spinner.stopAnimating()
                    let alertController = UIAlertController(title: "Error!", message: "The image selected is greater than 10Mb and is too large to be uploaded, please select a different image!", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }

            }
        }
        
    }
    

    @IBAction func selectImage(sender: AnyObject) {
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
