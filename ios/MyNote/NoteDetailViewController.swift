//
//  NoteDetailViewController.swift
//  MyNote
//
//  Created by zhaohui on 2019/4/8.
//  Copyright © 2019 zhaohui. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {
    
    var noteID: Int?
    var noteData: NoteModel?
    
    var timestampLabel: UILabel = UILabel(frame: CGRect(x: 0.0, y: 64.0, width: 300.0, height: 15.0))
    var titleLabel: UILabel = UILabel(frame: CGRect(x: 0.0, y: 64.0 + 15.0, width: 300.0, height: 15.0))
    var contentLabel: UILabel = UILabel(frame: CGRect(x: 0.0, y: 64.0 + 15.0 + 15.0, width: 300.0, height: 15.0))

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        setupUI()
        requestNoteDetailData()
    }
    
    func setupUI() -> Void {
        
        self.view.addSubview(self.timestampLabel)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.contentLabel)
        
        self.makeUp_1()
    }
    
    func requestNoteDetailData() -> Void {
        if self.noteID == nil {
            return
        }
        let session = URLSession.shared
        let url = URL(string: "http://127.0.0.1:8888/get-post/" + "\(self.noteID!)")!
        let task = session.dataTask(with: url, completionHandler: {
            data, response, error in
            if data == nil || error != nil {
                print("Error: network error")
                self.noteData = nil
                return
            }
            
            let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            if jsonObject == nil {
                print("Error: data format error")
                self.noteData = nil
                return
            }
            
            let res = jsonObject as? NSDictionary
            if res != nil && res!["data"] != nil {
                let contentData = res!["data"] as? NSDictionary
                let id = contentData!.object(forKey: "id") as? Int
                let title = contentData!.object(forKey: "title") as? String
                let content = contentData!.object(forKey: "content") as? String
                let timestamp = contentData!.object(forKey: "createTime") as? Int
                
                if id != nil && title != nil && content != nil && timestamp != nil {
                    let note = NoteModel(id: id!, title: title!, content: content!, timestamp: timestamp!)
                    self.noteData = note
                }
            } else {
                self.noteData = nil
            }
            
            DispatchQueue.main.async {
                self.bindData()
            }
        })
        task.resume()
    }
    
    func bindData() -> Void {
        if self.noteData == nil {
            return
        }
        
        self.timestampLabel.text = self.noteData?.getDateStr()
        self.titleLabel.text = self.noteData?.noteTitle
        
        self.contentLabel.text = self.noteData?.getPlainContent()
        
        self.makeUp_2()
    }

    
    func makeUp_1() -> Void {
        let screenWidth = UIScreen.main.bounds.width
        let navigationBarHeight: CGFloat = 64.0
        let leftMargin: CGFloat = 10.0
        let topMargin: CGFloat = navigationBarHeight + 10.0
        let timestampLabelHeight: CGFloat = 15.0
        self.timestampLabel.frame = CGRect(x: leftMargin, y: topMargin, width: screenWidth - leftMargin * 2, height: timestampLabelHeight)
        self.timestampLabel.font = UIFont.systemFont(ofSize: 14.0)
        self.timestampLabel.textColor = UIColor(red: 24.0 / 255.0, green: 144.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        
        let rowMargin: CGFloat = 8.0
        let titleLabelHeight: CGFloat = 20.0
        self.titleLabel.frame = CGRect(x: leftMargin, y: self.timestampLabel.frame.origin.y + timestampLabelHeight + rowMargin, width: screenWidth - leftMargin * 2, height: titleLabelHeight)
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.numberOfLines = 0
        
        let contentLabelHeight: CGFloat = 35.0
        self.contentLabel.frame = CGRect(x: leftMargin, y: self.titleLabel.frame.origin.y + titleLabelHeight + rowMargin, width: screenWidth - leftMargin * 2, height: contentLabelHeight)
        self.contentLabel.font = UIFont.systemFont(ofSize: 14.0)
        self.contentLabel.textColor = UIColor.gray
        self.contentLabel.numberOfLines = 0
    }
    
    func makeUp_2() -> Void {
        var size = self.titleLabel.sizeThatFits(CGSize(width: self.titleLabel.frame.width, height: CGFloat.greatestFiniteMagnitude))
        self.titleLabel.frame = CGRect(origin: self.titleLabel.frame.origin, size: size)
        
        size = self.contentLabel.sizeThatFits(CGSize(width: self.contentLabel.frame.width, height: CGFloat.greatestFiniteMagnitude))
        self.contentLabel.frame = CGRect(x: self.contentLabel.frame.origin.x, y: self.titleLabel.frame.origin.y + self.titleLabel.frame.height + 8.0, width: size.width, height: size.height)
    }

}
