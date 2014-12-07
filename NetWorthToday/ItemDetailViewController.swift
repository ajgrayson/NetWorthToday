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
    @IBOutlet weak var valueTextField: UITextField!
    
    var item : Item!
    
    var itemType : ItemType!
    
    var selectedCategoryIndex : Int = 0
    
    //let currencyFormatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.categoryPicker.delegate = self;
        
        //self.valueTextField.addTarget(self, action: "amountTextFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        //currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        //currencyFormatter.currencyCode = NSLocale.currentLocale().displayNameForKey(NSLocaleCurrencySymbol, value: NSLocaleCurrencyCode)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(self.itemType! == ItemType.Asset) {
            self.navigationItem.title = item != nil ? "Edit Asset" : "Add Asset"
        } else {
            self.navigationItem.title = item != nil ? "Edit Liability" : "Add Liability"
        }
        
        if(self.item != nil) {
            self.nameTextField.text = self.item.name
            self.valueTextField.text = self.item.amount?.description
            
            var index = 0
            if(self.itemType! == ItemType.Asset) {
                index = AssetCategory.getIndexFor(self.item.category!)
            } else {
                index = LiabilityCategory.getIndexFor(self.item.category!)
            }
            
            self.categoryPicker.selectRow(index, inComponent: 0, animated: false)
            self.selectedCategoryIndex = index
        }
        
        self.nameTextField.becomeFirstResponder()
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
                self.item.type = "item"
                self.item.itemType = self.itemType.rawValue
            }
            
            // set the name
            self.item?.name = self.nameTextField.text
            self.item?.amount = (self.valueTextField.text as NSString).floatValue
            
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
    
    // MARK :- Text Fields
//    
//    func amountTextFieldDidChange(textField: UITextField) {
//        updateAmountTextField(self.valueTextField.text)
//    }
//    
//    func updateAmountTextField(amount : String?) {
//        if(amount == nil) {
//            return
//        }
//        
//        var text = self.cleanAmount(amount)
//        
//        self.valueTextField.text = currencyFormatter.stringFromNumber((text as NSString).doubleValue)
//    }
//    
//    func cleanAmount(text : String?) -> String {
//        if(text == nil) {
//            return ""
//        }
//        return text!.stringByReplacingOccurrencesOfString(currencyFormatter.currencySymbol!, withString: "").stringByReplacingOccurrencesOfString(currencyFormatter.groupingSeparator, withString: "").stringByReplacingOccurrencesOfString(currencyFormatter.decimalSeparator!, withString: "")
//    }
    
    // MARK : - App Delegate
    
    var appDelegate : AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }
    
}
