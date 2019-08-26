//
//  AddViewController.swift
//  Assignment2
//
//  Created by Lee Hoe Mun on 01/08/2018.
//  Copyright © 2018 Lee Hoe Mun. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource{
    
    
    @IBOutlet weak var ratingPicker: UIPickerView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var authorText: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var statusText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var appDelegate : AppDelegate!
    var managedContext : NSManagedObjectContext!
    let rating = [1,2,3,4,5]
    override func viewDidLoad() {
        ratingPicker.dataSource = self
        ratingPicker.delegate = self
        guard let delegate = UIApplication.shared.delegate as? AppDelegate
            else{
                print("Fail in addview loading")
                return
        }
        appDelegate = delegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(rating[row])
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rating.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let entity = NSEntityDescription.entity(forEntityName: "Book", in: managedContext)!
            let book = NSManagedObject(entity: entity, insertInto: managedContext)
            book.setValue(titleText.text, forKey: "title")
            book.setValue(authorText.text, forKey: "author")
            book.setValue(categoryText.text, forKey: "category")
            book.setValue(statusText.text, forKey: "status")
            book.setValue(rating[ratingPicker.selectedRow(inComponent: 0)], forKey: "rating")
            book.setValue(datePicker.date, forKey: "purchasedDate")
            do{
                try managedContext.save()
            }catch{
                print("Fail to save details")
            }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
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
        
        if titleText.text == ""{
            popUpMsg(title: "Fail to add new collection", msg: "Please fill in the title to create new collection")
            return false
        }else if searchResult != nil{
            popUpMsg(title: "Duplicate collection", msg: "An existing collection with the same name found, please edit the collection instead of adding a new entry.")
            return false
        }else{
            return true
        }
    }
    func popUpMsg(title: String,msg: String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController,animated:true,completion: nil)
    }
    
}
