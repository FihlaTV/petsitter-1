//
//  PetProfileViewController.swift
//  petsitter
//
//  Created by MU IT Program on 11/29/15.
//Prototype of Caleb Schmitt
//

import UIKit
import CoreData
import Parse
import Bolts

// Lets pick up here tomorrow

class PetCreationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate{
    
    
    @IBOutlet weak var petImage: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //Defining the variables and connecting the ui elements to from the story board.
    //[1]
    //===============================================================================
    var corePet: NSManagedObject?
    var test: UIImageView?
    var name = String()
    var pet_key = String()
    
    @IBOutlet weak var petNameTxtField: UITextField!

    @IBOutlet weak var petPersonalityTxt: UITextField!
    
    @IBOutlet weak var petFeedingTxt: UITextField!
    
    @IBOutlet weak var petActivityTxt: UITextField!
    
    @IBOutlet weak var petContactNameTxt: UITextField!
    
    @IBOutlet weak var petContactNumberTxt: UITextField!
    //[1] - end
    //===============================================================================
    
    override func viewDidLoad() {
    //[2]
    //Setting up textfield tags, to uniquely identify them once passed into the self.delegate
    //===============================================================================
        super.viewDidLoad()
        self.test = UIImageView(image: self.petImage.image)
        petNameTxtField.tag = 0
        petNameTxtField.delegate = self
        petContactNameTxt.tag = 1
        petContactNameTxt.delegate = self
        
        petContactNumberTxt.tag = 2
        petContactNumberTxt.delegate = self
        
        petNameTxtField.delegate = self
        petPersonalityTxt.tag = 4
        petPersonalityTxt.delegate = self
        petActivityTxt.tag = 5
        petActivityTxt.delegate = self
        petFeedingTxt.tag = 5
        petFeedingTxt.delegate = self
        
        //[2] - end
    //===============================================================================
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //[3]
    //Textfield delegate, will appropriately limit specific text fields to certain char lengths and characters
    //===============================================================================
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool
    {
        
        //Pet name field
        if textField.tag == 0{
            let maxLength = 20
            let currentString: NSString = textField.text!
            let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
            
            let disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789()-!`")
            let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
            
            return newString.length <= maxLength && replacementStringIsLegal
        }
        //contact name field
        if textField.tag == 1{
            let maxLength = 20
            let currentString: NSString = textField.text!
            let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
            
            let disallowedCharacterSet = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ .").invertedSet
            let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
            return replacementStringIsLegal && newString.length <= maxLength
            
        }
        //phone number field
        if textField.tag == 2{
            let maxLength = 13
            let currentString: NSString = textField.text!
            let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
            
            let disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789()-").invertedSet
            let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
            return replacementStringIsLegal && newString.length <= maxLength
        }
        if textField.tag == 4{
            let maxLength = 40
            let currentString: NSString = textField.text!
            let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= maxLength
        }
        else{
            let maxLength = 90
            let currentString: NSString = textField.text!
            let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= maxLength
        }
        
    }
    //[3] - end
    //===============================================================================
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func selectingImage(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary)!
        imagePicker.allowsEditing = false
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.petImage.image = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
   
    @IBAction func beginSaveProcess(sender: AnyObject) {
        //temporay variables to hold the values needed from text fields after checking them for non-nil values.
        var petName = String()
        var petBio = String()
        var petFeed = String()
        var petAct = String()
        var petContact = String()
        var petNumber = String()
        
        var a = Bool(), b = Bool(), c = Bool(), d = Bool(), e = Bool(), f = Bool(), g = Bool()
        if self.petNameTxtField.text == nil || self.petNameTxtField.text == ""{
            a = false
            let alertController = UIAlertController(title: "Error!", message: "One or more fields were left blank, please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            petName = self.petNameTxtField.text!
            a = true
        }
        
        
        if self.petPersonalityTxt.text == nil || self.petPersonalityTxt.text == ""{
            b = false
            let alertController = UIAlertController(title: "Error!", message: "One or more fields were left blank, please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            petBio = self.petPersonalityTxt.text!
            b = true
        }
        
        
        if self.petFeedingTxt.text == nil || self.petFeedingTxt.text == ""{
            c = false
            let alertController = UIAlertController(title: "Error!", message: "One or more fields were left blank, please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            petFeed = self.petFeedingTxt.text!
            c = true
        }
        
        
        if self.petActivityTxt.text == nil || self.petActivityTxt.text == ""{
            d = false
            let alertController = UIAlertController(title: "Error!", message: "One or more fields were left blank, please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            petAct = self.petActivityTxt.text!
            d = true
        }
        
        
        if self.petContactNameTxt.text == nil || self.petContactNameTxt.text == ""{
            e = false
            let alertController = UIAlertController(title: "Error!", message: "One or more fields were left blank, please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            petContact = self.petContactNameTxt.text!
            e = true
        }
        
        
        if self.petContactNumberTxt.text == nil || self.petContactNumberTxt.text == ""{
            f = false
            let alertController = UIAlertController(title: "Error!", message: "One or more fields were left blank, please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            petNumber = self.petContactNumberTxt.text!
            f = true
        }
        
        if self.petImage.image == self.test!.image{
            g = false
            let alertController = UIAlertController(title: "Error!", message: "Please select your pets profile image before moving forward.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler:nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        else{
            g = true
        }
        
        if a == true && b == true && c == true && d == true && e == true && f == true && g == true{
            spinner.startAnimating()
            createPetInDatabase(petName, bio: petBio, feed: petFeed, act: petAct, contact: petContact, number: petNumber)
        }
    }
    
    func createPetInDatabase(name: String, bio: String, feed: String, act: String, contact: String, number: String){
        let newPet = PFObject(className: "Pet")
        newPet["pet_name"] = name
        newPet["emergency_contact"] = contact
        newPet["pet_bio"] = bio
        newPet["feeding_instructions"] = feed
        newPet["activity_instructions"] = act
        newPet["emergency_contact"] = contact
        newPet["emergency_phone"] = number
        //newPet.saveEventually()
        do{
            try newPet.save()
            print("Step 1: passed the pet initial save.")
        }
        catch let error as NSError{
                print("Could not save \(error)")

        }
        
        let query = PFQuery(className: "Pet")
        query.whereKey("pet_name", equalTo: name)
        query.whereKey("emergency_contact", equalTo: contact)
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("The getFirstObject request failed. [1]")
            } else {
                let petkey = (object!.valueForKey("objectId"))! as! String
                print(petkey,"This is after the first pull in create pet in db")
                self.pet_key = petkey
                print("Step 2: Pulled the newly created pets key")
                self.createPetInCoreData()
            }
        }
    }
    
    func createPetInCoreData(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        if corePet == nil{
            let petEntity = NSEntityDescription.entityForName("Pet", inManagedObjectContext: managedContext)
            corePet = NSManagedObject(entity: petEntity!, insertIntoManagedObjectContext: managedContext)
        }
        
        print("Here in core, pet key = ", self.pet_key)
        
        
        self.corePet?.setValue(self.petNameTxtField.text, forKey: "pet_name")
        self.corePet?.setValue(self.petPersonalityTxt.text, forKey: "pet_bio")
        self.corePet?.setValue(self.petFeedingTxt.text, forKey: "pet_feeding")
        self.corePet?.setValue(self.petActivityTxt.text, forKey: "pet_activity")
        self.corePet?.setValue(self.petContactNameTxt.text, forKey: "pet_contact")
        self.corePet?.setValue(self.petContactNumberTxt.text, forKey: "pet_number")
        self.corePet?.setValue(self.pet_key, forKey: "pet_key")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save into core data \(error), \(error.userInfo)")
        }
        
        self.uploadImageToDatabase()
        
    }
    
    
    func uploadImageToDatabase(){

        let imageToBeUploaded = self.petImage.image

        let imageData = UIImagePNGRepresentation(imageToBeUploaded!)!

        let file: PFFile = PFFile(data: imageData)!
        var imageSize = Float(imageData.length)
        imageSize = imageSize/(1024*1024)
        
        
        if imageSize <= (1024*1024){
            let object = PFObject(className: "Pet_photos")
            object["profile_pic"] = file
            object["pet_id"] = PFObject(withoutDataWithClassName: "Pet", objectId: self.pet_key)
            object["pet_key"] = self.pet_key
            //object.saveInBackground()
            do{
                try object.save()
            }catch let error as NSError{
                print(error)
            }
            spinner.stopAnimating()
            let alertController = UIAlertController(title: "Success!", message: "Your pet has been successfully created! Go to my pets to see!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                self.navigationController?.popToRootViewControllerAnimated(true)
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            spinner.stopAnimating()
            let alertController = UIAlertController(title: "Error!", message: "The image selected is greater than 10Mb and is too large to be uploaded, please select a different image!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        //print(self.pet_key,"key at point before photo upload.")
        
    }
    
}
