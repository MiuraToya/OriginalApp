//
//  InputViewController.swift
//  OriginalTask
//
//  Created by 三浦　登哉 on 2020/10/22.
//  Copyright © 2020 toya.miura. All rights reserved.
//

import UIKit
import RealmSwift

class InputViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var progressPicker: UIPickerView!
    @IBOutlet weak var progressTextLabel: UILabel!
    
    
    
    let realm = try! Realm()
    var task: Task?
    let list: [String] = ["未完了","完了"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task?.title
        contentsTextView.text = task?.contents
        datePicker.date = task?.date as! Date
        progressTextLabel.text = "未完了"
        
        progressPicker.delegate = self
        progressPicker.dataSource = self
        
        contentsTextView.layer.borderColor = UIColor.gray.cgColor
        contentsTextView.layer.borderWidth = 1.0
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        try! realm.write{
            
            self.task?.title = titleTextField.text!
            self.task?.contents = contentsTextView.text!
            self.task?.date = datePicker.date
            self.task?.progress = progressTextLabel.text!
            self.realm.add(self.task!, update: .modified)
        }
        super.viewWillAppear(animated)
    }
    func numberOfComponents(in progressPicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ progressPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ progressPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    func pickerView(_ progressPicker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        progressTextLabel.text = list[row]
    }
    
    @objc func dismissKeyboard(){
        
        view.endEditing(true)
    }
}
