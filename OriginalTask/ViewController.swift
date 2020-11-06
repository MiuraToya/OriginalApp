//
//  ViewController.swift
//  OriginalTask
//
//  Created by 三浦　登哉 on 2020/10/22.
//  Copyright © 2020 toya.miura. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var SegmentController: UISegmentedControl!
    
    
    
    let realm = try! Realm()
    
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        
        
        
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         if SegmentController.selectedSegmentIndex == 1{
               // 未達成
                   let title1:String = SegmentController.titleForSegment(at: 1)!
               // progressが未達成
                   let predicate0 = NSPredicate(format: "progress == %@", title1 )
              // タイトルが検索窓の文字を含むかつprogressが未達成
                   let predicate1 = NSPredicate(format: "title CONTAINS %@ AND progress == %@", searchBar.text!, "未完了")
                // 検索窓が空欄のとき
                   if searchBar.text == ""{
                 // progressが未達成のものだけ表示
                    self.taskArray = try! Realm().objects(Task.self).filter(predicate0)
                   tableView.reloadData()
                   } else{
                      // タイトルが検索窓の文字を含むかつprogressが未達成のものを表示
                    self.taskArray = try! Realm().objects(Task.self).filter(predicate1)
                   tableView.reloadData()
                   }
              
               } else if SegmentController.selectedSegmentIndex == 2{
                  
                   let title2:String = SegmentController.titleForSegment(at: 2)!
                   let predicate2 = NSPredicate(format: "progress == %@", title2 )
                   let predicate3 = NSPredicate(format: "title CONTAINS %@ AND progress = %@", searchBar.text!, title2)
                  
            if searchBar.text == ""{
                   self.taskArray = try! Realm().objects(Task.self).filter(predicate2)
                   tableView.reloadData()
                   } else{
                       self.taskArray = try! Realm().objects(Task.self).filter(predicate3)
                       tableView.reloadData()
                   }
             
               } else {
                   
                   let predicate4 = NSPredicate(format: "title CONTAINS %@",searchBar.text!)
                   if searchBar.text == ""{
                       self.taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date")
                    tableView.reloadData()
                   } else{
                   self.taskArray = try! Realm().objects(Task.self).filter(predicate4)
                          
                          tableView.reloadData()
                   }
               }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
        
        tableView.reloadData()
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let taskcounter = taskArray.count
        return taskcounter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for:indexPath)
        let task = taskArray[indexPath.row]
        let label = UILabel(frame: CGRect(x: 320, y: 5, width: 100, height: 40))
        cell.contentView.addSubview(label)
      
        cell.textLabel?.text = "\(task.title)"
        
        
           let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        cell.detailTextLabel?.text = "\(task.progress)　\(dateString)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            try! realm.write{
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputViewController:InputViewController = segue.destination as!
        InputViewController
        
        // 遷移先に「選択されたセルのデータ」を代入する
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            let task = Task()
            
            let allTasks = realm.objects(Task.self)
            
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
            inputViewController.task = task
        }
    }
    
    
    @IBAction func segmentSelect(_ sender: UISegmentedControl) {
        
        if SegmentController.selectedSegmentIndex == 1{ 
        
            let title1:String = SegmentController.titleForSegment(at: 1)!
          
            let predicate0 = NSPredicate(format: "progress == %@", title1 )
           
            let predicate1 = NSPredicate(format: "title CONTAINS %@ AND progress == %@", searchBar.text!, title1)
            
            if searchBar.text == ""{
            self.taskArray = try! Realm().objects(Task.self).filter(predicate0)
            tableView.reloadData()
            } else{
                self.taskArray = try! Realm().objects(Task.self).filter(predicate1)
            tableView.reloadData()
            }
       
        } else if SegmentController.selectedSegmentIndex == 2{
           
            let title2:String = SegmentController.titleForSegment(at: 2)!
            let predicate2 = NSPredicate(format: "progress == %@", title2 )
            let predicate3 = NSPredicate(format: "title CONTAINS %@ AND progress == %@", searchBar.text!, title2)
            
            if searchBar.text == ""{
            self.taskArray = try! Realm().objects(Task.self).filter(predicate2)
            tableView.reloadData()
         } else{
                print("条件")
                self.taskArray = try! Realm().objects(Task.self).filter(predicate3)
                tableView.reloadData()
            }
      
        } else{
            
            let predicate4 = NSPredicate(format: "title CONTAINS %@",searchBar.text!)
            if searchBar.text == ""{
                self.taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date")
                 tableView.reloadData()
            } else{
            self.taskArray = try! Realm().objects(Task.self).filter(predicate4)
                   
                   tableView.reloadData()
            }
        }
    }
    
    
    
    // 遷移先から戻ってきた時、データを更新
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}
