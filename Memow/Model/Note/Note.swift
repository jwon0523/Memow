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
}

extension NoteEntity {
    // NoteEntity를 Note로 변환
    var note: Note {
        return Note(
            id: id ?? UUID(),
            title: title ?? "",
            content: content ?? "",
            date: date ?? Date()
        )
    }
}
