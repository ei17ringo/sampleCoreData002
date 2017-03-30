//
//  detailViewController.swift
//  sampleCoreData002
//
//  Created by Eriko Ichinohe on 2017/03/30.
//  Copyright © 2017年 Eriko Ichinohe. All rights reserved.
//

import UIKit
import CoreData

class detailViewController: UIViewController {

    
    var dcSelectedDate = Date()
    
    @IBOutlet weak var saveDateLabel: UILabel!
    
    @IBOutlet weak var txtTitle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        //選択されたデータの読み取り
        read()
    
    }
    
    
    //既に存在するデータの読み込み処理
    func read(){
        
        //AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        //どのエンティティからdataを取得してくるか設定
        let query:NSFetchRequest<Todo> = Todo.fetchRequest()
        
        //絞り込み検索
        let namePredicte = NSPredicate(format: "saveDate = %@", dcSelectedDate as CVarArg)
        query.predicate = namePredicte

        do {
            //データを一括取得
            let fetchResults = try viewContext.fetch(query)
            
            //データの取得
            for result: AnyObject in fetchResults {
                let title:String? = result.value(forKey: "title") as? String
                let saveDate: Date? = result.value(forKey: "saveDate") as? Date
                
                print("title:\(title) saveDate:\(saveDate)")
                
                txtTitle.text = title!
                
                let df = DateFormatter()
                df.dateFormat = "yyyy/MM/dd"
                df.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
                saveDateLabel.text = df.string(from: saveDate!)
            }
        } catch {
        }
    }

    //更新ボタンが押された時
    @IBAction func tapUpdate(_ sender: UIButton) {
    
        //AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        //どのエンティティからdataを取得してくるか設定
        let query:NSFetchRequest<Todo> = Todo.fetchRequest()
        
        //絞り込み検索（更新したいデータを取得する）
        let namePredicte = NSPredicate(format: "saveDate = %@", dcSelectedDate as CVarArg)
        query.predicate = namePredicte
        
        do {
            //データを一括取得
            let fetchResults = try viewContext.fetch(query)
            
            //データの取得
            for result: AnyObject in fetchResults {
                
                //更新する準備（NSManagedObjectにダウンキャスト型変換)
                let record = result as! NSManagedObject
                
                //更新したいデータのセット
                record.setValue(txtTitle.text, forKey: "title")
                
                do{
                    //レコード（行）の即時保存
                    try viewContext.save()
                    
                } catch {
                }

            }
        } catch {
        }

    }
    
    //戻るボタンが押された時
    @IBAction func tapBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
