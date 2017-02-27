//
//  ChecklistItem.swift
//  Checklists
//
//  Created by xudong7930 on 25/02/2017.
//  Copyright © 2017 xudong7930. All rights reserved.
//

import Foundation
import UserNotifications


class ChecklistItem: NSObject, NSCoding {
    
    var text = ""; //条目名称
    var checked = false; //是否完成
    var remind = false; //是否提醒
    var dueDate = Date(); //提醒日期
    var itemID: Int; //条目ID
    
    
    func notifyForThisItem() {
    
    }
    
    func scheduleNotification() {
        
        // 移除已经存在的.
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["checklist_notify_\(itemID)"])
        
        if remind && dueDate.compare(Date()) != .orderedAscending {
        
            let center = UNUserNotificationCenter.current();
            center.requestAuthorization(options: [.alert, .sound], completionHandler: {
                (grant, error) in
                if error == nil {
                    print("request authorisation ok");
                }
            });
            
            
            // 推送的内容
            let notifyContent = UNMutableNotificationContent();
            notifyContent.title = "新的提醒:";
            notifyContent.body = text;
            notifyContent.badge = 1;
            
            // 推送的标识器
            let notifyIdentify = "checklist_notify_\(itemID)";
            
            // 触发
            let interval = dueDate.timeIntervalSinceNow
            print("间隔时间是: \(interval); 日期是: \(dueDate)");
            let notifyTrigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false);
            
            // 请求
            let notifyRequest = UNNotificationRequest.init(identifier: notifyIdentify, content: notifyContent, trigger: notifyTrigger);
            
            //注册request
            center.add(notifyRequest, withCompletionHandler: {
                (error) in
                if error == nil {
                    print("添加了一个提醒");
                }
            })
            
            
        }
    }
    
    
    func toggleChecked()
    {
        checked = !checked;
    }
    
    override init() {
        self.itemID = DataModel.nextChecklistItemID();
        super.init();
    }
    
    // 编码
    func encode(with aCoder: NSCoder) {
        aCoder.encode(checked, forKey: "checked");
        aCoder.encode(remind, forKey: "remind");
        aCoder.encode(text, forKey: "text");
        aCoder.encode(itemID, forKey: "itemID");
        aCoder.encode(dueDate, forKey: "dueDate");
        
    }
    
    // 解码
    required init?(coder aDecoder: NSCoder) {
        
        checked = aDecoder.decodeBool(forKey: "checked");
        text = aDecoder.decodeObject(forKey: "text") as! String;
        remind = aDecoder.decodeBool(forKey: "remind");
        itemID = Int(aDecoder.decodeCInt(forKey: "itemID"));
        dueDate = aDecoder.decodeObject(forKey: "dueDate") as! Date;
        super.init();
    }
}

