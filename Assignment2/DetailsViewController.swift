//
//  ViewController.swift
//  Assignment2
//
//  Created by Lee Hoe Mun on 24/07/2018.
//  Copyright © 2018 Lee Hoe Mun. All rights reserved.
//

import CoreData
import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var authorText: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var statusText: UITextField!
    @IBOutlet weak var ratingText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var selectedBook: Book!
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    
    var bTitle:String!
    var bAuthor:String!
    var bCategory:String!
    var bStatus:String!
    var bRating:String!
    var bDate:Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let delegate = UIApplication.shared.delegate as? AppDelegate
            else{
                print("FAILFAILFAIL")
                return
        }
        appDelegate = delegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        titleText.text = selectedBook.value(forKey: "title") as? String
        authorText.text = selectedBook.value(forKey: "author") as? String
        categoryText.text = selectedBook.value(forKey: "category") as? String
        statusText.text = selectedBook.value(forKey: "status") as? String
        ratingText.text = String((selectedBook.value(forKey: "rating") as? Int)!)
        datePicker.setDate(selectedBook.purchasedDate!, animated: true)
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Book")
        let searchCriteria = "title == '\(titleText.text!)'"
        let predicate = NSPredicate(format: searchCriteria)
        fetchRequest.predicate = predicate
        var searchResult:Book!
        do{
            let searchBuffer = try managedContext.fetch(fetchRequest)
            if !searchBuffer.isEmpty {
                searchResult = searchBuffer[0] as? Book
            }
        }catch{
            print("Search fail")
        }
        if searchResult == nil && titleText.text != nil && authorText.text != nil && categoryText.text != nil && statusText.text != nil && ratingText.text != nil, let rating = Int16(ratingText.text!){
            let entity = NSEntityDescription.entity(forEntityName: "Book", in: managedContext)!
            let book = NSManagedObject(entity: entity, insertInto: managedContext)
            book.setValue(titleText.text, forKey: "title")
            book.setValue(authorText.text, forKey: "author")
            book.setValue(categoryText.text, forKey: "category")
            book.setValue(statusText.text, forKey: "status")
            book.setValue(rating, forKey: "rating")
            
            do{
                try managedContext.save()
                print("Success")
            }catch{
                print("Fail to save details")
            }
        }else{
            if searchResult != nil{
                print("same title found")
            }else{
                print("Invalid DATA!")
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editVC = segue.destination as! EditViewController
        editVC.selectedBook = selectedBook
        editVC.appDelegate = appDelegate
        editVC.managedContext = managedContext
    }
    
    @IBAction func returnFromEdit(segue: UIStoryboardSegue){
        titleText.text = bTitle
        authorText.text = bAuthor
        categoryText.text = bCategory
        statusText.text = bStatus
        ratingText.text = bRating
        datePicker.setDate(bDate, animated: true)
    }
}

