//
//  Notification.swift
//  Memow
//
//  Created by jaewon Lee on 8/16/24.
//

import Foundation

struct Notification: Hashable {
    let id: UUID
    var content: String
    
    init(
        id: UUID,
        content: String
    ) {
        self.id = id
        self.content = content
    }
}
