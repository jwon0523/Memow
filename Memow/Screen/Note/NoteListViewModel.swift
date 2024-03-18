//
//  NoteListViewModel.swift
//  Memow
//
//  Created by jaewon Lee on 3/18/24.
//

import Foundation

class NoteListViewModel: ObservableObject {
    @Published var notes: [Note]
    @Published var isEditNoteMode: Bool
    @Published var removeNotes: [Note]
    @Published var isRemoveNoteAlert: Bool
    
    init(
        notes: [Note] = [],
        isEditNoteMode: Bool = false,
        removeNotes: [Note] = [],
        isRemoveNoteAlert: Bool = false
    ) {
        self.notes = notes
        self.isEditNoteMode = isEditNoteMode
        self.removeNotes = removeNotes
        self.isRemoveNoteAlert = isRemoveNoteAlert
    }
}
