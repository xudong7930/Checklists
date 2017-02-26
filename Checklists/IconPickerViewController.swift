//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by xudong7930 on 26/02/2017.
//  Copyright © 2017 xudong7930. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
    func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String);
}

class IconPickerViewController: UITableViewController {
    
    // 默认代理
    weak var delegate: IconPickerViewControllerDelegate?;
    
    
    
    // 图标集合
    let icons = [
        "NoIcon",
        "Appointments",
        "Birthdays",
        "Chores",
        "Drinks",
        "Folder",
        "Groceries",
        "Inbox",
        "Photos",
        "Trips"
    ];
    
    // 有多少行
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count;
    }
    
    // 配置表格
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath);
        let iconName = icons[indexPath.row];
        cell.textLabel!.text = iconName;
        cell.imageView!.image = UIImage(named: iconName);
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate2 = delegate {
            let iconName = icons[indexPath.row];
            delegate2.iconPicker(picker: self, didPickIcon: iconName);
        }
    }
    
    
}
