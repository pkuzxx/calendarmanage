//
//  NoteModel.swift
//  MyNote
//
//  Created by zhaohui on 2019/5/17.
//  Copyright © 2019 zhaohui. All rights reserved.
//

import UIKit

class NoteModel: NSObject {
    var noteID: Int
    var noteTitle: String
    var noteContent: String
    var noteTimestamp: Int
    
    init(id: Int, title: String, content: String, timestamp: Int) {
        noteID = id
        noteTitle = title
        noteContent = content
        noteTimestamp = timestamp
        super.init()
    }
    
    func getDateStr() -> String {
        let unixTimestamp = Double(self.noteTimestamp)
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func getPlainContent() -> String {
        let encodedData = self.noteContent.data(using: String.Encoding.utf8)!
        let plainText = try! NSAttributedString(data: encodedData, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil).string
        
        return plainText
    }
}
