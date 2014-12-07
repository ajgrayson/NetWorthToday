//
//  ItemListTableViewController.swift
//  NetWorthToday
//
//  Created by Johnathan Grayson on 7/12/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import UIKit

@objc(ItemListTableViewController) class ItemListTableViewController: UITableViewController {

    var viewItemType : ItemType!
    
    var database: CBLDatabase!
    
    var dataSource: CBLUITableSource!
    
    var liveQuery: CBLLiveQuery!
    
    let assetViewName = "Assets"
    
    let liabilityViewName = "Liability"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if(self.viewItemType == ItemType.Asset) {
            self.navigationItem.title = "Assets"
        } else {
            self.navigationItem.title = "Liabilities"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setupDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.liveQuery.removeObserver(self, forKeyPath: "rows")
    }
    
    // MARK: - Navigation
    
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
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        var source: ItemDetailViewController = segue.sourceViewController as ItemDetailViewController
        
        if source.item != nil {
            var item: Item = source.item!
            
            // add it to the database
            self.saveItem(item)
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
        var cell : ItemListTableViewCell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as ItemListTableViewCell
        
        var row : CBLQueryRow = self.dataSource.rowAtIndexPath(indexPath)
        var doc : CBLDocument = row.document
        
        var item : Item = Item(forDocument: doc)
        
        cell.nameTextField!.text = item.name;
        cell.categoryTextField!.text = self.getCategoryDescription(item.category)
        cell.amountTextField!.text = item.amount?.description
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func getCategoryDescription(category: String?) -> String {
        if(self.viewItemType == ItemType.Asset) {
            var cat : (name: String, value: String)? = AssetCategory.getCategoryForValue(category)
            return cat != nil ? cat!.name : ""
        }
        
        var cat : (name: String, value: String)? = LiabilityCategory.getCategoryForValue(category)
        return cat != nil ? cat!.name : ""
    }
    
    // MARK: - DataSource

    func reloadData() {
        self.dataSource.reloadFromQuery()
        self.tableView.reloadData()
    }
    
    func setupDataSource() {
        
        setupDatabase()
        
        if self.dataSource == nil {
            self.dataSource = CBLUITableSource()
            
            self.liveQuery = database.viewNamed(getViewName()).createQuery().asLiveQuery();
            self.liveQuery.descending = false
            self.liveQuery.addObserver(self, forKeyPath: "rows", options: nil, context: nil)
            
            self.dataSource.query = self.liveQuery
        }
        
        self.reloadData()
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject,
        change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
            if object as? NSObject == liveQuery {
                self.tableView.reloadData()
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
        if(self.viewItemType == ItemType.Asset) {
            return assetViewName
        } else {
            return liabilityViewName
        }
    }
    
    func saveItem(item: Item!) {
        if(item == nil) {
            return
        }
        
        var error : NSError?
        item.save(&error)
        
        if(error != nil) {
            println("Error saving item: " + (error != nil ? error!.description : ""))
        }
        
        self.self.reloadData()
    }
    
    var appDelegate : AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }

}
