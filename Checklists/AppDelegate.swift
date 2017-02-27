//
//  AppDelegate.swift
//  Checklists
//
//  Created by xudong7930 on 25/02/2017.
//  Copyright © 2017 xudong7930. All rights reserved.
//

import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let dataModel = DataModel();

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 应用启动的时候赋值
        let nav = window!.rootViewController as! UINavigationController;
        let controller = nav.viewControllers[0] as! AllListViewController;
        controller.dataModel = dataModel;
        
        /*
        // 本地通知设置
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
        notifyContent.body = "1231312312312312";
        notifyContent.badge = 1;
        
        // 推送的标识器
        let notifyIdentify = "checklist_notify)";
        
        // 触发
        let interval = 10.211201020123;
        print("间隔时间是: \(interval); \(TimeInterval(interval))");
        
        let notifyTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval), repeats: false);
        
        // 请求
        let notifyRequest = UNNotificationRequest.init(identifier: notifyIdentify, content: notifyContent, trigger: notifyTrigger);
        
        //注册request
        center.add(notifyRequest, withCompletionHandler: {
            (error) in
            if error == nil {
                print("添加了一个提醒");
            }
        })
        */
    
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        dataModel.saveChecklist();
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        dataModel.saveChecklist();
    }

    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    
}

