//
//  ItemDetailViewController.swift
//  NetWorthToday
//
//  Created by Johnathan Grayson on 7/12/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController, UIPickerViewDelegate {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    
    var item : Item!
    
    var itemType : ItemType!
    
    var selectedCategoryIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.categoryPicker.delegate = self;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(self.itemType! == ItemType.Asset) {
            self.navigationItem.title = item != nil ? "Edit Asset" : "Add Asset"
        } else {
            self.navigationItem.title = item != nil ? "Edit Liability" : "Add Liability"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(sender as? NSObject != self.doneButton) {
            return
        }
    
        if self.nameTextField.text.utf16Count > 0 {
            if(self.item == nil) {
                self.item = Item(newDocumentInDatabase: self.appDelegate.database)
            }
            
            // set the name
            self.item?.name = self.nameTextField.text
            
            // set the category
            if(self.itemType! == ItemType.Asset) {
                self.item?.category = AssetCategory.getAll()[self.selectedCategoryIndex].value
            } else {
                self.item?.category = LiabilityCategory.getAll()[self.selectedCategoryIndex].value
            }
        }
    }
    
    // MARK : - Picker View

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(self.itemType! == ItemType.Asset) {
            return AssetCategory.getAll().count
        }
        return LiabilityCategory.getAll().count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if(self.itemType! == ItemType.Asset) {
            return AssetCategory.getAll()[row].name
        }
        return LiabilityCategory.getAll()[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCategoryIndex = row
    }
    
    // MARK : - App Delegate
    
    var appDelegate : AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }
    
}
