//
//  Note.swift
//  Memow
//
//  Created by jaewon Lee on 3/18/24.
//

import Foundation
import CoreData

class Note: ObservableObject, Hashable {
    @Published var id = UUID()
    @Published var title: String
    @Published var content: String
    @Published var date: Date
    @Published var offset: CGFloat = 0
    @Published var isSwiped: Bool = false

    init(
        id: UUID = UUID(),
        title: String,
        content: String,
        date: Date,
        offset: CGFloat = 0,
        isSwiped: Bool = false
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.date = date
        self.offset = offset
        self.isSwiped = isSwiped
    }

    // Hashable을 위한 메서드
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
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
