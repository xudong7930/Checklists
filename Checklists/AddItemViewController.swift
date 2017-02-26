//
//  AddItemViewController.swift
//  Checklists
//
//  Created by xudong7930 on 26/02/2017.
//  Copyright © 2017 xudong7930. All rights reserved.
//

import UIKit


protocol AddItemViewControllerDelegate: class {
    func didCancel(controller: AddItemViewController);
    func didDone(controller: AddItemViewController, finishAddItem item: ChecklistItem);
    
}


class AddItemViewController: UITableViewController {
    
    weak var delegate: AddItemViewControllerDelegate?;
    
    @IBOutlet weak var textField: UITextField!;
    @IBOutlet weak var doneBarButton: UIBarButtonItem!;
    
    
    // 取消
    @IBAction func cancel() {
        delegate?.didCancel(controller: self);
        dismiss(animated: true, completion: nil);
    }
    
    // 完成
    @IBAction func done() {
        let item = ChecklistItem();
        item.text = textField.text!;
        item.checked = false;
        
        delegate?.didDone(controller: self, finishAddItem: item);
        dismiss(animated: true, completion: nil);
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        textField.becomeFirstResponder();
    }
    
    //将会选择一行的处理
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil;
    }
    
}

extension AddItemViewController: UITextFieldDelegate {
    
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


