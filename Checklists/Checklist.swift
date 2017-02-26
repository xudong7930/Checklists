//
//  Checklist.swift
//  Checklists
//
//  Created by xudong7930 on 26/02/2017.
//  Copyright © 2017 xudong7930. All rights reserved.
//

import Foundation

class Checklist: NSObject, NSCoding {
    
    var name = "";
    var items = [ChecklistItem]();
    
    override init () {
        super.init();
    }
    
    
    init(name: String) {
        self.name = name;
        
        super.init();
    }
    
    // 编码
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name");
        aCoder.encode(items, forKey: "items");
    }
    
    // 解码
    required init?(coder aDecoder: NSCoder) {
        
        items = aDecoder.decodeObject(forKey: "items") as! [ChecklistItem];
        name = aDecoder.decodeObject(forKey: "name") as! String;
        
        super.init();
    }

}
