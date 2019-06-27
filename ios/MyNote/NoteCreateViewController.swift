//
//  NoteCreateViewController.swift
//  MyNote
//
//  Created by zhaohui on 2019/5/18.
//  Copyright © 2019 zhaohui. All rights reserved.
//

import UIKit

class NoteCreateViewController: UIViewController {
    
    var titleTextField: UITextField = UITextField(frame: CGRect(x: 0.0, y: 64.0, width: 300.0, height: 50.0))
    var contentTextView: UITextView = UITextView(frame: CGRect(x: 0.0, y: 64.0 + 50.0, width: 300.0, height: 200.0))

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "新建笔记"
        self.view.backgroundColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItem.Style.done, target: self, action: #selector(addNewNote))
        
        setupUI()
    }

    func setupUI() -> Void {
        
        self.view.addSubview(self.titleTextField)
        self.view.addSubview(self.contentTextView)
        
        self.makeUp()
    }
    
    @objc func addNewNote() -> Void {
        let title = self.titleTextField.text
        let content = self.contentTextView.text
        if title == nil {
            return
        }
        
        let session = URLSession.shared
        let url = URL(string: "http://127.0.0.1:8080/create")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let parameters = ["note_title": title!, "note_content": content ?? ""]
        let postString = parameters.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
        let task = session.dataTask(with: request) { (data, response, error) in
            if data == nil || error != nil {
                print("Error: network error")
                return
            }
            
            let alert = UIAlertController(title: "新的笔记创建成功", message: nil, preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "我知道了", style: UIAlertAction.Style.default, handler: { (_) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            alert.addAction(action)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
        task.resume()
    }
    
    func makeUp() -> Void {
        let screenWidth = UIScreen.main.bounds.width
        let navigationBarHeight: CGFloat = 64.0
        let leftMargin: CGFloat = 10.0
        let topMargin: CGFloat = navigationBarHeight + 10.0
        let rowMargin: CGFloat = 8.0
        let titleTextFieldHeight: CGFloat = 50.0
        self.titleTextField.frame = CGRect(x: leftMargin, y: topMargin, width: screenWidth - leftMargin * 2, height: titleTextFieldHeight)
        self.titleTextField.font = UIFont.systemFont(ofSize: 16.0)
        self.titleTextField.placeholder = "标题"
        
        let contentTextViewHeight: CGFloat = 200.0
        self.contentTextView.frame = CGRect(x: leftMargin, y: self.titleTextField.frame.origin.y + titleTextFieldHeight + rowMargin, width: screenWidth - leftMargin * 2, height: contentTextViewHeight)
        self.contentTextView.font = UIFont.systemFont(ofSize: 14.0)
        self.contentTextView.text = "主要内容"
        self.contentTextView.textColor = UIColor.lightGray
    }
}
