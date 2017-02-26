//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by xudong7930 on 26/02/2017.
//  Copyright © 2017 xudong7930. All rights reserved.
//

import UIKit


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
    
    @IBOutlet weak var textField: UITextField!;
    @IBOutlet weak var doneBarButton: UIBarButtonItem!;
    
    
    // 取消
    @IBAction func cancel() {
        delegate?.didCancel(controller: self);
    }
    
    // 完成
    @IBAction func done() {
        
        if let item = itemToEdit {
            item.text = textField.text!;
            delegate?.didDone(controller: self, finishEditItem: item)
        } else {
        
            let item = ChecklistItem();
            item.text = textField.text!;
            item.checked = false;
            
            delegate?.didDone(controller: self, finishAddItem: item);
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        print("viewDidLoad");
        if let item = itemToEdit {
            title = "编辑条目"; //设置导航栏的title
            doneBarButton.isEnabled = true;
            textField.text = item.text; //设置input的内容
        }
    }
    
    // View将会出现
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        print("viewWillAppear");
        textField.becomeFirstResponder();
    }
    
    //将会选择一行的处理
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil;
    }
    
}

extension ItemDetailViewController: UITextFieldDelegate {
    
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


