//
//  NoteListViewController.swift
//  MyNote
//
//  Created by zhaohui on 2019/4/8.
//  Copyright © 2019 zhaohui. All rights reserved.
//

import UIKit

class NoteListViewController: UIViewController {
    
    var noteList: Array<NoteModel> = Array()
    
    let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    let addButtonWidth: CGFloat = 120.0
    let addButtonHeight: CGFloat = 50.0
    var addButton: UIButton = UIButton(type: UIButton.ButtonType.contactAdd)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "笔记列表页"
        
        self.tableView.frame = self.view.bounds
        self.view.addSubview(self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.addButton.frame = CGRect(x: self.view.frame.width - addButtonWidth - 10.0, y: self.view.frame.height - addButtonHeight - 10.0, width: addButtonWidth, height: addButtonHeight)
        self.addButton.setTitle(" 添加新笔记", for: UIControl.State.normal)
        self.addButton.addTarget(self, action: #selector(addNewNote), for: UIControl.Event.touchUpInside)
//        self.view.addSubview(self.addButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestNoteList()
    }
    
    func requestNoteList() -> Void {
        let session = URLSession.shared
        let url = URL(string: "http://127.0.0.1:8888/get-posts")!
        let task = session.dataTask(with: url, completionHandler: {
            data, response, error in
            if data == nil || error != nil {
                print("Error: network error")
                return
            }
            
            let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            if jsonObject == nil {
                print("Error: data format error")
                return
            }
            
            self.noteList.removeAll()
            let res = jsonObject as? NSDictionary
            if res != nil && res!["data"] != nil {
                let data = res!["data"] as! NSArray
                for value in data {
                    let objectDict = value as? NSDictionary
                    if objectDict != nil {
                        let id = objectDict!.object(forKey: "id") as? Int
                        let title = objectDict!.object(forKey: "title") as? String
                        let timestamp = objectDict!.object(forKey: "createTime") as? Int
                        
                        if id != nil && title != nil && timestamp != nil {
                            let note = NoteModel(id: id!, title: title!, content: "", timestamp: timestamp!)
                            self.noteList.append(note)
                        }
                    }
                }
            }
            
            for note in self.noteList {
                print("元素：\(note.noteID), \(note.noteTitle), \(note.noteContent), \(note.noteTimestamp)")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        task.resume()
    }
    
    @objc func addNewNote() -> Void {
        let addViewController = NoteCreateViewController()
        self.navigationController?.pushViewController(addViewController, animated: true)
    }
}

extension NoteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = self.noteList[indexPath.row]
        let detailViewController = NoteDetailViewController()
        detailViewController.noteID = note.noteID
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0;
    }
}

extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "NoteListCellReuseIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? NoteListCell
        if cell == nil {
            cell = NoteListCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        
        let note = self.noteList[indexPath.row]
        cell!.bindData(data: note)
        return cell!
    }
    
}
