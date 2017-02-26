//
//  Checklist.swift
//  Checklists
//
//  Created by xudong7930 on 26/02/2017.
//  Copyright © 2017 xudong7930. All rights reserved.
//

import Foundation

class Checklist: NSObject {
    
    var name = "";
    
    override init () {
        super.init();
    }
    
    
    init(name: String) {
        self.name = name;
        
        super.init();
    }

}
