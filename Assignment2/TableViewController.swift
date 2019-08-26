//
//  TableViewController.swift
//  Assignment2
//
//  Created by Lee Hoe Mun on 31/07/2018.
//  Copyright © 2018 Lee Hoe Mun. All rights reserved.
//
import UIKit
import CoreData

class TableViewController: UITableViewController{
    
    var appDelegate: AppDelegate!
    var manageContext: NSManagedObjectContext!
    var newBook: Bool!
    var data: [Book]!
    override func viewDidLoad() {
    guard let delegate = UIApplication.shared.delegate as? AppDelegate
        else{
            print("Something wrong when loading tableview")
            return
        }
        appDelegate = delegate
        manageContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Book")
        do{
            data = try manageContext.fetch(fetchRequest) as? [Book]
        }catch{
            print("Something wrong when fetching data in tableview")
        }
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        cell = tableView.dequeueReusableCell(withIdentifier: "BookCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "BookCell")
        }
        
        cell!.textLabel!.text = data[indexPath.row].value(forKey: "title") as? String
        
        return cell!
    }
    
    override func tableView(_ tableView:UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath:IndexPath){
        if editingStyle == .delete{
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Book")
            let searchCriteria = "title == '\(data[indexPath.row].title!)'"
            let predicate = NSPredicate(format: searchCriteria)
            fetchRequest.predicate = predicate
            do{
                let book = try manageContext.fetch(fetchRequest)[0] as! Book
                manageContext.delete(book)
            }catch{
                print("Fail to search for delete")
            }
            do{
                try manageContext.save()
            }catch{
                print("Fail to save after deletion")
            }
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let bookDetailVC = segue.destination as! DetailsViewController
            bookDetailVC.selectedBook = data[indexPath.row]
        }
    }
    
    @IBAction func returnFromAdd(segue: UIStoryboardSegue){
        print("return from add")
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Book")
        do{
            data = try manageContext.fetch(fetchRequest) as? [Book]
        }catch{
            print("Something wrong when fetching data in tableview")
        }
        let indexPath = IndexPath(row: data.count - 1,section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}
