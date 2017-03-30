//
//  ViewController.swift
//  sampleCoreData002
//
//  Created by Eriko Ichinohe on 2017/03/30.
//  Copyright © 2017年 Eriko Ichinohe. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var txtTitle: UITextField!
    
    @IBOutlet weak var todoListTableView: UITableView!
    
    var todoList = NSMutableArray()
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //CoreDataからdataを読み込む処理
        read()
    }
    
    //既に存在するデータの読み込み処理
    func read(){
        
        //配列初期化
        todoList = NSMutableArray()
        
        //AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        //どのエンティティからdataを取得してくるか設定
        let query:NSFetchRequest<Todo> = Todo.fetchRequest()
        
        do {
            //データを一括取得
            let fetchResults = try viewContext.fetch(query)
            
            //データの取得
            for result: AnyObject in fetchResults {
                let title:String? = result.value(forKey: "title") as? String
                let saveDate: Date? = result.value(forKey: "saveDate") as? Date
                
                print("title:\(title) saveDate:\(saveDate)")
            
                todoList.add(["title":title,"saveDate":saveDate])
            }
        } catch {
        }
        
        todoListTableView.reloadData()
    }
    
    //追加ボタンが押された時
    @IBAction func tapSave(_ sender: UIButton) {
        //AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        //ToDoエンティティオブジェクトを作成
        let ToDo = NSEntityDescription.entity(forEntityName: "Todo", in: viewContext)
        
        //ToDoエンティティにレコード（行）を挿入するためのオブジェクトを作成
        let newRecord = NSManagedObject(entity: ToDo!, insertInto: viewContext)
        
        //値のセット
        newRecord.setValue(txtTitle.text, forKey: "title") //値を代入
        newRecord.setValue(Date(), forKey: "saveDate") //値を代入
        
        do{
            //レコード（行）の即時保存
            try viewContext.save()
            
            //再読み込み
            read()
        } catch {
        }
    }
    
    //削除ボタンが押された時
    @IBAction func tapDelete(_ sender: UIButton) {
        
        //AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        do {
            //削除するデータを取得
            let fetchResults = try viewContext.fetch(request)
            for result: AnyObject in fetchResults {
                let record = result as! NSManagedObject
                //一行ずつ削除
                viewContext.delete(record)
            }
            
            //削除した状態を保存
            try viewContext.save()
            
            //再読み込み
            read()
        } catch {
        }
        
    }
    
    
    //リターンキーが押された時
    @IBAction func tapReturn(_ sender: UITextField) {
    }
    
    // MARK:TableViewの処理
    
    //行数決定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    //リスト表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 文字を表示するセルの取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // 表示文字の設定
        var dic = todoList[indexPath.row] as! NSDictionary
        
        cell.textLabel?.text = dic["title"] as! String
        
        // 文字を設定したセルを返す
        return cell
    }
    
    //行が選択された時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var dic = todoList[indexPath.row] as! NSDictionary
        
        selectedDate = dic["saveDate"] as! Date
        
        performSegue(withIdentifier: "showDetail", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailVC = segue.destination as! detailViewController
        
        detailVC.dcSelectedDate = selectedDate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

