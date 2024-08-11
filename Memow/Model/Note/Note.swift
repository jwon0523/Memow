//
//  Note.swift
//  Memow
//
//  Created by jaewon Lee on 3/18/24.
//

import Foundation
import CoreData

struct Note: Hashable {
    var id = UUID()
    var title: String
    var content: String
    var date: Date
    var offset: CGFloat = 0
    var isSwiped: Bool = false
}

extension NoteEntity {
    // NoteEntity를 Note로 변환
    var note: Note {
        get {
            return Note(
                id: id ?? UUID(),
                title: title ?? "",
                content: content ?? "",
                date: date ?? Date()
            )
        }
        set {
            self.id = newValue.id
            self.title = newValue.title
            self.content = newValue.content
            self.date = newValue.date
        }
    }
}
