//
//  ItemGroupTableViewViewControllerTableViewController.swift
//  NetWorthToday
//
//  Created by Johnathan Grayson on 6/12/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import UIKit

class ItemCategoryTableViewController: UITableViewController {

    var itemType : ItemType!
    
    var database: CBLDatabase!
    
    var liveQuery: CBLLiveQuery!
    
    let assetViewName = "Assets"
    
    let liabilityViewName = "Liability"
    
    let currencyFormatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if(self.itemType! == ItemType.Asset) {
            return AssetCategory.getAll().count
        }
        return LiabilityCategory.getAll().count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemGroupCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        
        let val = self.data?[indexPath.item]
        
        let valText = currencyFormatter.stringFromNumber(val != nil ? val! : 0)
        
        if(self.itemType! == ItemType.Asset) {
            cell.textLabel?.text = AssetCategory.getAll()[indexPath.item].name + " " + (valText != nil ? valText! : "")
        } else {
            cell.textLabel?.text = LiabilityCategory.getAll()[indexPath.item].name + " " + (valText != nil ? valText! : "")
        }
        
        return cell
    }
    
    // MARK : - Data Source
    
    func setupDataSource() {
        
        setupDatabase()
        
        self.liveQuery = database.viewNamed(getViewName()).createQuery().asLiveQuery();
        self.liveQuery.descending = false
        self.liveQuery.addObserver(self, forKeyPath: "rows", options: nil, context: nil)
        
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject,
        change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
            if object as? NSObject == liveQuery {
                self.updateData(liveQuery.rows)
            }
    }
    
    func setupDatabase() {
        self.database = appDelegate.database
        
        self.database.viewNamed(assetViewName).setMapBlock({
            (doc, emit) in
            
            let type : String? = doc["type"] as String?
            if (type == "item") {
                
                let itemType : String? = doc["itemType"] as String?
                if (ItemType(rawValue: itemType!) == ItemType.Asset) {
                    
                    if let nameObj: AnyObject = doc["name"] {
                        
                        if let name = nameObj as? String {
                            emit(name, doc)
                        }
                        
                    }
                    
                }
                
            }
            
            }, version: "2")
        
        self.database.viewNamed(liabilityViewName).setMapBlock({
            (doc, emit) in
            
            let type : String? = doc["type"] as String?
            if (type == "item") {
                
                let itemType : String? = doc["itemType"] as String?
                if (ItemType(rawValue: itemType!) == ItemType.Liability) {
                    
                    if let nameObj: AnyObject = doc["name"] {
                        
                        if let name = nameObj as? String {
                            emit(name, doc)
                        }
                        
                    }
                    
                }
                
            }
            
            }, version: "2")
    }
    
    func getViewName() -> String {
        if(self.itemType == ItemType.Asset) {
            return assetViewName
        } else {
            return liabilityViewName
        }
    }
    
    var data : [Int]?
    
    func updateData(rows : CBLQueryEnumerator) {
        self.initData()
        
        if(rows.count > 0) {
            for i in 0...rows.count-1 {
                var row = rows.rowAtIndex(i)
                
                var doc : CBLDocument = row.document
                
                var item : Item = Item(forDocument: doc)
                
                var val : Int = (item.amount != nil ? item.amount! : 0).integerValue
                
                self.updateDataValue(item.category, value: val)

            }
        }
        
        self.tableView.reloadData()
    }
    
    func updateDataValue(type : String?, value : Int) {
        if(type == nil) {
            return
        }
        
        if(self.itemType == ItemType.Asset) {
            let index = AssetCategory.getIndexFor(type!)
            let val = self.data?[index]
            
            self.data?[index] = (val != nil ? val! : 0) + value
        } else {
            let index = LiabilityCategory.getIndexFor(type!)
            let val = self.data?[index]
            
            self.data?[index] = (val != nil ? val! : 0) + value
        }
    }
    
    func initData() {
        data = [Int]()
        
        if(self.itemType == ItemType.Asset) {
            for t in AssetCategory.getAll() {
                data?.append(0)
            }
        } else {
            for t in LiabilityCategory.getAll() {
                data?.append(0)
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    var appDelegate : AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }

}
