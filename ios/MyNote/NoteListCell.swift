//
//  NoteListCell.swift
//  MyNote
//
//  Created by zhaohui on 2019/5/18.
//  Copyright © 2019 zhaohui. All rights reserved.
//

import UIKit

class NoteListCell: UITableViewCell {

    var timestampLabel: UILabel
    var titleLabel: UILabel
    var contentLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.timestampLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 300.0, height: 15.0))
        self.titleLabel = UILabel(frame: CGRect(x: 0.0, y: 15.0, width: 300.0, height: 15.0))
        self.contentLabel = UILabel(frame: CGRect(x: 0.0, y: 30.0, width: 300.0, height: 15.0))
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.timestampLabel)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.contentLabel)
        
        self.makeUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bindData(data: NoteModel?) -> Void {
        self.timestampLabel.text = data?.getDateStr()
        self.titleLabel.text = data?.noteTitle
        self.contentLabel.text = data?.noteContent
    }
    
    func makeUp() -> Void {
        let screenWidth = UIScreen.main.bounds.width
        let leftMargin: CGFloat = 10.0
        let topMargin: CGFloat = 10.0
        let timestampLabelHeight: CGFloat = 15.0
        self.timestampLabel.frame = CGRect(x: leftMargin, y: topMargin, width: screenWidth - leftMargin * 2, height: timestampLabelHeight)
        self.timestampLabel.font = UIFont.systemFont(ofSize: 14.0)
        self.timestampLabel.textColor = UIColor(red: 24.0 / 255.0, green: 144.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        
        let rowMargin: CGFloat = 8.0
        let titleLabelHeight: CGFloat = 20.0
        self.titleLabel.frame = CGRect(x: leftMargin, y: self.timestampLabel.frame.origin.y + timestampLabelHeight + rowMargin, width: screenWidth - leftMargin * 2, height: titleLabelHeight)
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.numberOfLines = 1
        
        let contentLabelHeight: CGFloat = 35.0
        self.contentLabel.frame = CGRect(x: leftMargin, y: self.titleLabel.frame.origin.y + titleLabelHeight + rowMargin, width: screenWidth - leftMargin * 2, height: contentLabelHeight)
        self.contentLabel.font = UIFont.systemFont(ofSize: 14.0)
        self.contentLabel.textColor = UIColor.gray
        self.contentLabel.numberOfLines = 2
    }
    
}
