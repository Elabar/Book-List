//
//  EditViewController.swift
//  Assignment2
//
//  Created by Lee Hoe Mun on 04/08/2018.
//  Copyright © 2018 Lee Hoe Mun. All rights reserved.
//

import UIKit
import CoreData

class EditViewController:UIViewController,UIPickerViewDataSource,UIPickerViewDelegate{
    
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var authorText: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var statusText: UITextField!
    @IBOutlet weak var ratingPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var selectedBook: Book!
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    
    let rating = [1,2,3,4,5]
    override func viewDidLoad() {
        ratingPicker.delegate = self
        ratingPicker.dataSource = self
        titleText.text = selectedBook.value(forKey: "title") as? String
        authorText.text = selectedBook.value(forKey: "author") as? String
        categoryText.text = selectedBook.value(forKey: "category") as? String
        statusText.text = selectedBook.value(forKey: "status") as? String
        ratingPicker.selectRow(selectedBook.value(forKey: "rating") as! Int - 1, inComponent: 0, animated: true)
        datePicker.setDate(selectedBook.purchasedDate!, animated: true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if titleText.text == ""{
            popUpMsg(title: "Fail to edit", msg: "Title cannot be empty.")
            return false
        }else{
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            selectedBook.setValue(titleText.text, forKey: "title")
            selectedBook.setValue(authorText.text, forKey: "author")
            selectedBook.setValue(categoryText.text, forKey: "category")
            selectedBook.setValue(statusText.text, forKey: "status")
            selectedBook.setValue(rating[ratingPicker.selectedRow(inComponent: 0)], forKey: "rating")
            selectedBook.setValue(datePicker.date, forKey: "purchasedDate")
        do{
            try managedContext.save()
            let detailVC = segue.destination as! DetailsViewController
            detailVC.bTitle = titleText.text
            detailVC.bAuthor = authorText.text
            detailVC.bCategory = categoryText.text
            detailVC.bStatus = statusText.text
            detailVC.bRating = String(rating[ratingPicker.selectedRow(inComponent: 0)])
            detailVC.bDate = datePicker.date
        }catch{
            print("Fail at editing save operation")
        }
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
    
    func popUpMsg(title: String,msg: String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController,animated:true,completion: nil)
    }
}
