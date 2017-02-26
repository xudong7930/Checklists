//
//  ChecklistItem.swift
//  Checklists
//
//  Created by xudong7930 on 25/02/2017.
//  Copyright © 2017 xudong7930. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
    
    var text = "";
    var checked = false;
    
    func toggleChecked()
    {
        checked = !checked;
    }

}
