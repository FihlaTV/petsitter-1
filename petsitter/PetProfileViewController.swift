
import UIKit
import CoreData
import Parse
import Bolts

class PetProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    
    @IBOutlet weak var petImage: UIImageView!
   
    
    var corePet: NSManagedObject?
    var name = String()
    var pet_key = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func selectImageAction(sender: AnyObject) {
        
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
    
    @IBAction func saveImageAction(sender: AnyObject) {
        self.createPetInDatabase()
    }
   
    
    func createPetInDatabase(){
        let newPet = PFObject(className: "Pet")
        newPet["pet_name"] = self.name
        /*newPet["feeding_instructions"] = self.feed
        newPet["activity_instructions"] = self.act
        newPet["emergency_contact"] = self.contact
        newPet["emergency_phone"] = self.cnumber*/
        newPet.saveInBackground()
        
        
        
        let query = PFQuery(className: "Pet")
        query.whereKey("pet_name", equalTo: self.name)
        //query.whereKey("emergency_contact", equalTo: self.contact)
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("The getFirstObject request failed.")
            } else {
                let petkey = (object!.valueForKey("objectId"))! as! String
                print(petkey,"This is after the first pull in create pet in db")
                self.pet_key = petkey
                print(self.pet_key,"pet key")
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
        
        
        self.corePet?.setValue(self.name, forKey: "pet_name")
        /*self.corePet?.setValue(self.feed, forKey: "pet_feeding")
        self.corePet?.setValue(self.act, forKey: "pet_activity")
        self.corePet?.setValue(self.contact, forKey: "pet_contact")
        self.corePet?.setValue(self.cnumber, forKey: "pet_number")*/
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
        print("*Size of image: \(imageSize)Mb*")
        
        if imageSize <= (1024*1024){
            let query = PFQuery(className:"Pet")
            query.getObjectInBackgroundWithId(self.pet_key) {
                (pet: PFObject?, error: NSError?) -> Void in
                pet!["pet_profile_pic"] = file
                pet!.saveInBackground()
                
                print("Photo should have been uploaded to DB")
                print(1024*1024)
                let alertController = UIAlertController(title: "Success!", message: "Your pet has been successfully created! Go to my pets to see!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }
        else{
            let alertController = UIAlertController(title: "Error!", message: "The image selected is greater than 10Mb and is too large to be uploaded, please select a different image!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        //print(self.pet_key,"key at point before photo upload.")
        
    }
    
}
