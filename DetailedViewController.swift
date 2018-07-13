//
//  DetailedViewController.swift
//  GetMeSocialDetailViewController
//
//  Created by Iorweth on 25/04/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//
import UIKit
import CoreData

extension UIViewController
{
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

class DetailedViewController: UITableViewController, UITextFieldDelegate
{
    var transferedId: Int = -1
    var transferedRaw: Int = 0
    var transferedSet = [Int]()
    var transferedImage: UIImage?
    var popDatePicker : PopDatePicker?
    var identities : [Identity] = []

    @IBOutlet weak var photoCell: UITableViewCell!
    @IBOutlet weak var accCell: UITableViewCell!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var birthField: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var camButton: UIButton!
    @IBOutlet weak var modified: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        camButton.layer.cornerRadius = (camButton.bounds.width/2)
        camButton.layer.masksToBounds = true
        
        // - - - - - - - - - - C H E C K - - - - - - - - - -
        if((self.transferedImage) != nil)   {   image.image = transferedImage   }
        //transferedSet = (UserDefaults.standard.object(forKey: "idSet") as? [Int])!
        //transferedId = (UserDefaults.standard.object(forKey: "idPost") as? Int)!
        // if let transferedRaw = (UserDefaults.standard.object(forKey: "raw") as? String)
        //{}
        print(transferedId,"didLoad Detailed")
        print(transferedSet,"didLoad Detailed")
        
        nameField.delegate = self
        self.hideKeyboardWhenTappedAround()
        popDatePicker = PopDatePicker(forTextField: birthField)
        birthField.delegate = self
        
        //Setting-up patterns & size
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "pattern_grey_linen")!)
        photoCell.backgroundColor = UIColor(patternImage: UIImage(named: "pattern_grey_linen")!)
        accCell.backgroundColor   = UIColor(patternImage: UIImage(named: "pattern_grey_linen")!)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        // - - - - - - - - - - N E W - - - - - - - - - -
        if let transferedId = (UserDefaults.standard.object(forKey: "raw") as? String)
        {
            if transferedId == "-1"
            {
                self.transferedId = transferedSet.max()! + 1
                nameField.becomeFirstResponder()
            }
        }
            
            // - - - - - - - - - - U P D A T E - - - - - - - - - -
        else
        {
            DispatchQueue.main.async
            {
                    let fetchRequest:NSFetchRequest<Identity> = Identity.fetchRequest()
                    do {
                        self.identities = try DatabaseController.getContext().fetch(fetchRequest)
                        for identity in self.identities as [Identity]
                        {
                            if identity.id == self.transferedId
                            {
                                //name
                                self.navigationController?.navigationBar.topItem?.title = identity.pName
                                self.nameField.text = identity.pName
                            
                                //birth
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "dd-MM-yyyy"
                                var dateString = dateFormatter.string(from:identity.birthDate! as Date)
                                self.birthField.text = dateString
                            
                                //modified
                                dateString = dateFormatter.string(from:identity.lastModified! as Date)
                                self.modified.text = "Modified on "+dateString
                            }
                        }
                    }
                    catch
                    {
                        print("Error fetchRequest in ViewWillApper: \(error)")
                    }
            }

        }
    }
    
    func textFieldShouldReturn(_ nameField: UITextField) -> Bool
    {   //keyboard
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if (textField === birthField)
        {
            birthField.resignFirstResponder()
            nameField.resignFirstResponder()
            
            let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
            let initDate : Date? = formatter.date(from: birthField.text!)
            
            let dataChangedCallback : PopDatePicker.PopDatePickerCallback =
            {
                (newDate : Date, forTextField : UITextField) -> () in
                // here we don't use self (no retain cycle)
                forTextField.text = (newDate.ToDateMediumString() ?? "?") as String
            }
            
            popDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
            return false
        }
        else
        {
            return true
        }
    }

    @IBAction func backButtonPressed(_ sender: Any)
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "TableViewNav") as UIViewController
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any)
    {
        DispatchQueue.main.async
        {
        var msg : String
        
        if self.nameField.text != "" && self.birthField.text != ""
        {
            // fields are filled-in
            let identityClassName   :String = String(describing:    Identity.self)
            let typeClassName       :String = String(describing:    Type.self)
            
            let identity:Identity = NSEntityDescription.insertNewObject(forEntityName: identityClassName, into: DatabaseController.getContext()) as! Identity
            
                if self.navigationController?.navigationBar.topItem?.title != "Add new member"
                {
                    let fetchRequest:NSFetchRequest<Identity> = Identity.fetchRequest()
                    do
                    {
                        self.identities = try DatabaseController.getContext().fetch(fetchRequest)
                        let transferedTableRowIndex = UserDefaults.standard.object(forKey: "row") as? Int
                        DatabaseController.getContext().delete(self.identities.remove(at: transferedTableRowIndex!))
                    }
                    catch
                    {
                        print("Error fetchRequest in ViewWillApper: \(error)")
                    }
                    DatabaseController.saveContext()
                }
            
            identity.id = Int64(self.transferedId)

            identity.pName = self.nameField.text
            identity.accuracy = 99
            identity.lastModified = Date() as NSDate
            
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                let initDate : Date? = formatter.date(from: self.birthField.text!)
            
            identity.birthDate = initDate! as NSDate
            identity.imType = "Don"
            //identity.thumbnail =
            
            let type:Type = NSEntityDescription.insertNewObject(forEntityName: typeClassName, into: DatabaseController.getContext()) as! Type
            type.imType = "4JIeHococ"
            type.addToIdentities(identity)
            
            //let imgData = UIImageJPEGRepresentation(self.transferedImage!, 1)
            
            DatabaseController.saveContext()
           
            let fetchRequest:NSFetchRequest<Identity> = Identity.fetchRequest()
            do
            {
                let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
                print("number of results: \(searchResults.count)")
                for result in searchResults as [Identity]
                {
                    print("\(result.pName!) is \(result.accuracy)% Robesper. Updeted \(result.lastModified!).")
                }
            }
            catch   { print("Error: \(error)") }
            
            DatabaseController.saveContext()
            msg = "Person: " + self.nameField.text! + " successfuly added!"
        }
        else
            {
                msg = "Name or Date is empty! Please check"
            }
        self.showAlertController(msg)
        }
    }
    
    func showAlertController(_ msg: String)
    {
        let alert:UIAlertController = UIAlertController(title: title, message: msg, preferredStyle:.alert)
        let alertAction: UIAlertAction
        
            if msg == "Name or Date is empty! Please check"
            {
                alertAction = UIAlertAction(title: "Fill in", style: .default)
            }
            
            else
            {
                alertAction = UIAlertAction(title: "Done", style: .default, handler:{
                action in
                })

                self.backButtonPressed(AnyObject.self)
            }
        
        alert.addAction(alertAction)
        self.present(alert, animated:false, completion:nil);
    }
}
