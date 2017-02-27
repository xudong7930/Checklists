//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by xudong7930 on 26/02/2017.
//  Copyright © 2017 xudong7930. All rights reserved.
//

import UIKit
import UserNotifications

protocol ItemDetailViewControllerDelegate: class {
    // 取消
    func didCancel(controller: ItemDetailViewController);
    
    // 添加
    func didDone(controller: ItemDetailViewController, finishAddItem item: ChecklistItem);
    
    // 编辑
    func didDone(controller: ItemDetailViewController, finishEditItem item: ChecklistItem);
    
}


class ItemDetailViewController: UITableViewController {
    
    weak var delegate: ItemDetailViewControllerDelegate?;
    
    // 待编辑的item
    var itemToEdit: ChecklistItem?;
    var due = Date();
    var datePickerVisible = false; //显示日期选择器?
    
    @IBOutlet weak var textField: UITextField!;
    @IBOutlet weak var doneBarButton: UIBarButtonItem!;
    @IBOutlet weak var remind: UISwitch!;
    @IBOutlet weak var dueDate: UILabel!;
    
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // 取消
    @IBAction func cancel() {
        delegate?.didCancel(controller: self);
    }
    
    // 完成
    @IBAction func done() {
        
        if let item = itemToEdit {
            item.text = textField.text!;
            item.remind = remind.isOn;
            item.dueDate = due;
            item.scheduleNotification();
            delegate?.didDone(controller: self, finishEditItem: item)
        } else {
        
            let item = ChecklistItem();
            item.text = textField.text!;
            item.checked = false;
            item.remind = remind.isOn;
            item.dueDate = due;
            item.scheduleNotification();
            
            delegate?.didDone(controller: self, finishAddItem: item);
        }

    }
    
    @IBAction func dateChanged(datePicker: UIDatePicker) {
        due = datePicker.date;
        updateDueLabel();
    }
    
    @IBAction func remindToggle(_ switchcontrol: UISwitch) {
        
        textField.resignFirstResponder();
        
        if (switchcontrol.isOn) {
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {
                (grant, error) in
                if error != nil {
                    print(error!);
                }
            });
            
        }
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        print("viewDidLoad");
        if let item = itemToEdit {
            title = "编辑条目"; //设置导航栏的title
            doneBarButton.isEnabled = true;
            textField.text = item.text; //设置input的内容
            remind.isOn = item.remind;
            due = item.dueDate;
        }
        
        updateDueLabel();
    }
    
    // View将会出现
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        print("viewWillAppear");
        textField.becomeFirstResponder();
    }
    
    //将会选择一行的处理
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath;
        } else {
            return nil;
        }
    }
    
    // 配置高度显示
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217;
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath);
        }
    }
    
    override func tableView(_ tableView: UITableView,indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var indexPath2 = indexPath;
        if indexPath.section == 1 && indexPath.row == 2 {
            indexPath2 = NSIndexPath(row: 0, section: indexPath.section) as IndexPath;
        }
        
        return super.tableView(tableView, indentationLevelForRowAt: indexPath2);
    }
    
    // 选中了某行
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true);
        
        textField.resignFirstResponder();
        
        if indexPath.section == 1 && indexPath.row == 1 {
            if datePickerVisible {
                hideDatePicker();
            } else {
                showDatePicker();
            }
        }
    }

    
    // 显示多少行
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3;
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section);
        }
    }
    
    // 配置table显示
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell;
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath);
        }
    }
    
    // 更新日期标签
    func updateDueLabel() {
        let formatter = DateFormatter();
        formatter.dateStyle = .medium;
        formatter.timeStyle = .short;
        dueDate.text = formatter.string(from: due);
    }
    
    // 隐藏日期选择器
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false;
            
            let dateRow = NSIndexPath(row: 1, section: 1) as IndexPath;
            let datePicker = NSIndexPath(row: 2, section: 1) as IndexPath;
            
            if let cell = tableView.cellForRow(at: dateRow) {
                let label_1003 = cell.viewWithTag(1003) as! UILabel;
                label_1003.textColor = UIColor(white: 0, alpha: 0.5);
            }
            
            tableView.beginUpdates();
            tableView.reloadRows(at: [dateRow], with: .none);
            tableView.deleteRows(at: [datePicker], with: .fade);
            tableView.endUpdates();
        }
    }
    
    // 显示日期选择器
    func showDatePicker() {
        datePickerVisible = true;
        
        let indexPath = NSIndexPath(row: 1, section: 1) as IndexPath;
        
        let indexPathDatePicker = NSIndexPath(row: 2, section: 1) as IndexPath;
        
        if let dateCell = tableView.cellForRow(at: indexPath) {
            let label = dateCell.viewWithTag(1003) as! UILabel;
            label.textColor = view.tintColor;
        }
        
        
        tableView.beginUpdates();
        
        tableView.insertRows(at: [indexPathDatePicker], with: .fade);
        tableView.reloadRows(at: [indexPath], with: .none);
        
        tableView.endUpdates();
    
        
        datePicker.setDate(due, animated: false);
    }
    
}

extension ItemDetailViewController: UITextFieldDelegate {
    
    // 开始编辑input的时候，隐藏datePicker
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker();
    }
    
    // input表单字段内容发生变化的触发函数
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 旧的内容
        let oldString: NSString = textField.text! as NSString;
        
        // 新的内容
        let newString: NSString = oldString.replacingCharacters(in: range, with: string) as NSString;
        
        doneBarButton.isEnabled = (newString.length > 0);
        
        return true;
    }
}


