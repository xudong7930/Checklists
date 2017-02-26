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
    var iconName = "";
    var items = [ChecklistItem]();
    
    // 没有参数
    override init () {
        super.init();
    }
    
    // 1个参数
    init(name: String) {
        self.name = name;
        //self.iconName = "NoIcon";
        self.iconName = "NoIcon";
        
        super.init();
    }
    
    // 2个参数
    init(name: String, iconName: String) {
        self.name = name;
        self.iconName = iconName;
        
        super.init();
    }
    
    // 统计未完成的项目
    func countUncheckedItems() -> Int {
        var count = 0;
        
        for item in items {
            if !item.checked {
                count += 1;
            }
        }
        
        return count;
        
    }
    
    
    // 编码
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name");
        aCoder.encode(items, forKey: "items");
        aCoder.encode(iconName, forKey: "iconName");

    }
    
    // 解码
    required init?(coder aDecoder: NSCoder) {
        
        items = aDecoder.decodeObject(forKey: "items") as! [ChecklistItem];
        name = aDecoder.decodeObject(forKey: "name") as! String;
        iconName = aDecoder.decodeObject(forKey: "iconName") as! String;
        
        super.init();
    }

}
