//
//  NoticeData.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 18..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import Foundation

public class NoticeData {
    
    public var title: String
    public var contents: [ContentData]?
    
    init(title: String, contents: [ContentData]?) {
        self.title = title
        self.contents = contents
    }
}

public class ContentData {
    public var content: String
    
    init(content: String) {
        self.content = content
    }
}
