//
//  AllListsViewController.swift
//  Checklists
//
//  Created by xudong7930 on 26/02/2017.
//  Copyright © 2017 xudong7930. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController {
    
    var dataModel: DataModel!;
    
    // 视图确实出现
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        navigationController?.delegate = self;
        
        // 如果存在先前的，则跳转到先前的视图
        //let index = UserDefaults.standard.integer(forKey: "ChecklistIndex");
        let index = dataModel.indexOfSelectedChecklist;
       
        if index > -1 && index < dataModel.lists.count {
            let list = dataModel.lists[index];
            performSegue(withIdentifier: "ShowChecklist", sender: list);
        }
        
        
    }
    
    // 视图将会出现
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        tableView.reloadData();
    }
    
    
    // 有多少行
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count;
    }
    
    // 配置cell怎么显示
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = cellForTableView(tableView);
        
        let list = dataModel.lists[indexPath.row];
        cell.textLabel!.text = list.name;
        cell.accessoryType = .detailDisclosureButton;
        
        // 子标题
        let count = list.countUncheckedItems();
        var subTitle = "";
        if list.items.count == 0 {
            subTitle = "没有项目";
        } else if count < 1 {
            subTitle = "全部完成";
        } else {
            subTitle = "剩余\(count)项"
        }
        
        cell.detailTextLabel?.text = subTitle;
        
        // 图标
        cell.imageView!.image = UIImage(named: list.iconName);
        
        return cell;
    }
    
    // 选中cell后的操作
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 设置默认值
        //UserDefaults.standard.set(indexPath.row, forKey: "ChecklistIndex");
        dataModel.indexOfSelectedChecklist = indexPath.row;
        
        
        let list = dataModel.lists[indexPath.row];
        
        // 向segue="ShowChecklist"的桥传递数据list
        performSegue(withIdentifier: "ShowChecklist", sender: list);
    }
    
    // 编辑cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // 从数组中移除
        dataModel.lists.remove(at: indexPath.row);
        
        let indexPaths = [indexPath];
        
        tableView.deleteRows(at: indexPaths, with: .automatic);
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let nav = storyboard?.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController;
        
        let controller = nav.topViewController as! ListDetailViewController;
        
        controller.delegate = self;
        
        let list = dataModel.lists[indexPath.row];
        controller.listToEdit = list;
        
        // 显示controller页面
        present(nav, animated: true, completion: nil);
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 如果segue是“ShowChecklist”， 则赋值
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController;
            controller.list = sender as! Checklist;
        }
        
        if segue.identifier == "AddChecklist" {
            let nav = segue.destination as! UINavigationController
            let controller = nav.topViewController as! ListDetailViewController;
            controller.delegate = self;
            controller.listToEdit = nil;
        }
    }
    
    // 创建一个cell
    func cellForTableView(_ tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "TableCell";
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell;
        }
        
        return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier);
    
    }
}

// 成为代理
extension AllListViewController: ListViewControllerDelegate {
    
    // 取消
    func didCancel(controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil);
    }
    
    
    // 添加
    func didDone(controller: ListDetailViewController, finishAdd list: Checklist) {
        
        
        dataModel.lists.append(list);
        dataModel.sortCheckLists();
        tableView.reloadData();
        
        /*
        let newIndex = dataModel.lists.count;
        let indexPath = NSIndexPath(row: newIndex, section: 0);
        let indexPaths = [indexPath];
        
        tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic);
        */
        
        dismiss(animated: true, completion: nil);
    }
    
    // 编辑
    func didDone(controller: ListDetailViewController, finishEdit list: Checklist) {
        
        dataModel.sortCheckLists();
        tableView.reloadData();
        
        /*
        if let index = dataModel.lists.index(where: {return $0 == list}) {
            let indexPath = NSIndexPath(row: index, section: 0);
            
            if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
                cell.textLabel!.text = list.name;
            }
            
        }
        */
        
        dismiss(animated: true, completion: nil);
    }
    
}


extension AllListViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            //UserDefaults.standard.set(-1, forKey: "ChecklistIndex");
            dataModel.indexOfSelectedChecklist = -1;
        }
    }
    
    
}


