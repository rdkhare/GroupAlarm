//
//  repeatVC.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 7/11/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit

class RepeatVC: UITableViewController {
    
    
    
    var lastSelection: NSIndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cells = repeatView.visibleCells 
        
        for cell in cells {
            
        }
        
        self.navigationItem.title = "Repeat"
    }
    
    @IBOutlet var repeatView: UITableView!
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }
    
    
    
}
