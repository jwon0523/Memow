//
//  Chat.swift
//  Memow
//
//  Created by jaewon Lee on 3/15/24.
//

import Foundation

struct Message: Hashable {
    let id: UUID
    var content: String
    let received: Bool
    let date: Date
    
    init(
        id: UUID,
        content: String,
        received: Bool = false,
        date: Date
    ) {
        self.id = id
        self.content = content
        self.received = received
        self.date = date
    }
}
