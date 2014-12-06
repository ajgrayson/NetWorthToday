//
//  ViewController.swift
//  NetWorthToday
//
//  Created by Johnathan Grayson on 2/12/14.
//  Copyright (c) 2014 Johnathan Grayson. All rights reserved.
//

import UIKit

class MemberOverviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
            lvc.itemType = ItemType.Asset
        } else {
            lvc.itemType = ItemType.Liability
        }
    }

}

