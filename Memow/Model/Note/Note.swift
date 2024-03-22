//
//  Note.swift
//  Memow
//
//  Created by jaewon Lee on 3/18/24.
//

import Foundation

struct Note: Hashable {
    var id = UUID()
    var title: String
    var content: String
    var date: Date    
}
