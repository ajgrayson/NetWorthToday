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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.itemType! == ItemType.Asset) {
            return AssetCategory.getAll().count
        }
        return LiabilityCategory.getAll().count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemGroupCell", forIndexPath: indexPath) as UITableViewCell

        let val = self.data?[indexPath.item]
        
        if(self.itemType! == ItemType.Asset) {
            cell.textLabel?.text = AssetCategory.getAll()[indexPath.item].name + " " + Formatting.formatMoney(val)
        } else {
            cell.textLabel?.text = LiabilityCategory.getAll()[indexPath.item].name + " " + Formatting.formatMoney(val)
        }
        
        return cell
    }
    
    // MARK : - Data Source
    
    func setupDataSource() {
        self.database = appDelegate.database
        
        DatabaseViews.createAssetsAndLiabilityViews(self.database)
        
        self.liveQuery = database.viewNamed(DatabaseViews.getViewNameForItemType(self.itemType)).createQuery().asLiveQuery();
        self.liveQuery.descending = false
        self.liveQuery.addObserver(self, forKeyPath: "rows", options: nil, context: nil)
        
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject,
        change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
            if object as? NSObject == liveQuery {
                self.updateData(liveQuery.rows)
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
    
    var appDelegate : AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }

}
