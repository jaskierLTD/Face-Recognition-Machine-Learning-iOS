//
//  PersonTableViewController.swift
//
//  Created by Oleksandr Z 2017(c).
//
import UIKit
import Foundation
import CoreData

class PersonTableViewController: UITableViewController, NSFetchedResultsControllerDelegate
{
    @IBOutlet weak var menuButton:UIBarButtonItem!
    var identities : [Identity] = []
    var idSet = [Int]()
    var idToPass : Int = -1
    var defaults = UserDefaults.standard
    
    @IBAction func addButtonPressed(_ sender: Any)
    {
        defaults.set(idToPass, forKey: "idPost")
        switchScreen()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // - - - - - - - - - V I S U A L I Z A T I O N - - - - - - - - -
        if self.revealViewController() != nil
        {
            self.revealViewController().rearViewRevealWidth = 250
            self.revealViewController().frontViewShadowRadius = 10
            self.revealViewController().frontViewShadowColor = UIColor.black
            self.revealViewController().frontViewShadowOpacity = 1
            
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.clearsSelectionOnViewWillAppear = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        DispatchQueue.main.async
        {
            let fetchRequest:NSFetchRequest<Identity> = Identity.fetchRequest()
            do {
                self.identities = try DatabaseController.getContext().fetch(fetchRequest)
                print("number of results: \(self.identities.count)")
                for identity in self.identities as [Identity]
                {
                    self.idSet.append(Int(identity.id))
                    print("\(identity.pName!) is \(identity.accuracy)% Robesper. Updeted \(identity.lastModified!).")
                }
                self.defaults.set(self.idSet, forKey: "idSet")
            }
            catch
            {
                print("Error fetchRequest in ViewWillApper: \(error)")
            }
            DatabaseController.saveContext()
            self.tableView.reloadData()
        }
    }
    
    //MARK: NSFetchedResultsController Delegate Functions
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            DatabaseController.getContext().delete(identities.remove(at: indexPath.row))
            DatabaseController.saveContext()
            tableView.reloadData()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type
        {
        case NSFetchedResultsChangeType.insert:
            tableView.insertRows(at: NSArray(object: newIndexPath!) as! [IndexPath], with: UITableViewRowAnimation.fade)
            break
        case NSFetchedResultsChangeType.delete:
            tableView.deleteRows(at: NSArray(object: indexPath!) as! [IndexPath], with: UITableViewRowAnimation.fade)
            break
        case NSFetchedResultsChangeType.move:
            tableView.deleteRows(at: NSArray(object: indexPath!) as! [IndexPath], with: UITableViewRowAnimation.fade)
            tableView.insertRows(at: NSArray(object: newIndexPath!) as! [IndexPath], with: UITableViewRowAnimation.fade)
            break
        case NSFetchedResultsChangeType.update:
            tableView.cellForRow(at: indexPath! as IndexPath)
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.endUpdates()
    }

    // MARK: - Table view data source
    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return fetchedResultsController?.sections?.count ?? 0
    }*/
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return identities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as!PersonTableViewCell
        let identity = identities[indexPath.row]
        cell.typeImage.image = UIImage(named: "ENTP")
        cell.name.text = identity.pName
        cell.type.text = identity.imType
        cell.photo.image = UIImage(named: "author")
        cell.time.text = Helper.timeAgoSinceDate(identity.lastModified! as Date, currentDate: Date(), numericDates: true)
        return cell
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow
        //let currentCell = tableView.cellForRow(at: indexPath!) as UITableViewCell!;
        
        idToPass = idSet[(indexPath?.row)!]
        defaults.set(idToPass, forKey: "idPost")
        defaults.set(indexPath?.row, forKey: "row")

        print(idSet)
        print(idToPass)
        //performSegue(withIdentifier: "idSegue", sender: self)
    }
    
    func switchScreen()
    {
        /*let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "PersonDetailNav") as UIViewController
        self.present(vc, animated: true, completion: nil)*/
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "DetailedViewController") as! DetailedViewController
        navigationController?.pushViewController(nextVC, animated: true)
        
        //self.present(alertController, animated: true, completion: nil)
    }
}
