//
//  ViewController.swift
//  CoreDataHitList
//
//  Created by Shahid on 4/5/16.
//  Copyright © 2016 Sk. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var people = [NSManagedObject]()
    
    var managedObjectContext: NSManagedObjectContext? {
        get{
            guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
                return nil
            }
            return appDelegate.managedObjectContext
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "The List"
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        if let managedObjectContext = managedObjectContext {
            let personFetchRequest = NSFetchRequest(entityName: "Person")
            
            do {
                let results = try managedObjectContext.executeFetchRequest(personFetchRequest)
                people = results as! [NSManagedObject]
            }   catch let error as NSError {
                print("Could not get items \(error)")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addName(sender: AnyObject) {
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { [weak self] (action) in
            
            guard let textField = alert.textFields?.first else {
                print("There is no text field found in the alert")
                return
            }
            
            if let enteredName = textField.text {
                self?.savePerson(withName: enteredName)
                self?.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in
            
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField) in
            
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        let person = people[indexPath.row]
        cell?.textLabel?.text = person.valueForKey("name") as? String
        return cell!
    }
}

extension ViewController {
    
    func  savePerson(withName name: String) {
        
        if let managedObjectContext = self.managedObjectContext {
            if let personEntity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedObjectContext) {
                
                let personManagedObject = NSManagedObject(entity: personEntity, insertIntoManagedObjectContext: managedObjectContext)
                
                personManagedObject.setValue(name, forKey:"name")
                
                do {
                    try managedObjectContext.save()
                    self.people.append(personManagedObject)
                } catch let error as NSError {
                    print("Could not save person because of \(error) which says \(error.userInfo)")
                }
                
            }
        }
        
    }
}

