//
//  ViewController.swift
//  NetWorthToday
//
//  Created by Johnathan Grayson on 2/12/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import UIKit

class MemberOverviewViewController: UIViewController {

    var database : CBLDatabase!
    
    var liveQuery : CBLLiveQuery!
    
    let currencyFormatter = NSNumberFormatter()
    
    @IBOutlet weak var totalTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        var avc : ItemCategoryTableViewController = self.childViewControllers[0] as ItemCategoryTableViewController
        avc.itemType = ItemType.Asset
        
        var lvc : ItemCategoryTableViewController = self.childViewControllers[1] as ItemCategoryTableViewController
        lvc.itemType = ItemType.Liability
        
        currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        currencyFormatter.maximumFractionDigits = 0
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setupDataSource()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.liveQuery.removeObserver(self, forKeyPath: "rows")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier != "manageAssets" && segue.identifier != "manageLiabilities"){
            return
        }
        
        var nvc : UINavigationController = segue.destinationViewController as UINavigationController
        var lvc : ItemListTableViewController = nvc.topViewController as ItemListTableViewController
        
        if(segue.identifier == "manageAssets") {
            lvc.viewItemType = ItemType.Asset
        } else {
            lvc.viewItemType = ItemType.Liability
        }
    }
    
    // MARK : - DataSource
    
    func setupDataSource() {
        
        setupDatabase()
        
        self.liveQuery = database.viewNamed("items").createQuery().asLiveQuery();
        self.liveQuery.descending = false
        self.liveQuery.addObserver(self, forKeyPath: "rows", options: nil, context: nil)
        
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject,
        change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
            if object as? NSObject == liveQuery {
                self.displayData(liveQuery.rows)
            }
    }
    
    func setupDatabase() {
        self.database = appDelegate.database
        
        self.database.viewNamed("items").setMapBlock({
            (doc, emit) in
            
                let type : String? = doc["type"] as String?
                if (type == "item") {
                    
                    if let nameObj: AnyObject = doc["name"] {
                        
                        if let name = nameObj as? String {
                            emit(name, doc)
                        }
                        
                    }
                    
                }
            
            }, version: "2")
    }
    
    func displayData(rows : CBLQueryEnumerator) {
        var total = 0
        
        if(rows.count > 0) {
            for i in 0...rows.count-1 {
                var row = rows.rowAtIndex(i)
                
                var doc : CBLDocument = row.document
                
                var item : Item = Item(forDocument: doc)
                
                if(ItemType(rawValue: item.itemType!) == ItemType.Asset) {
                    total = total + (item.amount != nil ? item.amount! : 0).integerValue
                } else {
                    total = total - (item.amount != nil ? item.amount! : 0).integerValue
                }

            }
        }
        
        self.totalTextField.text = currencyFormatter.stringFromNumber(total)
    }
    
    var appDelegate : AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }

}

