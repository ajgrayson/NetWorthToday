//
//  ItemListTableViewController.swift
//  NetWorthToday
//
//  Created by Johnathan Grayson on 7/12/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import UIKit

class ItemListTableViewController: UITableViewController {

    var viewItemType : ItemType!
    
    var database: CBLDatabase!
    
    var dataSource: CBLUITableSource!
    
    let assetViewName = "Assets"
    
    let liabilityViewName = "Liability"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(self.viewItemType == ItemType.Asset) {
            self.navigationItem.title = "Assets"
        } else {
            self.navigationItem.title = "Liabilities"
        }
        
        setupDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier != "editItem" && segue.identifier != "addItem") {
            return
        }
        
        var nvc : UINavigationController = segue.destinationViewController as UINavigationController
        var vc : ItemDetailViewController = nvc.topViewController as ItemDetailViewController
        
        vc.itemType = self.viewItemType
        
        if(segue.identifier == "editItem") {
            
            var indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            var row = self.dataSource.rowAtIndexPath(indexPath)
            
            var doc : CBLDocument = row.document
            
            vc.item = Item(forDocument: doc)
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.dataSource?.rows != nil) {
            return self.dataSource.rows.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as UITableViewCell
        
        var row : CBLQueryRow = self.dataSource.rowAtIndexPath(indexPath)
        var doc : CBLDocument = row.document
        
        var item : Item = Item(forDocument: doc)
        
        cell.textLabel!.text = item.name;
        
        return cell
    }

    func setupDataSource() {
        
        self.database = appDelegate.database
        
        setupDatabaseViews()
        
        if self.dataSource == nil {
            self.dataSource = CBLUITableSource()
            
            let query = database.viewNamed(getViewName()).createQuery().asLiveQuery();
            query.descending = true
            
            self.dataSource.query = query
            self.dataSource.labelProperty = "name"    // Document property to display in the cell label
        }
        
        self.dataSource.reloadFromQuery()
        
        self.tableView.reloadData()
    }
    
    func setupDatabaseViews() {
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
        if(self.viewItemType == ItemType.Asset) {
            return assetViewName
        } else {
            return liabilityViewName
        }
    }
    
    var appDelegate : AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }

}
