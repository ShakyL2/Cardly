//
//  createViewController.swift
//  Cardly
//
//  Created by Kadir Duraklı on 17.01.2023.
//

import UIKit
import CoreData


class createViewController: UIViewController {
    @IBOutlet weak var frontField: UITextField!
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var behindField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var control : Bool!
    
    
    var selectedname = ""
    var selectednamebehind = ""
    var selectedcardId : UUID?
    
    override func viewDidLoad() {
        print("calisti")
        
        
        
        super.viewDidLoad()
        //recognizers
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        if (selectedname != "" ){
            Button.isHidden = true
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
                       
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
            let idString = selectedcardId?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
                       
            fetchRequest.returnsObjectsAsFaults = false
                       
            do {
                let results = try context.fetch(fetchRequest)
                           
                if results.count > 0 {
                               
                    for result in results as! [NSManagedObject] {
                                   
                        if let name = result.value(forKey: "front") as? String {
                            frontField.text = name
                        }

                        if let behindtext = result.value(forKey: "behind") as? String {
                            behindField.text = behindtext
                        }
                                   
                                  
                                   
                    }
                }

            } catch{
                print("error")
            }
            
            
            
            // Do any additional setup after loading the view.
        }
        else {
            Button.isHidden = false
            frontField.text = ""
            behindField.text = ""
                        
        }
    }
  
  

    @IBAction func saveButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newCard = NSEntityDescription.insertNewObject(forEntityName: "Cards", into: context)
        
        //Attributes
        newCard.setValue(frontField.text!, forKey: "front")
        newCard.setValue(behindField.text!, forKey: "behind")
        newCard.setValue(UUID(), forKey: "id")
        
        
        
      
        
        do {
            try context.save()
            print("success")
        } catch {
            print("error")
        }
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
}
