//
//  Note.swift
//  Memow
//
//  Created by jaewon Lee on 3/18/24.
//

import Foundation

struct Note: Hashable {
    let id: String
    var title: String
    var content: String
    var date: Date
    
    init(id: String, title: String, content: String, date: Date) {
        self.id = id
        self.title = title
        self.content = content
        self.date = date
    }
}
