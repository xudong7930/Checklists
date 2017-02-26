//
//  DataModel.swift
//  Checklists
//
//  Created by xudong7930 on 26/02/2017.
//  Copyright © 2017 xudong7930. All rights reserved.
//

import Foundation

class DataModel {
    
    var lists = [Checklist]();
    
    let saveKey = "ChecklistIndex";
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: saveKey);
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: saveKey)
            UserDefaults.standard.synchronize(); //同步
        }
    }
    
    init() {
        loadChecklist(); //加载文件
        registerDefaults(); //注册默认
        handleFirstTime(); //处理的第一次
    }
    
    
    // 排序
    func sortCheckLists() {
        lists.sort(by: {
            (list1, list2) in
            return list1.name.localizedCompare(list2.name) == .orderedAscending;
        })
    }
    
    
    // 注册默认值
    func registerDefaults() {
        let dic: [String: Any] = [saveKey: -1, "firstTime": true];
        
        
        
        UserDefaults.standard.register(defaults: dic);
    }
    
    func handleFirstTime() {

        let firstTime = UserDefaults.standard.bool(forKey: "firstTime")
        if  firstTime {
            let list = Checklist(name: "List");
            lists.append(list);
            
            indexOfSelectedChecklist = 0;
            
            UserDefaults.standard.set(false, forKey: "firstTime");
            UserDefaults.standard.synchronize();
            
        }
        
    }
    
    // 沙盒目录
    func documentDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        //["/Users/xudong7930/Library/Developer/CoreSimulator/Devices/56E11DCF-07C7-48C6-8E09-DAB71AF9C554/data/Containers/Data/Application/BC5C0EDD-B732-483A-8D8A-048B4677E5FC/Documents"]
        return paths[0];
    }
    
    // 文件路径
    func dataFilePath() -> String {
        return "\(documentDirectory())/Checklists.plist";
    }
    
    // 保存items到文件里面
    func saveChecklist() {
        //构建可修改的数据
        let data = NSMutableData();
        
        //将数据编码加密
        let archiver = NSKeyedArchiver(forWritingWith: data);
        archiver.encode(lists, forKey: saveKey);
        archiver.finishEncoding();
        
        //写入磁盘文件
        data.write(toFile: dataFilePath(), atomically: true);
    }
    
    
    // 从文件中读取items
    func loadChecklist() {
        let file = dataFilePath();
        
        // 判断文件是否存在
        if FileManager.default.fileExists(atPath: file) {
            
            // 文件存在则读取文件内容
            if let data = NSData(contentsOfFile: file) {
                
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data);
                lists = unarchiver.decodeObject(forKey: saveKey) as! [Checklist]
                unarchiver.finishDecoding();
                
                sortCheckLists();
            }
        }
    }
    
}

