//
//  ChecklistItem.swift
//  Checklists
//
//  Created by xudong7930 on 25/02/2017.
//  Copyright © 2017 xudong7930. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    
    var text = "";
    var checked = false;
    
    func toggleChecked()
    {
        checked = !checked;
    }
    
    
    override init() {
        super.init();
    }
    
    // 编码
    func encode(with aCoder: NSCoder) {
        aCoder.encode(checked, forKey: "checked");
        aCoder.encode(text, forKey: "text");
    }
    
    // 解码
    required init?(coder aDecoder: NSCoder) {
        
        checked = aDecoder.decodeBool(forKey: "checked");
        text = aDecoder.decodeObject(forKey: "text") as! String;
        
        super.init();
    }
}

