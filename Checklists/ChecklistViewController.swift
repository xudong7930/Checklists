//
//  ViewController.swift
//  Checklists
//
//  Created by xudong7930 on 25/02/2017.
//  Copyright © 2017 xudong7930. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var items: [ChecklistItem]; //对象数组
    
    @IBAction func addItem() {
        let newRowIndex = items.count;
        
        let item = ChecklistItem();
        item.text = "我的新的行";
        item.checked = false;
        items.append(item);
        
        let indexPath = NSIndexPath(row: newRowIndex, section: 0);
        let indexPaths = [indexPath];
        
        tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem](); //对象数组初始化
        
        //往数组里面添加值
        let rowitem = ChecklistItem();
        rowitem.text = "遛狗";
        rowitem.checked = false;
        items.append(rowitem);
        
        let row1item = ChecklistItem();
        row1item.text = "遛狗1";
        row1item.checked = false;
        items.append(row1item);
        
        let row2item = ChecklistItem();
        row2item.text = "遛狗2";
        row2item.checked = false;
        items.append(row2item);
        
        super.init(coder: aDecoder);
    }
    
    
    // 表格有多少行
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    // 表格的行如何显示
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath);
        
        // indexPath.row当前行数
        let item = items[indexPath.row];
 
        
        configureTextForCell(cell, withChecklistItem: item)
        configureCheckmarkForCell(cell, withChecklistItem: item);
    
        return cell;
        
    }
    
    // 删除某行
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row);
        
        let indexPaths = [indexPath];
        
        tableView.deleteRows(at: indexPaths, with: .automatic);
    }
    
    
    // 选中某行的处理
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row];
            item.toggleChecked();
            
            configureCheckmarkForCell(cell, withChecklistItem: item);
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    // 自定义配置Checkmark
    func configureCheckmarkForCell(_ cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        
        if item.checked {
            cell.accessoryType = .checkmark;
        } else {
            cell.accessoryType = .none;
        }
    }
    
    
    // 自定义配置文本
    func configureTextForCell(_ cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel;
        label.text = item.text;
    }
    
    
    
}

