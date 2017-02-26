//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by xudong7930 on 26/02/2017.
//  Copyright © 2017 xudong7930. All rights reserved.
//

import UIKit

protocol ListViewControllerDelegate: class {
    // 取消
    func didCancel(controller: ListDetailViewController);
    
    // 添加
    func didDone(controller: ListDetailViewController, finishAdd list: Checklist);
    
    // 编辑
    func didDone(controller: ListDetailViewController, finishEdit list: Checklist);
    
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
    
    var listToEdit: Checklist?;
    var choosedIcon = "Folder";
    
    // 代理
    weak var delegate: ListViewControllerDelegate?;
    
    @IBOutlet weak var listName: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!;
    @IBOutlet weak var iconImage: UIImageView!;
    
    
    @IBAction func cancel() {
        delegate?.didCancel(controller: self);
    }
    
    @IBAction func done() {
        
        if let list = listToEdit { //编辑
            list.name = listName.text!;
            list.iconName = choosedIcon;
            delegate?.didDone(controller: self, finishEdit: list);
        
        } else { //添加
            /*
            let list = Checklist();
            list.name = listName.text!;
            list.iconName = choosedIcon;
            */
            
            let list = Checklist(name: listName.text!, iconName: choosedIcon);
            delegate?.didDone(controller: self, finishAdd: list);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        if let list = listToEdit {
            title = "编辑List";
            listName.text = list.name;
            doneBarButton.isEnabled = true;
            choosedIcon = list.iconName;
        }
        
        iconImage.image = UIImage(named: choosedIcon);
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        listName.becomeFirstResponder();
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder);
    }
    
    
    // textField的代理方法
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldString: NSString = textField.text! as NSString;
        let newString: NSString = oldString.replacingCharacters(in: range, with: string) as NSString;
        
        doneBarButton.isEnabled = (newString.length > 0);
        
        
        return true;
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.section == 1 {
            return indexPath;
        }
        
        return nil;
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickIcon" {
            let controller = segue.destination as! IconPickerViewController;
            controller.delegate = self;
        }
    }
    
    
}

extension ListDetailViewController: IconPickerViewControllerDelegate {
    func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String) {
        
        self.choosedIcon = iconName;
        iconImage.image = UIImage(named: self.choosedIcon);
        
        navigationController?.popViewController(animated: true);
    
        
        
    }
}
