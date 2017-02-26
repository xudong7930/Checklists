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
    
    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem](); //对象数组初始化
        
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
        
        let label_1002 = cell.viewWithTag(1002) as! UILabel;
        
        label_1002.text = (item.checked) ? "√" : "";
    }
    
    
    // 自定义配置文本
    func configureTextForCell(_ cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel;
        label.text = item.text;
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 找到指定的segue
        if segue.identifier == "AddItem" {
            // 找到ItemDetailViewController
            let nav = segue.destination as! UINavigationController;
            let controller = nav.topViewController as! ItemDetailViewController;
            
            //找到delegate并赋值
            controller.delegate = self;
        }
        
        
        if segue.identifier == "EditItem" {
            let nav = segue.destination as! UINavigationController;
            let controller = nav.topViewController as! ItemDetailViewController;
            
            controller.delegate = self;
            
            // 找到点击了哪个Cell
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row];
            }
            
        }
    }
}


// 成为ItemDetailViewController的代理
extension ChecklistViewController: ItemDetailViewControllerDelegate {
    
    // 取消
    func didCancel(controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil);
    }
    
    // 添加
    func didDone(controller: ItemDetailViewController, finishAddItem item: ChecklistItem) {
        
        
        let newIndex = items.count;
        
        items.append(item);
        
        let indexPath = NSIndexPath(row: newIndex, section: 0);
        let indexPaths = [indexPath];
        tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic);
    
        
        
        dismiss(animated: true, completion: nil);
    }
    
    
    // 编辑
    func didDone(controller: ItemDetailViewController, finishEditItem item: ChecklistItem) {

        if let index = items.index(where: {$0 === item}) {
            print(22222);
            let indexPath = NSIndexPath(row: index, section: 0);
            
            if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
                configureTextForCell(cell, withChecklistItem: item);
            }
        }

        dismiss(animated: true, completion: nil);
    }
    
}
